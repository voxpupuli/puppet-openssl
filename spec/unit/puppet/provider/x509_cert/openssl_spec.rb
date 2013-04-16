require 'puppet'
require 'pathname'
require 'puppet/type/x509_cert'

RSpec.configure { |c| c.mock_with :mocha }

describe 'The openssl provider for the x509_cert type' do
  let (:path) { '/tmp/foo' }
  let (:resource) { Puppet::Type::X509_cert.new({:path => path}) }
  subject { Puppet::Type.type(:x509_cert).provider(:openssl).new(resource) }

  it 'exists? should return true if certificate and key exist' do
    Pathname.any_instance.expects(:exist?).twice.returns(true)
    subject.exists?.should == true
  end

  it 'exists? should return false if certificate does not exist' do
    Pathname.any_instance.expects(:exist?).once.returns(false)
    subject.exists?.should == false
  end

  it 'exists? should return false if key does not exist' do
    Pathname.any_instance.expects(:exist?).twice.returns(true).then.returns(false)
    subject.exists?.should == false
  end

  it 'should create a certificate with the proper options' do
    subject.expects(:openssl).with(
      'req', '-config', "/tmp/foo.cnf", '-new', '-x509',
      '-nodes', '-days', 3650,
      '-out', "/tmp/foo.crt",
      '-keyout', "/tmp/foo.key"
    )
    subject.create
  end

  it 'should delete files' do
    Pathname.any_instance.expects(:delete).twice
    subject.destroy
  end
end
