require 'puppet'
require 'puppet/type/x509_cert'
describe Puppet::Type.type(:x509_cert) do
  subject { Puppet::Type.type(:x509_cert).new(:path => '/tmp/foo') }

  it 'should not accept a non absolute path' do
    expect {
      Puppet::Type.type(:x509_cert).new(:path => 'foo')
    }.to raise_error(Puppet::Error, /Path must be absolute: foo/)
  end

  it 'should accept ensure' do
    subject[:ensure] = :present
    subject[:ensure].should == :present
  end

  it 'should accept a valid country' do
    subject[:country] = :com
    subject[:country].should == :com
  end

  it 'should accept a valid state' do
    subject[:state] = :CH
    subject[:state].should == :CH
  end

  it 'should accept a valid locality' do
    subject[:locality] = :Geneva
    subject[:locality].should == :Geneva
  end

  it 'should accept a valid commonname' do
    subject[:commonname] = :bar
    subject[:commonname].should == :bar
  end

  it 'should accept a valid array of altnames' do
    subject[:altnames] = [:foo, :bar, :baz]
    subject[:altnames].should == [:foo, :bar, :baz]
  end

  it 'should accept a valid organisation' do
    subject[:organisation] = :baz
    subject[:organisation].should == :baz
  end
  
  it 'should accept a valid unit' do
    subject[:unit] = :infra
    subject[:unit].should == :infra
  end

  it 'should accept a valid email' do
    subject[:email] = 'infra@example.com'
    subject[:email].should == 'infra@example.com'
  end

  it 'should accept valid days' do
    subject[:days] = 365
    subject[:days].should == 365
  end

  it 'should not accept invalid days' do
    expect {
      subject[:days] = :foo
    }.to raise_error(Puppet::Error, /Invalid value :foo/)
  end

  it 'should accept a valid owner' do
    subject[:owner] = :bar
    subject[:owner].should == :bar
  end
end
