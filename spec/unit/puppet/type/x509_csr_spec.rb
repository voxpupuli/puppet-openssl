require 'puppet'
require 'puppet/type/x509_csr'
describe Puppet::Type.type(:x509_csr) do
  subject { Puppet::Type.type(:x509_csr).new(:path => '/tmp/foo.csr') }

  it 'should not accept a non absolute path' do
    expect {
      Puppet::Type.type(:x509_csr).new(:path => 'foo')
    }.to raise_error(Puppet::Error, /Path must be absolute: foo/)
  end

  it 'should accept ensure' do
    subject[:ensure] = :present
    subject[:ensure].should == :present
  end

  it 'should accept valid private key' do
    subject[:private_key] = '/tmp/foo.key'
    subject[:private_key].should == '/tmp/foo.key'
  end

  it 'should not accept non absolute private key' do
    expect {
      subject[:private_key] = 'foo.key'
    }.to raise_error(Puppet::Error, /Path must be absolute: foo\.key/)
  end
end

