require 'spec_helper'

describe 'openssl::certificate::x509' do
  let (:title) { 'foo' }

  context 'when passing non absolute path as base_dir' do
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

  context 'when not passing a country' do
    let (:params) { {
      :organisation => 'bar',
      :commonname   => 'baz',
      :base_dir     => '/tmp/foo',
    } }
    it 'should fail' do
      expect {
        should contain_file('/etc/ssl/certs/foo.cnf')
      }.to raise_error(Puppet::Error, /Must pass country to Openssl::Certificate::X509/)
    end
  end

  context 'when passing wrong type for country' do
    let (:params) { {
      :country      => true,
      :organisation => 'bar',
      :commonname   => 'baz',
      :base_dir     => '/tmp/foo',
    } }
    it 'should fail' do
      expect {
        should contain_file('/etc/ssl/certs/foo.cnf')
      }.to raise_error(Puppet::Error, /true is not a string/)
    end
  end

  context 'when not passing an organisation' do
    let (:params) { {
      :country      => 'CH',
      :commonname   => 'baz',
      :base_dir     => '/tmp/foo',
    } }
    it 'should fail' do
      expect {
        should contain_file('/etc/ssl/certs/foo.cnf')
      }.to raise_error(Puppet::Error, /Must pass organisation to Openssl::Certificate::X509/)
    end
  end

  context 'when passing wrong type for organisation' do
    let (:params) { {
      :country      => 'CH',
      :organisation => true,
      :commonname   => 'baz',
      :base_dir     => '/tmp/foo',
    } }
    it 'should fail' do
      expect {
        should contain_file('/etc/ssl/certs/foo.cnf')
      }.to raise_error(Puppet::Error, /true is not a string/)
    end
  end

  context 'when not passing an commonname' do
    let (:params) { {
      :country      => 'CH',
      :organisation => 'bar',
      :base_dir     => '/tmp/foo',
    } }
    it 'should fail' do
      expect {
        should contain_file('/etc/ssl/certs/foo.cnf')
      }.to raise_error(Puppet::Error, /Must pass commonname to Openssl::Certificate::X509/)
    end
  end

  context 'when passing wrong type for commonname' do
    let (:params) { {
      :country      => 'CH',
      :organisation => 'bar',
      :commonname   => true,
      :base_dir     => '/tmp/foo',
    } }
    it 'should fail' do
      expect {
        should contain_file('/etc/ssl/certs/foo.cnf')
      }.to raise_error(Puppet::Error, /true is not a string/)
    end
  end

  context 'when passing wrong value for ensure' do
    let (:params) { {
      :ensure       => 'foo',
      :country      => 'CH',
      :organisation => 'bar',
      :commonname   => 'baz',
      :base_dir     => '/tmp/foo',
    } }
    it 'should fail' do
      expect {
        should contain_file('/etc/ssl/certs/foo.cnf')
      }.to raise_error(Puppet::Error, /\$ensure must be either 'present' or 'absent', got 'foo'/)
    end
  end

  context 'when passing wrong type for state' do
    let (:params) { {
      :country      => 'CH',
      :organisation => 'bar',
      :commonname   => 'baz',
      :base_dir     => '/tmp/foo',
      :state        => true,
    } }
    it 'should fail' do
      expect {
        should contain_file('/etc/ssl/certs/foo.cnf')
      }.to raise_error(Puppet::Error, /true is not a string/)
    end
  end

  context 'when passing wrong type for locality' do
    let (:params) { {
      :country      => 'CH',
      :organisation => 'bar',
      :commonname   => 'baz',
      :base_dir     => '/tmp/foo',
      :locality     => true,
    } }
    it 'should fail' do
      expect {
        should contain_file('/etc/ssl/certs/foo.cnf')
      }.to raise_error(Puppet::Error, /true is not a string/)
    end
  end

  context 'when passing wrong type for unit' do
    let (:params) { {
      :country      => 'CH',
      :organisation => 'bar',
      :commonname   => 'baz',
      :base_dir     => '/tmp/foo',
      :unit         => true,
    } }
    it 'should fail' do
      expect {
        should contain_file('/etc/ssl/certs/foo.cnf')
      }.to raise_error(Puppet::Error, /true is not a string/)
    end
  end

  context 'when passing wrong type for altnames' do
    let (:params) { {
      :country      => 'CH',
      :organisation => 'bar',
      :commonname   => 'baz',
      :base_dir     => '/tmp/foo',
      :altnames     => true,
    } }
    it 'should fail' do
      expect {
        should contain_file('/etc/ssl/certs/foo.cnf')
      }.to raise_error(Puppet::Error, /true is not an Array/)
    end
  end

  context 'when passing wrong type for email' do
    let (:params) { {
      :country      => 'CH',
      :organisation => 'bar',
      :commonname   => 'baz',
      :base_dir     => '/tmp/foo',
      :email        => true,
    } }
    it 'should fail' do
      expect {
        should contain_file('/etc/ssl/certs/foo.cnf')
      }.to raise_error(Puppet::Error, /true is not a string/)
    end
  end

  context 'when passing wrong type for days' do
    let (:params) { {
      :country      => 'CH',
      :organisation => 'bar',
      :commonname   => 'baz',
      :base_dir     => '/tmp/foo',
      :days         => true,
    } }
    it 'should fail' do
      expect {
        should contain_file('/etc/ssl/certs/foo.cnf')
      }.to raise_error(Puppet::Error, /true is not a string/)
    end
  end

  context 'when passing wrong type for base_dir' do
    let (:params) { {
      :country      => 'CH',
      :organisation => 'bar',
      :commonname   => 'baz',
      :base_dir     => true,
    } }
    it 'should fail' do
      expect {
        should contain_file('/etc/ssl/certs/foo.cnf')
      }.to raise_error(Puppet::Error, /true is not a string/)
    end
  end

  context 'when passing wrong type for owner' do
    let (:params) { {
      :country      => 'CH',
      :organisation => 'bar',
      :commonname   => 'baz',
      :owner        => true,
      :base_dir     => '/tmp/foo',
    } }
    it 'should fail' do
      expect {
        should contain_file('/etc/ssl/certs/foo.cnf')
      }.to raise_error(Puppet::Error, /true is not a string/)
    end
  end

  context 'when passing wrong type for password' do
    let (:params) { {
      :country      => 'CH',
      :organisation => 'bar',
      :commonname   => 'baz',
      :base_dir     => '/tmp/foo',
      :password     => true,
    } }
    it 'should fail' do
      expect {
        should contain_file('/etc/ssl/certs/foo.cnf')
      }.to raise_error(Puppet::Error, /true is not a string/)
    end
  end

  context 'when passing wrong type for force' do
    let (:params) { {
      :country      => 'CH',
      :organisation => 'bar',
      :commonname   => 'baz',
      :base_dir     => '/tmp/foo',
      :force        => 'foobar',
    } }
    it 'should fail' do
      expect {
        should contain_file('/etc/ssl/certs/foo.cnf')
      }.to raise_error(Puppet::Error, /"foobar" is not a boolean/)
    end
  end

  context 'when using defaults' do
  end
end
