require 'puppet'
require 'puppet/type/x509_cert'
describe Puppet::Type.type(:x509_cert) do
  let(:resource) { Puppet::Type.type(:x509_cert).new(path: '/tmp/foo') }

  it 'does not accept a non absolute path' do
    expect {
      Puppet::Type.type(:x509_cert).new(path: 'foo')
    }.to raise_error(Puppet::Error, %r{Path must be absolute: foo})
  end

  it 'accepts ensure' do
    resource[:ensure] = :present
    expect(resource[:ensure]).to eq(:present)
  end

  it 'accepts valid days' do
    resource[:days] = 365
    expect(resource[:days]).to eq(365)
  end

  it 'does not accept invalid days' do
    expect {
      resource[:days] = :foo
    }.to raise_error(Puppet::Error, %r{Invalid value :foo})
  end

  it 'accepts valid template' do
    resource[:template] = '/tmp/foo.cnf'
    expect(resource[:template]).to eq('/tmp/foo.cnf')
  end

  it 'does not accept non absolute template' do
    expect {
      resource[:template] = 'foo.cnf'
    }.to raise_error(Puppet::Error, %r{Path must be absolute: foo\.cnf})
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
    expect {
      resource[:force] = :foo
    }.to raise_error(Puppet::Error, %r{Invalid value :foo})
  end

  it 'accepts a valid req_ext parameter' do
    resource[:req_ext] = true
    expect(resource[:req_ext]).to eq(:true)
  end

  it 'does not accept a bad req_ext parameter' do
    expect {
      resource[:req_ext] = :foo
    }.to raise_error(Puppet::Error, %r{Invalid value :foo})
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
    expect {
      resource[:authentication] = :foo
    }.to raise_error(Puppet::Error, %r{Invalid value :foo})
  end
end
