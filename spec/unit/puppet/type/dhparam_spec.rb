# frozen_string_literal: true

require 'puppet'
require 'puppet/type/dhparam'
describe Puppet::Type.type(:dhparam) do
  let(:resource) { Puppet::Type.type(:dhparam).new(path: '/tmp/dhparam.pem') }

  it 'does not accept a non absolute path' do
    expect do
      Puppet::Type.type(:dhparam).new(path: 'foo')
    end.to raise_error(Puppet::Error, %r{Path must be absolute: foo})
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
    expect do
      resource[:size] = 0
    end.to raise_error(Puppet::Error, %r{Size must be a positive integer: 0})
  end

  it 'does not accept an negative size' do
    expect do
      resource[:size] = -1
    end.to raise_error(Puppet::Error, %r{Size must be a positive integer: -1})
  end

  it 'does not accept a non-integer size' do
    expect do
      resource[:size] = 1.5
    end.to raise_error(Puppet::Error, %r{Size must be a positive integer: 1.5})
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
