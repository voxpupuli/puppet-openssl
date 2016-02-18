require 'puppet'
require 'puppet/type/dhparam'
describe Puppet::Type.type(:dhparam) do
  subject { Puppet::Type.type(:dhparam).new(:path => '/tmp/dhparam.pem') }

  it 'should not accept a non absolute path' do
    expect {
      Puppet::Type.type(:dhparam).new(:path => 'foo')
    }.to raise_error(Puppet::Error, /Path must be absolute: foo/)
  end

  it 'should accept ensure' do
    subject[:ensure] = :present
    expect(subject[:ensure]).to eq(:present)
  end

  it 'should accept valid size' do
    subject[:size] = 2048
    expect(subject[:size]).to eq(2048)
  end

  it 'should not accept a zero size' do
    expect {
      subject[:size] = 0
    }.to raise_error(Puppet::Error, /Size must be a positive integer: 0/)
  end
  it 'should not accept an negative size' do
    expect {
      subject[:size] = -1
    }.to raise_error(Puppet::Error, /Size must be a positive integer: -1/)
  end
  it 'should not accept a non-integer size' do
    expect {
      subject[:size] = 1.5
    }.to raise_error(Puppet::Error, /Size must be a positive integer: 1.5/)
  end
end
