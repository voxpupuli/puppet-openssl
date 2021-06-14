require 'puppet'
require 'puppet/type/ssl_pkey'
describe Puppet::Type.type(:ssl_pkey) do
  let(:resource) { Puppet::Type.type(:ssl_pkey).new(path: '/tmp/foo.key') }

  it 'does not accept a non absolute path' do
    expect do
      Puppet::Type.type(:ssl_pkey).new(path: 'foo')
    end.to raise_error(Puppet::Error, %r{Path must be absolute: foo})
  end

  it 'accepts ensure' do
    resource[:ensure] = :present
    expect(resource[:ensure]).to eq(:present)
  end

  it 'accepts a valid size' do
    resource[:size] = 1024
    expect(resource[:size]).to eq(1024)
  end

  it 'does not accept an invalid size' do
    expect do
      resource[:size] = :foo
    end.to raise_error(Puppet::Error, %r{Invalid value :foo})
  end

  it 'accepts an curve' do
    resource[:curve] = :secp384r1
    expect(resource[:curve]).to eq(:secp384r1)
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

  it 'accepts a password' do
    resource[:password] = 'foox2$bar'
    expect(resource[:password]).to eq('foox2$bar')
  end
end
