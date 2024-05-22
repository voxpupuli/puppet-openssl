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
      expect(OpenSSL::PKey).to receive(:generate_key).with('RSA', { rsa_keygen_bits: 2048 }).and_call_original
      expect(File).to receive(:write).with('/tmp/foo.key', kind_of(String))
      resource.provider.create
    end

    context 'when setting size' do
      it 'creates with given size' do
        resource[:size] = 1024
        expect(OpenSSL::PKey).to receive(:generate_key).with('RSA', { rsa_keygen_bits: 1024 }).and_call_original
        expect(File).to receive(:write).with('/tmp/foo.key', kind_of(String))
        resource.provider.create
      end
    end

    context 'when setting password' do
      it 'creates with given password' do
        resource[:password] = '2x$5{'
        expect(OpenSSL::PKey).to receive(:generate_key).with('RSA', { rsa_keygen_bits: 2048 }).and_call_original
        allow(OpenSSL::Cipher).to receive(:new).with('des3')
        expect(File).to receive(:write).with('/tmp/foo.key', kind_of(String))
        resource.provider.create
      end
    end
  end

  context 'when setting authentication to rsa' do
    it 'creates an RSA key' do
      resource[:authentication] = :rsa
      expect(OpenSSL::PKey).to receive(:generate_key).with('RSA', { rsa_keygen_bits: 2048 }).and_call_original
      expect(File).to receive(:write).with('/tmp/foo.key', kind_of(String))
      resource.provider.create
    end

    context 'when setting size' do
      it 'creates with given size' do
        resource[:authentication] = :rsa
        resource[:size] = 1024
        expect(OpenSSL::PKey).to receive(:generate_key).with('RSA', { rsa_keygen_bits: 1024 }).and_call_original
        expect(File).to receive(:write).with('/tmp/foo.key', kind_of(String))
        resource.provider.create
      end
    end

    context 'when setting password' do
      it 'creates with given password' do
        resource[:authentication] = :rsa
        resource[:password] = '2x$5{'
        expect(OpenSSL::PKey).to receive(:generate_key).with('RSA', { rsa_keygen_bits: 2048 }).and_call_original
        allow(OpenSSL::Cipher).to receive(:new).with('des3')
        expect(File).to receive(:write).with('/tmp/foo.key', kind_of(String))
        resource.provider.create
      end
    end
  end

  context 'when setting authentication to dsa' do
    it 'creates a dsa key' do
      resource[:authentication] = :dsa
      expect(OpenSSL::PKey).to receive(:generate_key).with('DSA', { dsa_paramgen_bits: 2048 }).and_call_original
      expect(File).to receive(:write).with('/tmp/foo.key', kind_of(String))
      resource.provider.create
    end

    context 'when setting size' do
      it 'creates with given size' do
        resource[:authentication] = :dsa
        resource[:size] = 1024
        expect(OpenSSL::PKey).to receive(:generate_key).with('DSA', { dsa_paramgen_bits: 1024 }).and_call_original
        expect(File).to receive(:write).with('/tmp/foo.key', kind_of(String))
        resource.provider.create
      end
    end

    context 'when setting password' do
      it 'creates with given password' do
        resource[:authentication] = :dsa
        resource[:password] = '2x$5{'
        expect(OpenSSL::PKey).to receive(:generate_key).with('DSA', { dsa_paramgen_bits: 2048 }).and_call_original
        allow(OpenSSL::Cipher).to receive(:new).with('des3')
        expect(File).to receive(:write).with('/tmp/foo.key', kind_of(String))
        resource.provider.create
      end
    end
  end

  context 'when setting authentication to ec' do
    it 'creates an ec key with secp384r1 curve' do
      resource[:authentication] = :ec
      expect(OpenSSL::PKey).to receive(:generate_key).with('EC', { ec_paramgen_curve: 'secp384r1' }).and_call_original
      expect(File).to receive(:write).with('/tmp/foo.key', kind_of(String))
      resource.provider.create
    end

    context 'when setting curve to prime256v1' do
      it 'creates with given curve' do
        resource[:authentication] = :ec
        # See: openssl ecparam -list_curves
        resource[:curve] = 'prime256v1'
        expect(OpenSSL::PKey).to receive(:generate_key).with('EC', { ec_paramgen_curve: 'prime256v1' }).and_call_original
        expect(File).to receive(:write).with('/tmp/foo.key', kind_of(String))
        resource.provider.create
      end
    end

    context 'when setting password' do
      it 'creates with given password' do
        resource[:authentication] = :ec
        resource[:password] = '2x$5{'
        expect(OpenSSL::PKey).to receive(:generate_key).with('EC', { ec_paramgen_curve: 'secp384r1' }).and_call_original
        allow(OpenSSL::Cipher).to receive(:new).with('des3')
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
