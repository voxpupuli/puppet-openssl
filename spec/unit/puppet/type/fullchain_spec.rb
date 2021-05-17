require 'puppet'
require 'puppet/type/fullchain'

describe Puppet::Type.type(:fullchain) do
  let(:resource) { Puppet::Type.type(:fullchain).new(path: '/path/to/certs/fullchain.pem') }

  describe 'Ensurability' do
    it 'accepts present' do
      resource[:ensure] = :present
      expect(resource[:ensure]).to eq(:present)
    end
    it 'accepts absent' do
      resource[:ensure] = :absent
      expect(resource[:ensure]).to eq(:absent)
    end
  end
  describe 'Parameter validation for path' do
    it 'does not accept relative path' do
      expect {
        Puppet::Type.type(:fullchain).new(path: 'foo')
      }.to raise_error(Puppet::Error, %r{File paths must be fully qualified, not 'foo'})
    end
    it 'accepts absolute path' do
      expect(resource[:path]).to eq('/path/to/certs/fullchain.pem')
    end
  end
  describe 'Parameter validation for certificate' do
    it 'does not accept relative path' do
      expect {
        resource[:certificate] = 'foo'
      }.to raise_error(Puppet::Error, %r{File paths must be fully qualified, not 'foo'})
    end
    it 'accepts absolute path' do
      resource[:certificate] = '/path/to/certs/certificate.pem'
      expect(resource[:certificate]).to eq('/path/to/certs/certificate.pem')
    end
  end
end
