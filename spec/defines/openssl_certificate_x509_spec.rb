require 'spec_helper'

describe 'openssl::certificate::x509' do
  let (:title) { '/tmp/foo' }

  context 'when passing non absolute path as base_dir' do
    let (:title) { 'foo' }
    let (:params) { {
      :country      => 'com',
      :organisation => 'bar',
      :commonname   => 'baz',
      :base_dir     => 'barz',
    } }
    it 'should fail' do
      expect {
        should contain_file('/etc/ssl/certs/foo.cnf')
      }.to raise_error(Puppet::Error, /"barz" is not an absolute path/)
    end
  end
end
