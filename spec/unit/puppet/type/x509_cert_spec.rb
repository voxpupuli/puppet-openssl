require 'puppet'
require 'puppet/type/x509_cert'
describe Puppet::Type.type(:x509_cert) do
  subject { Puppet::Type.type(:x509_cert).new(path: '/tmp/foo') }

  it 'does not accept a non absolute path' do
    expect {
      Puppet::Type.type(:x509_cert).new(path: 'foo')
    }.to raise_error(Puppet::Error, %r{Path must be absolute: foo})
  end

  it 'accepts ensure' do
    subject[:ensure] = :present
    expect(subject[:ensure]).to eq(:present)
  end

  it 'accepts valid days' do
    subject[:days] = 365
    expect(subject[:days]).to eq(365)
  end

  it 'does not accept invalid days' do
    expect {
      subject[:days] = :foo
    }.to raise_error(Puppet::Error, %r{Invalid value :foo})
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

  it 'accepts a valid req_ext parameter' do
    subject[:req_ext] = true
    expect(subject[:req_ext]).to eq(:true)
  end

  it 'does not accept a bad req_ext parameter' do
    expect {
      subject[:req_ext] = :foo
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
