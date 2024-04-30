# frozen_string_literal: true

require 'spec_helper'
require 'puppet/util/inifile'
require 'pathname'
require 'puppet/type/x509_cert'

provider_class = Puppet::Type.type(:x509_cert).provider(:openssl)
describe 'The openssl provider for the x509_cert type' do
  let(:path) { '/tmp/foo.crt' }
  let(:resource) { Puppet::Type::X509_cert.new(path: path) }
  let(:cert) { OpenSSL::X509::Certificate.new }

  context 'when not forcing key' do
    it 'exists? should return true if certificate exists and is synced' do
      allow(File).to receive(:read)
      allow_any_instance_of(Pathname).to receive(:exist?).and_return(true) # rubocop:disable RSpec/AnyInstance
      c = OpenSSL::X509::Certificate.new # Fake certificate for mocking
      allow(OpenSSL::X509::Certificate).to receive(:new).and_return(c)
      expect(resource.provider.exists?).to be(true)
    end

    it 'exists? should return false if certificate does not exist' do
      allow_any_instance_of(Pathname).to receive(:exist?).and_return(false) # rubocop:disable RSpec/AnyInstance
      expect(resource.provider.exists?).to be(false)
    end

    it 'creates a certificate with the proper options' do
      expect(provider_class).to receive(:openssl).with([
                                                         'req',
                                                         '-config', '/tmp/foo.cnf',
                                                         '-new',
                                                         '-x509',
                                                         '-days', 3650,
                                                         '-key', '/tmp/foo.key',
                                                         '-out', '/tmp/foo.crt',
                                                         ['-extensions', 'v3_req']
                                                       ])
      resource.provider.create
    end

    context 'when using password' do
      it 'creates a certificate with the proper options' do
        resource[:password] = '2x6${'
        expect(provider_class).to receive(:openssl).with([
                                                           'req',
                                                           '-config', '/tmp/foo.cnf',
                                                           '-new',
                                                           '-x509',
                                                           '-days', 3650,
                                                           '-key', '/tmp/foo.key',
                                                           '-out', '/tmp/foo.crt',
                                                           ['-passin', 'pass:2x6${'],
                                                           ['-extensions', 'v3_req']
                                                         ])
        resource.provider.create
      end
    end
  end

  context 'when using a CA for signing' do
    it 'creates a certificate with the proper options' do
      resource[:csr] = '/tmp/foo.csr'
      resource[:ca]  = '/tmp/foo-ca.crt'
      resource[:cakey] = '/tmp/foo-ca.key'
      expect(provider_class).to receive(:openssl).with([
                                                         'x509',
                                                         '-req',
                                                         '-days', 3650,
                                                         '-in', '/tmp/foo.csr',
                                                         '-out', '/tmp/foo.crt',
                                                         ['-extfile', '/tmp/foo.cnf'],
                                                         ['-CAcreateserial'],
                                                         ['-CA', '/tmp/foo-ca.crt'],
                                                         ['-CAkey', '/tmp/foo-ca.key'],
                                                         ['-extensions', 'v3_req']
                                                       ])
      resource.provider.create
    end
  end

  context 'when forcing key' do
    it 'exists? should return true if certificate exists and is synced' do
      resource[:force] = true
      allow(File).to receive(:read)
      allow_any_instance_of(Pathname).to receive(:exist?).and_return(true) # rubocop:disable RSpec/AnyInstance
      allow(OpenSSL::X509::Certificate).to receive(:new).and_return(cert)
      allow(OpenSSL::PKey::RSA).to receive(:new)
      expect(cert).to receive(:check_private_key).and_return(true)
      expect(resource.provider.exists?).to be(true)
    end

    it 'exists? should return false if certificate exists and is not synced' do
      resource[:force] = true
      allow(File).to receive(:read)
      allow_any_instance_of(Pathname).to receive(:exist?).and_return(true) # rubocop:disable RSpec/AnyInstance
      allow(OpenSSL::X509::Certificate).to receive(:new).and_return(cert)
      allow(OpenSSL::PKey::RSA).to receive(:new)
      expect(cert).to receive(:check_private_key).and_return(false)
      expect(resource.provider.exists?).to be(false)
    end

    it 'exists? should return false if certificate does not exist' do
      resource[:force] = true
      allow_any_instance_of(Pathname).to receive(:exist?).and_return(false) # rubocop:disable RSpec/AnyInstance
      expect(resource.provider.exists?).to be(false)
    end
  end

  it 'deletes files' do
    allow_any_instance_of(Pathname).to receive(:delete) # rubocop:disable RSpec/AnyInstance
    resource.provider.destroy
  end
end
