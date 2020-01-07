require 'puppet'
require 'pathname'
require 'puppet/type/ssl_pkey'

describe 'The openssl provider for the ssl_pkey type' do
  subject { Puppet::Type.type(:ssl_pkey).provider(:openssl).new(resource) }

  let(:path) { '/tmp/foo.key' }
  let(:resource) { Puppet::Type::Ssl_pkey.new(path: path) }

  key = OpenSSL::PKey::RSA.new # For mocking

  it 'exists? should return true if key exists' do
    allow_any_instance_of(Pathname).to receive(:exist?).and_return(true)
    expect(subject.exists?).to eq(true)
  end

  it 'exists? should return false if certificate does not exist' do
    allow_any_instance_of(Pathname).to receive(:exist?).and_return(false)
    expect(subject.exists?).to eq(false)
  end

  context 'when creating a key with defaults' do
    it 'creates an rsa key' do
      allow(OpenSSL::PKey::RSA).to receive(:new).with(2048).and_return(key)
      allow(File).to receive(:open).with('/tmp/foo.key', 'w')
      subject.create
    end

    context 'when setting size' do
      it 'creates with given size' do
        resource[:size] = 1024
        allow(OpenSSL::PKey::RSA).to receive(:new).with(1024).and_return(key)
        allow(File).to receive(:open).with('/tmp/foo.key', 'w')
        subject.create
      end
    end

    context 'when setting password' do
      it 'creates with given password' do
        resource[:password] = '2x$5{'
        allow(OpenSSL::PKey::RSA).to receive(:new).with(2048).and_return(key)
        allow(OpenSSL::Cipher).to receive(:new).with('des3')
        allow(File).to receive(:open).with('/tmp/foo.key', 'w')
        subject.create
      end
    end
  end

  context 'when setting authentication to rsa' do
    it 'creates a dsa key' do
      resource[:authentication] = :rsa
      allow(OpenSSL::PKey::RSA).to receive(:new).with(2048).and_return(key)
      allow(File).to receive(:open).with('/tmp/foo.key', 'w')
      subject.create
    end

    context 'when setting size' do
      it 'creates with given size' do
        resource[:authentication] = :rsa
        resource[:size] = 1024
        allow(OpenSSL::PKey::RSA).to receive(:new).with(1024).and_return(key)
        allow(File).to receive(:open).with('/tmp/foo.key', 'w')
        subject.create
      end
    end

    context 'when setting password' do
      it 'creates with given password' do
        resource[:authentication] = :rsa
        resource[:password] = '2x$5{'
        allow(OpenSSL::PKey::RSA).to receive(:new).with(2048).and_return(key)
        allow(OpenSSL::Cipher).to receive(:new).with('des3')
        allow(File).to receive(:open).with('/tmp/foo.key', 'w')
        subject.create
      end
    end
  end

  context 'when setting authentication to dsa' do
    it 'creates a dsa key' do
      resource[:authentication] = :dsa
      allow(OpenSSL::PKey::DSA).to receive(:new).with(2048).and_return(key)
      allow(File).to receive(:open).with('/tmp/foo.key', 'w')
      subject.create
    end

    context 'when setting size' do
      it 'creates with given size' do
        resource[:authentication] = :dsa
        resource[:size] = 1024
        allow(OpenSSL::PKey::DSA).to receive(:new).with(1024).and_return(key)
        allow(File).to receive(:open).with('/tmp/foo.key', 'w')
        subject.create
      end
    end

    context 'when setting password' do
      it 'creates with given password' do
        resource[:authentication] = :dsa
        resource[:password] = '2x$5{'
        allow(OpenSSL::PKey::DSA).to receive(:new).with(2048).and_return(key)
        allow(OpenSSL::Cipher).to receive(:new).with('des3')
        allow(File).to receive(:open).with('/tmp/foo.key', 'w')
        subject.create
      end
    end
  end

  context 'when setting authentication to ec' do
    key = OpenSSL::PKey::EC.new('secp384r1').generate_key # For mocking

    it 'creates an ec key' do
      resource[:authentication] = :ec
      allow(OpenSSL::PKey::EC).to receive(:new).with('secp384r1').and_return(key)
      allow(File).to receive(:open).with('/tmp/foo.key', 'w')
      subject.create
    end

    context 'when setting curve' do
      it 'creates with given curve' do
        resource[:authentication] = :ec
        resource[:curve] = 'prime239v1'
        allow(OpenSSL::PKey::EC).to receive(:new).with('prime239v1').and_return(key)
        allow(File).to receive(:open).with('/tmp/foo.key', 'w')
        subject.create
      end
    end

    context 'when setting password' do
      it 'creates with given password' do
        resource[:authentication] = :ec
        resource[:password] = '2x$5{'
        allow(OpenSSL::PKey::EC).to receive(:new).with('secp384r1').and_return(key)
        allow(OpenSSL::Cipher).to receive(:new).with('des3')
        allow(File).to receive(:open).with('/tmp/foo.key', 'w')
        subject.create
      end
    end
  end

  it 'deletes files' do
    allow_any_instance_of(Pathname).to receive(:delete)
    subject.destroy
  end
end
