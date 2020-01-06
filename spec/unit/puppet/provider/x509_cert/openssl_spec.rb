require 'spec_helper'
require 'puppet/util/inifile'
require 'pathname'
require 'puppet/type/x509_cert'

describe 'The openssl provider for the x509_cert type' do
  let (:path) { '/tmp/foo.crt' }
  let (:resource) { Puppet::Type::X509_cert.new({:path => path}) }
  subject { Puppet::Type.type(:x509_cert).provider(:openssl).new(resource) }

  context 'when not forcing key' do
    it 'exists? should return true if certificate exists and is synced' do
      allow(File).to receive(:read)
      allow_any_instance_of(Pathname).to receive(:exist?).and_return(true)
      c = OpenSSL::X509::Certificate.new # Fake certificate for mocking
      allow(OpenSSL::X509::Certificate).to receive(:new).and_return(c)
      expect(subject.exists?).to eq(true)
    end

    it 'exists? should return false if certificate does not exist' do
      allow_any_instance_of(Pathname).to receive(:exist?).and_return(false)
      expect(subject.exists?).to eq(false)
    end

    it 'should create a certificate with the proper options' do
      allow(subject).to receive(:openssl).with([
        'req', '-config', '/tmp/foo.cnf', '-new', '-x509',
        '-days', 3650,
        '-key', '/tmp/foo.key',
        '-out', '/tmp/foo.crt',
        ['-extensions', 'req_ext'],
      ])
      subject.create
    end

    context 'when using password' do
      it 'should create a certificate with the proper options' do
        resource[:password] = '2x6${'
        allow(subject).to receive(:openssl).with([
          'req', '-config', '/tmp/foo.cnf', '-new', '-x509',
          '-days', 3650,
          '-key', '/tmp/foo.key',
          '-out', '/tmp/foo.crt',
          ['-passin', 'pass:2x6${'],
          ['-extensions', 'req_ext'],
        ])
        subject.create
      end
    end
  end

  context 'when forcing key' do
    it 'exists? should return true if certificate exists and is synced' do
      resource[:force] = true
      allow(File).to receive(:read)
      allow_any_instance_of(Pathname).to receive(:exist?).and_return(true)
      c = OpenSSL::X509::Certificate.new # Fake certificate for mocking
      allow(OpenSSL::X509::Certificate).to receive(:new).and_return(c)
      allow(OpenSSL::PKey::RSA).to receive(:new)
      allow_any_instance_of(OpenSSL::X509::Certificate).to receive(:check_private_key).and_return(true)
      expect(subject.exists?).to eq(true)
    end

    it 'exists? should return false if certificate exists and is not synced' do
      resource[:force] = true
      allow(File).to receive(:read)
      allow_any_instance_of(Pathname).to receive(:exist?).and_return(true)
      c = OpenSSL::X509::Certificate.new # Fake certificate for mocking
      allow(OpenSSL::X509::Certificate).to receive(:new).and_return(c)
      allow(OpenSSL::PKey::RSA).to receive(:new)
      allow_any_instance_of(OpenSSL::X509::Certificate).to receive(:check_private_key).and_return(false)
      expect(subject.exists?).to eq(false)
    end

    it 'exists? should return false if certificate does not exist' do
      resource[:force] = true
      allow_any_instance_of(Pathname).to receive(:exist?).and_return(false)
      expect(subject.exists?).to eq(false)
    end
  end

  it 'should delete files' do
    allow_any_instance_of(Pathname).to receive(:delete)
    subject.destroy
  end
end
