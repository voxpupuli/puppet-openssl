# frozen_string_literal: true

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

  it 'accepts mode' do
    resource[:mode] = '0700'
    expect(resource[:mode]).to eq('0700')
  end

  it 'does not accept numeric mode' do
    expect do
      resource[:mode] = '700'
    end.to raise_error(Puppet::Error, %r{700 is not a valid file mode})
  end

  it 'accepts owner' do
    resource[:owner] = 'someone'
    expect(resource[:owner]).to eq('someone')
  end

  it 'does not accept bad owner' do
    expect do
      resource[:owner] = 'someone else'
    end.to raise_error(Puppet::Error, %r{someone else is not a valid user name})
  end

  it 'accepts group' do
    resource[:group] = 'party'
    expect(resource[:group]).to eq('party')
  end

  it 'does not accept bad group group' do
    expect do
      resource[:group] = 'party crasher'
    end.to raise_error(Puppet::Error, %r{party crasher is not a valid group name})
  end
end
