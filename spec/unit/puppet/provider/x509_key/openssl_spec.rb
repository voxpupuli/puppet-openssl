require 'puppet'
require 'pathname'
require 'puppet/type/x509_key'

RSpec.configure { |c| c.mock_with :mocha }

describe 'The openssl provider for the x509_key type' do
  let (:path) { '/tmp/foo.key' }
  let (:resource) { Puppet::Type::X509_key.new({:path => path}) }
  subject { Puppet::Type.type(:x509_key).provider(:openssl).new(resource) }

  it 'exists? should return true if key exists' do
    Pathname.any_instance.expects(:exist?).returns(true)
    subject.exists?.should == true
  end

  it 'exists? should return false if certificate does not exist' do
    Pathname.any_instance.expects(:exist?).returns(false)
    subject.exists?.should == false
  end

  context 'when creating a key with defaults' do
    it 'should create an rsa key' do
      subject.expects(:openssl).with(
        'genrsa', '-des3',
        '-out', '/tmp/foo.key', 2048
      )
      subject.create
    end

    context 'when setting size' do
      it 'should create with given size' do
        resource[:size] = 1024
        subject.expects(:openssl).with(
          'genrsa', '-des3',
          '-out', '/tmp/foo.key', 1024
        )
        subject.create
      end
    end
  end

  context 'when setting authentication to rsa' do
    it 'should create an dsa key' do
      resource[:authentication] = :rsa
      subject.expects(:openssl).with(
        'genrsa', '-des3',
        '-out', '/tmp/foo.key', 2048
      )
      subject.create
    end

    context 'when setting size' do
      it 'should create with given size' do
        resource[:authentication] = :rsa
        resource[:size] = 1024
        subject.expects(:openssl).with(
          'genrsa', '-des3',
          '-out', '/tmp/foo.key', 1024
        )
        subject.create
      end
    end
  end

  context 'when setting authentication to dsa' do
    it 'should create an dsa key' do
      resource[:authentication] = :dsa
      Tempfile.any_instance.stubs(:path).returns('/tmp/dsaparam-bar.pem')
      subject.expects(:openssl).with(
        'dsaparam',
        '-out', '/tmp/dsaparam-bar.pem', 2048
      )
      subject.expects(:openssl).with(
        'gendsa', '-des3',
        '-out', '/tmp/foo.key', '/tmp/dsaparam-bar.pem'
      )
      subject.create
    end

    context 'when setting size' do
      it 'should create with given size' do
        resource[:authentication] = :dsa
        resource[:size] = 1024
        Tempfile.any_instance.stubs(:path).returns('/tmp/dsaparam-bar.pem')
        subject.expects(:openssl).with(
          'dsaparam',
          '-out', '/tmp/dsaparam-bar.pem', 1024
        )
        subject.expects(:openssl).with(
          'gendsa', '-des3',
          '-out', '/tmp/foo.key', '/tmp/dsaparam-bar.pem'
        )
        subject.create
      end
    end
  end

  it 'should delete files' do
    Pathname.any_instance.expects(:delete)
    subject.destroy
  end
end
