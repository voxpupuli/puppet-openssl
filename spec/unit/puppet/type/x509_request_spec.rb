require 'puppet'
require 'puppet/type/x509_request'
describe Puppet::Type.type(:x509_request) do
  subject { Puppet::Type.type(:x509_request).new(path: '/tmp/foo.csr') }

  it 'does not accept a non absolute path' do
    expect {
      Puppet::Type.type(:x509_request).new(path: 'foo')
    }.to raise_error(Puppet::Error, %r{Path must be absolute: foo})
  end

  it 'accepts ensure' do
    subject[:ensure] = :present
    expect(subject[:ensure]).to eq(:present)
  end

  it 'accepts valid private key' do
    subject[:private_key] = '/tmp/foo.key'
    expect(subject[:private_key]).to eq('/tmp/foo.key')
  end

  it 'does not accept non absolute private key' do
    expect {
      subject[:private_key] = 'foo.key'
    }.to raise_error(Puppet::Error, %r{Path must be absolute: foo\.key})
  end

  it 'accepts valid template' do
    subject[:template] = '/tmp/foo.cnf'
    expect(subject[:template]).to eq('/tmp/foo.cnf')
  end

  it 'does not accept non absolute template' do
    expect {
      subject[:template] = 'foo.cnf'
    }.to raise_error(Puppet::Error, %r{Path must be absolute: foo\.cnf})
  end

  it 'accepts a password' do
    subject[:password] = 'foox2$bar'
    expect(subject[:password]).to eq('foox2$bar')
  end

  it 'accepts a valid force parameter' do
    subject[:force] = true
    expect(subject[:force]).to eq(:true)
  end

  it 'does not accept a bad force parameter' do
    expect {
      subject[:force] = :foo
    }.to raise_error(Puppet::Error, %r{Invalid value :foo})
  end

  it 'accepts a valid authentication' do
    subject[:authentication] = :rsa
    expect(subject[:authentication]).to eq(:rsa)
    subject[:authentication] = :dsa
    expect(subject[:authentication]).to eq(:dsa)
    subject[:authentication] = :ec
    expect(subject[:authentication]).to eq(:ec)
  end

  it 'does not accept an invalid authentication' do
    expect {
      subject[:authentication] = :foo
    }.to raise_error(Puppet::Error, %r{Invalid value :foo})
  end
end
