require 'puppet'
require 'pathname'
require 'puppet/type/x509_csr'

RSpec.configure { |c| c.mock_with :mocha }

describe 'The openssl provider for the x509_csr type' do
  let (:path) { '/tmp/foo.csr' }
  let (:resource) { Puppet::Type::X509_csr.new({:path => path}) }
  subject { Puppet::Type.type(:x509_csr).provider(:openssl).new(resource) }

  it 'exists? should return true if csr exists' do
    Pathname.any_instance.expects(:exist?).returns(true)
    subject.exists?.should == true
  end

  it 'exists? should return false if csr exists' do
    Pathname.any_instance.expects(:exist?).returns(false)
    subject.exists?.should == false
  end

  it 'should create a certificate with the proper options' do
    subject.expects(:openssl).with(
      'req', '-new',
      '-key', '/tmp/foo.key',
      '-config', '/tmp/foo.cnf',
      '-out', '/tmp/foo.csr'
    )
    subject.create
  end

  it 'should delete files' do
    Pathname.any_instance.expects(:delete)
    subject.destroy
  end
end

