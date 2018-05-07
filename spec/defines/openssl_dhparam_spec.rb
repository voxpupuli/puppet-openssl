require 'spec_helper'

describe 'openssl::dhparam' do
  let (:title) { '/etc/ssl/dhparam.pem' }

  context 'when passing non absolute path' do
    let (:params) { {
      :path => 'foo',
    } }
    it 'should fail' do
      expect {
        is_expected.to contain_file('/etc/ssl/dhparam.pem')
      }.to raise_error(/got ['barz'|String]/)
    end
  end
  context 'when passing wrong value for ensure' do
    let (:params) { {
      :path => '/etc/ssl/dhparam.pem',
      :ensure => 'foo',
    } }
    it 'should fail' do
      expect {
        is_expected.to contain_file('/etc/ssl/dhparam.pem')
      }.to raise_error(Puppet::Error, /got 'foo'/)
    end
  end
  context 'when passing non positive size' do
    let (:params) { {
      :path => '/etc/ssl/dhparam.pem',
      :size => -1,
    } }
    it 'should fail' do
      expect {
        is_expected.to contain_file('/etc/ssl/dhparam.pem')
      }.to raise_error(Puppet::Error, /got Integer/)
    end
  end
  context 'when passing wrong type for user' do
    let (:params) { {
      :path => '/etc/ssl/dhparam.pem',
      :owner => true,
    } }
    it 'should fail' do
      expect {
        is_expected.to contain_file('/etc/ssl/dhparam.pem')
      }.to raise_error(Puppet::Error, /got Boolean/)
    end
  end
  context 'when passing wrong type for group' do
    let (:params) { {
      :path => '/etc/ssl/dhparam.pem',
      :group => true,
    } }
    it 'should fail' do
      expect {
        is_expected.to contain_file('/etc/ssl/dhparam.pem')
      }.to raise_error(Puppet::Error, /got Boolean/)
    end
  end
  context 'when passing wrong type for mode' do
    let (:params) { {
      :path => '/etc/ssl/dhparam.pem',
      :mode => true,
    } }
    it 'should fail' do
      expect {
        is_expected.to contain_file('/etc/ssl/dhparam.pem')
      }.to raise_error(Puppet::Error, /got Boolean/)
    end
  end
  context 'when using defaults' do
    let (:params) { {
      :path => '/etc/ssl/dhparam.pem',
    } }
    it {
      is_expected.to contain_dhparam('/etc/ssl/dhparam.pem').with(
        :ensure => 'present',
        :size => 2048
      )
    }
    it {
      is_expected.to contain_file('/etc/ssl/dhparam.pem').with(
        :ensure => 'present',
        :owner  => 'root',
        :group  => 'root',
        :mode   => '0644'
      )
    }
  end

  context 'when using size' do
    let (:params) { {
      :path => '/etc/ssl/dhparam.pem',
      :size => 2048,
    } }
    it {
      is_expected.to contain_dhparam('/etc/ssl/dhparam.pem').with(
        :ensure => 'present',
        :size => 2048
      )
    }
    it {
      is_expected.to contain_file('/etc/ssl/dhparam.pem').with(
        :ensure => 'present',
        :owner  => 'root',
        :group  => 'root',
        :mode   => '0644'
      )
    }
  end

 context 'when passing all parameters' do
    let (:params) { {
      :path  => '/etc/ssl/dhparam.pem',
      :owner => 'www-data',
      :group => 'adm',
      :mode  => '0640',
      :size  => 2048
    } }
    it {
      is_expected.to contain_dhparam('/etc/ssl/dhparam.pem').with(
        :ensure => 'present',
        :size   => 2048
      )
    }
    it {
      is_expected.to contain_file('/etc/ssl/dhparam.pem').with(
        :ensure => 'present',
        :owner => 'www-data',
        :group => 'adm',
        :mode => '0640'
      )
    }
  end
  context 'when absent' do
    let (:params) { {
      :path  => '/etc/ssl/dhparam.pem',
      :ensure => 'absent',
    } }
    it {
      is_expected.to contain_dhparam('/etc/ssl/dhparam.pem').with(
        :ensure => 'absent'
      )
    }
    it {
      is_expected.to contain_file('/etc/ssl/dhparam.pem').with(
        :ensure => 'absent'
      )
    }
  end
end
