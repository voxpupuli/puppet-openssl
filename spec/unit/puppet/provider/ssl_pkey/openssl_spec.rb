require 'puppet'
require 'pathname'
require 'puppet/type/ssl_pkey'

# rubocop:disable RSpec/MessageSpies
describe 'The openssl provider for the ssl_pkey type' do
  let(:path) { '/tmp/foo.key' }
  let(:pathname) { Pathname.new(path) }
  let(:resource) { Puppet::Type::Ssl_pkey.new(path: path) }
  let(:key) { OpenSSL::PKey::RSA.new }

  it 'exists? should return true if key exists' do
    expect(Pathname).to receive(:new).twice.with(path).and_return(pathname)
    expect(pathname).to receive(:exist?).and_return(true)
    expect(resource.provider.exists?).to eq(true)
  end

  it 'exists? should return false if certificate does not exist' do
    expect(Pathname).to receive(:new).twice.with(path).and_return(pathname)
    expect(pathname).to receive(:exist?).and_return(false)
    expect(resource.provider.exists?).to eq(false)
  end

  context 'when creating a key with defaults' do
    it 'creates an rsa key' do
      allow(OpenSSL::PKey::RSA).to receive(:new).with(2048).and_return(key)
      allow(File).to receive(:open).with('/tmp/foo.key', 'w')
      resource.provider.create
    end

    context 'when setting size' do
      it 'creates with given size' do
        resource[:size] = 1024
        allow(OpenSSL::PKey::RSA).to receive(:new).with(1024).and_return(key)
        allow(File).to receive(:open).with('/tmp/foo.key', 'w')
        resource.provider.create
      end
    end

    context 'when setting password' do
      it 'creates with given password' do
        resource[:password] = '2x$5{'
        allow(OpenSSL::PKey::RSA).to receive(:new).with(2048).and_return(key)
        allow(OpenSSL::Cipher).to receive(:new).with('des3')
        allow(File).to receive(:open).with('/tmp/foo.key', 'w')
        resource.provider.create
      end
    end
  end

  context 'when setting authentication to rsa' do
    it 'creates a dsa key' do
      resource[:authentication] = :rsa
      allow(OpenSSL::PKey::RSA).to receive(:new).with(2048).and_return(key)
      allow(File).to receive(:open).with('/tmp/foo.key', 'w')
      resource.provider.create
    end

    context 'when setting size' do
      it 'creates with given size' do
        resource[:authentication] = :rsa
        resource[:size] = 1024
        allow(OpenSSL::PKey::RSA).to receive(:new).with(1024).and_return(key)
        allow(File).to receive(:open).with('/tmp/foo.key', 'w')
        resource.provider.create
      end
    end

    context 'when setting password' do
      it 'creates with given password' do
        resource[:authentication] = :rsa
        resource[:password] = '2x$5{'
        allow(OpenSSL::PKey::RSA).to receive(:new).with(2048).and_return(key)
        allow(OpenSSL::Cipher).to receive(:new).with('des3')
        allow(File).to receive(:open).with('/tmp/foo.key', 'w')
        resource.provider.create
      end
    end
  end

  context 'when setting authentication to dsa' do
    it 'creates a dsa key' do
      resource[:authentication] = :dsa
      allow(OpenSSL::PKey::DSA).to receive(:new).with(2048).and_return(key)
      allow(File).to receive(:open).with('/tmp/foo.key', 'w')
      resource.provider.create
    end

    context 'when setting size' do
      it 'creates with given size' do
        resource[:authentication] = :dsa
        resource[:size] = 1024
        allow(OpenSSL::PKey::DSA).to receive(:new).with(1024).and_return(key)
        allow(File).to receive(:open).with('/tmp/foo.key', 'w')
        resource.provider.create
      end
    end

    context 'when setting password' do
      it 'creates with given password' do
        resource[:authentication] = :dsa
        resource[:password] = '2x$5{'
        allow(OpenSSL::PKey::DSA).to receive(:new).with(2048).and_return(key)
        allow(OpenSSL::Cipher).to receive(:new).with('des3')
        allow(File).to receive(:open).with('/tmp/foo.key', 'w')
        resource.provider.create
      end
    end
  end

  context 'when setting authentication to ec' do
    key = OpenSSL::PKey::EC.new('secp384r1').generate_key # For mocking

    it 'creates an ec key' do
      resource[:authentication] = :ec
      allow(OpenSSL::PKey::EC).to receive(:new).with('secp384r1').and_return(key)
      allow(File).to receive(:open).with('/tmp/foo.key', 'w')
      resource.provider.create
    end

    context 'when setting curve' do
      it 'creates with given curve' do
        resource[:authentication] = :ec
        resource[:curve] = 'prime239v1'
        allow(OpenSSL::PKey::EC).to receive(:new).with('prime239v1').and_return(key)
        allow(File).to receive(:open).with('/tmp/foo.key', 'w')
        resource.provider.create
      end
    end

    context 'when setting password' do
      it 'creates with given password' do
        resource[:authentication] = :ec
        resource[:password] = '2x$5{'
        allow(OpenSSL::PKey::EC).to receive(:new).with('secp384r1').and_return(key)
        allow(OpenSSL::Cipher).to receive(:new).with('des3')
        allow(File).to receive(:open).with('/tmp/foo.key', 'w')
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
