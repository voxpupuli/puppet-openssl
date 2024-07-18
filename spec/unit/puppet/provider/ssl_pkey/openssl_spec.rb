# frozen_string_literal: true

require 'puppet'
require 'pathname'
require 'puppet/type/ssl_pkey'

describe 'The openssl provider for the ssl_pkey type' do
  let(:path) { '/tmp/foo.key' }
  let(:pathname) { Pathname.new(path) }
  let(:resource) { Puppet::Type::Ssl_pkey.new(path: path) }

  it 'exists? should return true if key exists' do
    expect(Pathname).to receive(:new).twice.with(path).and_return(pathname)
    expect(pathname).to receive(:exist?).and_return(true)
    expect(resource.provider.exists?).to be(true)
  end

  it 'exists? should return false if certificate does not exist' do
    expect(Pathname).to receive(:new).twice.with(path).and_return(pathname)
    expect(pathname).to receive(:exist?).and_return(false)
    expect(resource.provider.exists?).to be(false)
  end

  context 'when creating a key with defaults' do
    it 'creates an rsa key' do
      expect(OpenSSL::PKey::RSA).to receive(:new).with(2048).and_call_original
      expect(File).to receive(:write).with('/tmp/foo.key', kind_of(String))
      resource.provider.create
    end

    context 'when setting size' do
      it 'creates with given size' do
        resource[:size] = 1024
        expect(OpenSSL::PKey::RSA).to receive(:new).with(1024).and_call_original
        expect(File).to receive(:write).with('/tmp/foo.key', kind_of(String))
        resource.provider.create
      end
    end

    context 'when setting password' do
      it 'creates with given password' do
        resource[:password] = '2x$5{'
        expect(OpenSSL::PKey::RSA).to receive(:new).with(2048).and_call_original
        expect(OpenSSL::Cipher).to receive(:new).with('aes-256-cbc')
        expect(File).to receive(:write).with('/tmp/foo.key', kind_of(String))
        resource.provider.create
      end
    end
  end

  context 'when setting authentication to rsa' do
    it 'creates an rsa key' do
      resource[:authentication] = :rsa
      expect(OpenSSL::PKey::RSA).to receive(:new).with(2048).and_call_original
      expect(File).to receive(:write).with('/tmp/foo.key', kind_of(String))
      resource.provider.create
    end

    context 'when setting size' do
      it 'creates with given size' do
        resource[:authentication] = :rsa
        resource[:size] = 1024
        expect(OpenSSL::PKey::RSA).to receive(:new).with(1024).and_call_original
        expect(File).to receive(:write).with('/tmp/foo.key', kind_of(String))
        resource.provider.create
      end
    end

    context 'when setting password' do
      it 'creates with given password' do
        resource[:authentication] = :rsa
        resource[:password] = '2x$5{'
        expect(OpenSSL::PKey::RSA).to receive(:new).with(2048).and_call_original
        expect(OpenSSL::Cipher).to receive(:new).with('aes-256-cbc')
        expect(File).to receive(:write).with('/tmp/foo.key', kind_of(String))
        resource.provider.create
      end
    end
  end

  context 'when setting authentication to ec' do
    it 'creates an ec key' do
      resource[:authentication] = :ec
      allow(OpenSSL::PKey::EC).to receive(:generate).with('secp384r1').and_call_original
      expect(File).to receive(:write).with('/tmp/foo.key', kind_of(String))
      resource.provider.create
    end

    context 'when setting curve' do
      it 'creates with given curve' do
        resource[:authentication] = :ec
        # See: openssl ecparam -list_curves
        resource[:curve] = 'prime256v1'
        expect(OpenSSL::PKey::EC).to receive(:generate).with('prime256v1').and_call_original
        expect(File).to receive(:write).with('/tmp/foo.key', kind_of(String))
        resource.provider.create
      end
    end

    context 'when setting password' do
      it 'creates with given password' do
        resource[:authentication] = :ec
        resource[:password] = '2x$5{'
        expect(OpenSSL::PKey::EC).to receive(:generate).with('secp384r1').and_call_original
        expect(OpenSSL::Cipher).to receive(:new).with('aes-256-cbc')
        expect(File).to receive(:write).with('/tmp/foo.key', kind_of(String))
        resource.provider.create
      end
    end
  end

  it 'deletes files' do
    expect(Pathname).to receive(:new).twice.with(path).and_return(pathname)
    expect(pathname).to receive(:delete)
    resource.provider.destroy
  end
end
