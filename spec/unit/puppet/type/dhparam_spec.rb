require 'puppet'
require 'puppet/type/dhparam'
describe Puppet::Type.type(:dhparam) do
  let(:resource) { Puppet::Type.type(:dhparam).new(path: '/tmp/dhparam.pem') }

  it 'does not accept a non absolute path' do
    expect {
      Puppet::Type.type(:dhparam).new(path: 'foo')
    }.to raise_error(Puppet::Error, %r{Path must be absolute: foo})
  end

  it 'accepts ensure' do
    resource[:ensure] = :present
    expect(resource[:ensure]).to eq(:present)
  end

  it 'accepts valid size' do
    resource[:size] = 2048
    expect(resource[:size]).to eq(2048)
  end

  it 'does not accept a zero size' do
    expect {
      resource[:size] = 0
    }.to raise_error(Puppet::Error, %r{Size must be a positive integer: 0})
  end
  it 'does not accept an negative size' do
    expect {
      resource[:size] = -1
    }.to raise_error(Puppet::Error, %r{Size must be a positive integer: -1})
  end
  it 'does not accept a non-integer size' do
    expect {
      resource[:size] = 1.5
    }.to raise_error(Puppet::Error, %r{Size must be a positive integer: 1.5})
  end
end
