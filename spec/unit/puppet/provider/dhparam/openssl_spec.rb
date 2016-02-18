require 'puppet'
require 'pathname'
require 'puppet/type/dhparam'

RSpec.configure { |c| c.mock_with :mocha }

describe 'The openssl provider for the dhparam type' do
  let (:path) { '/tmp/dhparam.pem' }
  let (:resource) { Puppet::Type::Dhparam.new({:path => path}) }
  subject { Puppet::Type.type(:dhparam).provider(:openssl).new(resource) }

  context 'when using default size' do
    it 'should create dhpram with the proper options' do
      subject.expects(:openssl).with([
        'dhparam',
        '-out', '/tmp/dhparam.pem',
        512
      ])
      subject.create
    end
  end
  context 'when setting size' do
    it 'should create dhpram with the proper options' do
      resource[:size] = 2048
      subject.expects(:openssl).with([
        'dhparam',
        '-out', '/tmp/dhparam.pem',
        2048
      ])
      subject.create
    end
  end
  it 'should delete file' do
    Pathname.any_instance.expects(:delete)
    subject.destroy
  end
end
