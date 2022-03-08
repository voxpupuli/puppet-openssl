# frozen_string_literal: true

require 'spec_helper'
require 'puppet/type/cert_file'
require 'pathname'
require 'webmock/rspec'
require 'openssl'
describe 'The POSIX provider for type cert_file' do
  before do
    test_keys = OpenSSL::PKey::RSA.new(2049)
    test_cert = OpenSSL::X509::Certificate.new
    test_cert.version = 2
    test_cert.serial = 1
    test_cert.subject = OpenSSL::X509::Name.parse('/CN=test-cert.example.org')
    test_cert.public_key = test_keys.public_key
    test_cert.not_before = Time.now
    test_cert.not_after = test_cert.not_before + 3600 # 1 hour
    test_cert.sign(test_keys, OpenSSL::Digest.new('SHA256'))

    resp_header = { 'Content-Type' => 'application/x-x509-ca-cert' }
    stub_request(:get, 'http://example.org/cert.der').
      to_return(status: 200, body: test_cert.to_der, headers: resp_header)
    stub_request(:get, 'http://example.org/cert.pem').
      to_return(status: 200, body: test_cert.to_pem, headers: resp_header)
  end

  let(:path) { '/tmp/test.pem' }
  let(:source) { 'http://example.org/cert.der' }
  let(:resource) { Puppet::Type::Cert_file.new(path: path, source: source) }

  it 'exists? returns false on arbitraty path' do
    allow_any_instance_of(Pathname).to receive(:exist?).and_return(false) # rubocop:disable RSpec/AnyInstance
    expect(resource.provider.exists?).to eq(false)
  end

  it 'downloads a certificate and stores it' do
    resource.provider.create
    expect(File).to exist(path)
  end

  context('default format and PEM provided') do
    it 'stored file is formatted as PEM' do
      resource.provider.create
      expect(File.read(path)).to include '-----BEGIN'
    end
  end

  context('default format and DER provided') do
    let(:source) { 'http://example.org/cert.pem' }
    let(:resource) { Puppet::Type::Cert_file.new(path: path, source: source) }

    it 'stored file is formatted as PEM' do
      resource.provider.create
      expect(File.read(path)).to include '-----BEGIN'
    end
  end

  context('DER format requested and PEM provided') do
    let(:path) { '/tmp/test.der' }
    let(:source) { 'http://example.org/cert.pem' }
    let(:resource) { Puppet::Type::Cert_file.new(path: path, source: source, format: :der) }

    it 'stored file is formatted as DER' do
      resource.provider.create
      expect(File.read(path)).not_to include '-----BEGIN'
    end
  end

  context('DER format requested and DER provided') do
    let(:path) { '/tmp/test.der' }
    let(:source) { 'http://example.org/cert.der' }
    let(:resource) { Puppet::Type::Cert_file.new(path: path, source: source, format: :der) }

    it 'stored file is formatted as DER' do
      resource.provider.create
      expect(File.read(path)).not_to include '-----BEGIN'
    end
  end
end
