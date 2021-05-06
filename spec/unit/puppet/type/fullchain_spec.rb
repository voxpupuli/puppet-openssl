require 'puppet'
require 'puppet/type/fullchain'

describe Puppet::Type.type(:fullchain) do
  let(:resource) { Puppet::Type.type(:fullchain).new(path: '/path/to/certs/fullchain.pem') }

  it 'accepts ensure present' do
    resource[:ensure] = :present
    expect(resource[:ensure]).to eq(:present)
  end
  it 'accepts ensure absent' do
    resource[:ensure] = :absent
    expect(resource[:ensure]).to eq(:absent)
  end
  it 'does not accept relative path as name' do
    expect {
      Puppet::Type.type(:fullchain).new(path: 'foo')
    }.to raise_error(Puppet::Error, %r{File paths must be fully qualified, not 'foo'})
  end
  it 'accepts absolute path' do
    expect(resource[:path]).to eq('/path/to/certs/fullchain.pem')
  end
  it 'does not accept relative path as certificate' do
    expect {
      resource[:certificate] = 'foo'
    }.to raise_error(Puppet::Error, %r{File paths must be fully qualified, not 'foo'})
  end
  it 'accepts absolute path to certificate' do
    resource[:certificate] = '/path/to/certs/certificate.pem'
    expect(resource[:certificate]).to eq('/path/to/certs/certificate.pem')
  end
end
