require 'puppet'
require 'pathname'
require 'puppet/type/x509_request'

describe 'The openssl provider for the x509_request type' do
  subject { Puppet::Type.type(:x509_request).provider(:openssl).new(resource) }

  let(:path) { '/tmp/foo.csr' }
  let(:resource) { Puppet::Type::X509_request.new(path: path) }

  context 'when not forcing key' do
    it 'exists? should return true if csr exists' do
      allow_any_instance_of(Pathname).to receive(:exist?).and_return(true)
      expect(subject.exists?).to eq(true)
    end

    it 'exists? should return false if csr exists' do
      allow_any_instance_of(Pathname).to receive(:exist?).and_return(false)
      expect(subject.exists?).to eq(false)
    end

    it 'creates a certificate with the proper options' do
      allow(subject).to receive(:openssl).with(
        'req', '-new',
        '-key', '/tmp/foo.key',
        '-config', '/tmp/foo.cnf',
        '-out', '/tmp/foo.csr'
      )
      subject.create
    end
  end

  context 'when using password' do
    it 'creates a certificate with the proper options' do
      resource[:password] = '2x6${'
      allow(subject).to receive(:openssl).with(
        'req', '-new',
        '-key', '/tmp/foo.key',
        '-config', '/tmp/foo.cnf',
        '-out', '/tmp/foo.csr',
        '-passin', 'pass:2x6${'
      )
      subject.create
    end
  end

  context 'when forcing key' do
    it 'exists? should return true if certificate exists and is synced' do
      resource[:force] = true
      allow(File).to receive(:read)
      allow_any_instance_of(Pathname).to receive(:exist?).and_return(true)
      c = OpenSSL::X509::Request.new # Fake certificate for mocking
      allow(OpenSSL::X509::Request).to receive(:new).and_return(c)
      allow(OpenSSL::PKey::RSA).to receive(:new)
      allow_any_instance_of(OpenSSL::X509::Request).to receive(:verify).and_return(true)
      expect(subject.exists?).to eq(true)
    end

    it 'exists? should return false if certificate exists and is not synced' do
      resource[:force] = true
      allow(File).to receive(:read)
      allow_any_instance_of(Pathname).to receive(:exist?).and_return(true)
      c = OpenSSL::X509::Request.new # Fake certificate for mocking
      allow(OpenSSL::X509::Request).to receive(:new).and_return(c)
      allow(OpenSSL::PKey::RSA).to receive(:new)
      allow_any_instance_of(OpenSSL::X509::Request).to receive(:verify).and_return(false)
      expect(subject.exists?).to eq(false)
    end

    it 'exists? should return false if certificate does not exist' do
      resource[:force] = true
      allow_any_instance_of(Pathname).to receive(:exist?).and_return(false)
      expect(subject.exists?).to eq(false)
    end
  end

  it 'deletes files' do
    allow_any_instance_of(Pathname).to receive(:delete)
    subject.destroy
  end
end
