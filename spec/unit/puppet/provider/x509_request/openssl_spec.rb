# frozen_string_literal: true

require 'puppet'
require 'pathname'
require 'puppet/type/x509_request'

provider_class = Puppet::Type.type(:x509_request).provider(:openssl)
describe 'The openssl provider for the x509_request type' do
  let(:path) { '/tmp/foo.csr' }
  let(:resource) { Puppet::Type::X509_request.new(path: path) }
  let(:cert) { OpenSSL::X509::Request.new }

  context 'when not forcing key' do
    it 'exists? should return true if csr exists' do
      allow_any_instance_of(Pathname).to receive(:exist?).and_return(true) # rubocop:disable RSpec/AnyInstance
      expect(resource.provider.exists?).to eq(true)
    end

    it 'exists? should return false if csr exists' do
      allow_any_instance_of(Pathname).to receive(:exist?).and_return(false) # rubocop:disable RSpec/AnyInstance
      expect(resource.provider.exists?).to eq(false)
    end

    it 'creates a certificate with the proper options' do
      expect(provider_class).to receive(:openssl).with([
                                                         'req', '-new',
                                                         '-key', '/tmp/foo.key',
                                                         '-config', '/tmp/foo.cnf',
                                                         '-out', '/tmp/foo.csr'
                                                       ])
      resource.provider.create
    end
  end

  context 'when using password' do
    it 'creates a certificate with the proper options' do
      resource[:password] = '2x6${'
      expect(provider_class).to receive(:openssl).with([
                                                         'req', '-new',
                                                         '-key', '/tmp/foo.key',
                                                         '-config', '/tmp/foo.cnf',
                                                         '-out', '/tmp/foo.csr',
                                                         ['-passin', 'pass:2x6${']
                                                       ])
      resource.provider.create
    end
  end

  context 'when forcing key' do
    it 'exists? should return true if certificate exists and is synced' do
      resource[:force] = true
      allow(File).to receive(:read)
      allow_any_instance_of(Pathname).to receive(:exist?).and_return(true) # rubocop:disable RSpec/AnyInstance
      allow(OpenSSL::X509::Request).to receive(:new).and_return(cert)
      allow(OpenSSL::PKey::RSA).to receive(:new)
      expect(cert).to receive(:verify).and_return(true)
      expect(resource.provider.exists?).to eq(true)
    end

    it 'exists? should return false if certificate exists and is not synced' do
      resource[:force] = true
      allow(File).to receive(:read)
      allow_any_instance_of(Pathname).to receive(:exist?).and_return(true) # rubocop:disable RSpec/AnyInstance
      allow(OpenSSL::X509::Request).to receive(:new).and_return(cert)
      allow(OpenSSL::PKey::RSA).to receive(:new)
      expect(cert).to receive(:verify).and_return(false)
      expect(resource.provider.exists?).to eq(false)
    end

    it 'exists? should return false if certificate does not exist' do
      resource[:force] = true
      allow_any_instance_of(Pathname).to receive(:exist?).and_return(false) # rubocop:disable RSpec/AnyInstance
      expect(resource.provider.exists?).to eq(false)
    end
  end

  it 'deletes files' do
    allow_any_instance_of(Pathname).to receive(:delete) # rubocop:disable RSpec/AnyInstance
    resource.provider.destroy
  end
end
