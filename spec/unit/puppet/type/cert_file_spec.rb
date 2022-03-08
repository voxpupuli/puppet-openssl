# frozen_string_literal: true

require 'puppet'
require 'puppet/type/cert_file'

describe Puppet::Type.type(:cert_file) do
  let(:resource) { Puppet::Type.type(:cert_file).new(path: '/path/to/certs/cacert_root1.pem') }

  it 'accepts ensure present' do
    resource[:ensure] = :present
    expect(resource[:ensure]).to eq(:present)
  end

  it 'accepts ensure absent' do
    resource[:ensure] = :absent
    expect(resource[:ensure]).to eq(:absent)
  end

  it 'does not accept relative path' do
    expect do
      Puppet::Type.type(:cert_file).new(path: 'foo')
    end.to raise_error(Puppet::ResourceError, %r{Parameter path failed on Cert_file\[foo\]})
  end

  it 'accepts source URI' do
    resource[:source] = 'http://www.cacert.org/certs/root_X0F.der'
    expect(resource[:source]).to eq('http://www.cacert.org/certs/root_X0F.der')
  end

  it 'does not accept ftp URI' do
    expect do
      resource[:source] = 'ftp://foo.bar/cert'
    end.to raise_error(Puppet::Error, %r{Cannot use URLs of type 'ftp' as source for fileserving})
  end

  it 'accepts format attribute PEM' do
    resource[:format] = :pem
    expect(resource[:format]).to eq(:pem)
  end

  it 'accepts format attribute DER' do
    resource[:format] = :der
    expect(resource[:format]).to eq(:der)
  end

  it 'does not accept format other than PEM or DER' do
    expect do
      resource[:format] = :foo
    end.to raise_error(Puppet::ResourceError, %r{Invalid value :foo. Valid values are der, pem.})
  end
end
