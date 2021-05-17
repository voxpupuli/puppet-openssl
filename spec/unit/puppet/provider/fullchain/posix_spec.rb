# rubocop:disable RSpec/InstanceVariable,RSpec/AnyInstance
require 'spec_helper'
require 'diff/lcs'
require 'puppet/type/fullchain'
require 'pathname'
require 'webmock/rspec'
require 'openssl'

describe Puppet::Type.type(:fullchain).provider(:posix) do
  before(:each) do
    root_url = 'http://example.org/root.pem'
    int_url = 'http://example.org/int.pem'
    # create root CA
    root_keys = OpenSSL::PKey::RSA.new(2049)
    @root_cert = OpenSSL::X509::Certificate.new
    @root_cert.version = 2
    @root_cert.serial = 1
    @root_cert.subject = OpenSSL::X509::Name.parse('/CN=Test Root CA')
    @root_cert.issuer = @root_cert.subject
    @root_cert.public_key = root_keys.public_key
    @root_cert.not_before = Time.now
    @root_cert.not_after = @root_cert.not_before + 10_800
    root_ef = OpenSSL::X509::ExtensionFactory.new
    root_ef.subject_certificate = @root_cert
    root_ef.issuer_certificate = @root_cert
    @root_cert.add_extension(root_ef.create_extension('subjectKeyIdentifier', 'hash'))
    @root_cert.add_extension(root_ef.create_extension('basicConstraints', 'CA:TRUE', true))
    @root_cert.add_extension(root_ef.create_extension('keyUsage', 'cRLSign,keyCertSign', true))
    @root_cert.add_extension(root_ef.create_extension('authorityInfoAccess', "caIssuers;URI:#{root_url}"))
    @root_cert.sign(root_keys, OpenSSL::Digest::SHA256.new)
    # creating intermediate CA#1
    int_keys = OpenSSL::PKey::RSA.new(2049)
    @int_cert = OpenSSL::X509::Certificate.new
    @int_cert.version = 2
    @int_cert.serial = 1
    @int_cert.subject = OpenSSL::X509::Name.parse('/CN=Test intermediate CA#1')
    @int_cert.issuer = @root_cert.subject
    @int_cert.public_key = int_keys.public_key
    @int_cert.not_before = Time.now
    @int_cert.not_after = @int_cert.not_before + 7200
    int_ef = OpenSSL::X509::ExtensionFactory.new
    int_ef.subject_certificate = @int_cert
    int_ef.issuer_certificate = @root_cert
    @int_cert.add_extension(int_ef.create_extension('subjectKeyIdentifier', 'hash'))
    @int_cert.add_extension(int_ef.create_extension('basicConstraints', 'CA:TRUE', true))
    @int_cert.add_extension(int_ef.create_extension('keyUsage', 'cRLSign,keyCertSign', true))
    @int_cert.add_extension(int_ef.create_extension('authorityInfoAccess', "caIssuers;URI:#{root_url}"))
    @int_cert.sign(root_keys, OpenSSL::Digest::SHA256.new)
    # creating intermediate CA#2
    int2_keys = OpenSSL::PKey::RSA.new(2049)
    @int2_cert = OpenSSL::X509::Certificate.new
    @int2_cert.version = 2
    @int2_cert.serial = 1
    @int2_cert.subject = OpenSSL::X509::Name.parse('/CN=Test intermediate CA#2')
    @int2_cert.issuer = @root_cert.subject
    @int2_cert.public_key = int2_keys.public_key
    @int2_cert.not_before = Time.now
    @int2_cert.not_after = @int2_cert.not_before + 7200
    int2_ef = OpenSSL::X509::ExtensionFactory.new
    int2_ef.subject_certificate = @int2_cert
    int2_ef.issuer_certificate = @root_cert
    @int2_cert.add_extension(int2_ef.create_extension('subjectKeyIdentifier', 'hash'))
    @int2_cert.add_extension(int2_ef.create_extension('basicConstraints', 'CA:TRUE', true))
    @int2_cert.add_extension(int2_ef.create_extension('keyUsage', 'cRLSign,keyCertSign', true))
    @int2_cert.add_extension(int2_ef.create_extension('authorityInfoAccess', "caIssuers;URI:#{root_url}"))
    @int2_cert.sign(root_keys, OpenSSL::Digest::SHA256.new)
    # create user certificate
    user_keys = OpenSSL::PKey::RSA.new(2049)
    @user_cert = OpenSSL::X509::Certificate.new
    @user_cert.version = 2
    @user_cert.serial = 1
    @user_cert.subject = OpenSSL::X509::Name.parse('/CN=Test user certificate')
    @user_cert.issuer = @int_cert.subject
    @user_cert.public_key = user_keys.public_key
    @user_cert.not_before = Time.now
    @user_cert.not_after = @user_cert.not_before + 3600
    user_ef = OpenSSL::X509::ExtensionFactory.new
    user_ef.subject_certificate = @user_cert
    user_ef.issuer_certificate = @int_cert
    @user_cert.add_extension(user_ef.create_extension('subjectKeyIdentifier', 'hash'))
    @user_cert.add_extension(user_ef.create_extension('basicConstraints', 'CA:FALSE'))
    @user_cert.add_extension(user_ef.create_extension('keyUsage', 'keyEncipherment,dataEncipherment,digitalSignature'))
    @user_cert.add_extension(user_ef.create_extension('authorityInfoAccess', "caIssuers;URI:#{int_url}"))
    @user_cert.sign(int_keys, OpenSSL::Digest::SHA256.new)

    resp_header = { 'Content-Type': 'application/x-x509-ca-cert' }
    stub_request(:get, root_url)
      .to_return(status: 200, body: @root_cert.to_pem, headers: resp_header)
    stub_request(:get, int_url)
      .to_return(status: 200, body: @int_cert.to_pem, headers: resp_header)
  end

  let(:path) { '/etc/ssl/certs/user_fullchain.pem' }
  let(:pathname) { Pathname.new(path) }
  let(:certificate) { '/etc/ssl/certs/user.pem' }
  let(:resource) { Puppet::Type::Fullchain.new(path: path, certificate: certificate) }
  let(:user_pem) { @user_cert.to_pem }
  let(:fullchain_pem) { @user_cert.to_pem + @int_cert.to_pem + @root_cert.to_pem }

  describe 'exists?' do
    it 'return false if file does not exist' do
      allow(pathname).to receive(:exist?).and_return(false)
      expect(resource.provider.exists?).to eq(false)
    end
    it 'return true if proper fullchain file exists' do
      allow_any_instance_of(Pathname).to receive(:exist?).and_return(true)
      allow_any_instance_of(OpenSSL::X509::Store).to receive(:add_file) do
        store = OpenSSL::X509::Store.new
        store.add_cert(@user_cert)
        store.add_cert(@int_cert)
        store.add_cert(@root_cert)
        store
      end
      allow(File).to receive(:read).with(path).and_return(fullchain_pem)
      expect(resource.provider.exists?).to eq(true)
    end
    it 'return false if fullchain contains wrong intermediate' do
      allow_any_instance_of(Pathname).to receive(:exist?).and_return(true)
      allow_any_instance_of(OpenSSL::X509::Store).to receive(:add_file) do
        store = OpenSSL::X509::Store.new
        store.add_cert(@user_cert)
        store.add_cert(@int2_cert)
        store.add_cert(@root_cert)
        store
      end
      allow(File).to receive(:read).with(path).and_return(fullchain_pem)
      expect(resource.provider.exists?).to eq(false)
    end
  end

  describe 'create' do
    it 'does correct fullchain file' do
      allow(File).to receive(:read).with(certificate).and_return(user_pem)
      fullchain_buf = StringIO.new
      allow(File).to receive(:open).with(path, 'wt').and_yield(fullchain_buf)
      resource.provider.create
      expect(fullchain_buf.string).to eq(fullchain_pem)
    end
  end

  describe 'destroy' do
    it 'deletes the file' do
      allow_any_instance_of(Pathname).to receive(:delete)
      resource.provider.destroy
    end
  end
end
