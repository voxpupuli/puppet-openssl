require 'puppet'
require 'puppet/type/x509_request'
describe Puppet::Type.type(:x509_request) do
  let(:resource) { Puppet::Type.type(:x509_request).new(path: '/tmp/foo.csr') }

  it 'does not accept a non absolute path' do
    expect do
      Puppet::Type.type(:x509_request).new(path: 'foo')
    end.to raise_error(Puppet::Error, %r{Path must be absolute: foo})
  end

  it 'accepts ensure' do
    resource[:ensure] = :present
    expect(resource[:ensure]).to eq(:present)
  end

  it 'accepts valid private key' do
    resource[:private_key] = '/tmp/foo.key'
    expect(resource[:private_key]).to eq('/tmp/foo.key')
  end

  it 'does not accept non absolute private key' do
    expect do
      resource[:private_key] = 'foo.key'
    end.to raise_error(Puppet::Error, %r{Path must be absolute: foo\.key})
  end

  it 'accepts valid template' do
    resource[:template] = '/tmp/foo.cnf'
    expect(resource[:template]).to eq('/tmp/foo.cnf')
  end

  it 'does not accept non absolute template' do
    expect do
      resource[:template] = 'foo.cnf'
    end.to raise_error(Puppet::Error, %r{Path must be absolute: foo\.cnf})
  end

  it 'accepts a password' do
    resource[:password] = 'foox2$bar'
    expect(resource[:password]).to eq('foox2$bar')
  end

  it 'accepts a valid force parameter' do
    resource[:force] = true
    expect(resource[:force]).to eq(:true)
  end

  it 'does not accept a bad force parameter' do
    expect do
      resource[:force] = :foo
    end.to raise_error(Puppet::Error, %r{Invalid value :foo})
  end

  it 'accepts a valid authentication' do
    resource[:authentication] = :rsa
    expect(resource[:authentication]).to eq(:rsa)
    resource[:authentication] = :dsa
    expect(resource[:authentication]).to eq(:dsa)
    resource[:authentication] = :ec
    expect(resource[:authentication]).to eq(:ec)
  end

  it 'does not accept an invalid authentication' do
    expect do
      resource[:authentication] = :foo
    end.to raise_error(Puppet::Error, %r{Invalid value :foo})
  end
end
