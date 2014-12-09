require 'spec_helper'

describe 'openssl' do
  context 'when on Debian' do
    let (:facts) { {
      :operatingsystem => 'Debian',
      :osfamily        => 'Debian',
    } }

    it { is_expected.to contain_package('openssl').with_ensure('present') }
    it { is_expected.to contain_package('ca-certificates').with_ensure('present') }
    it { is_expected.to contain_exec('update-ca-certificates').with_refreshonly('true') }

    it { is_expected.to contain_file('ca-certificates.crt').with(
        :ensure => 'present',
        :owner  => 'root',
        :mode   => '0644',
        :path   => '/etc/ssl/certs/ca-certificates.crt'
      )
    }
  end

  context 'when on RedHat' do
    let (:facts) { {
      :operatingsystemmajrelease => '6',
      :operatingsystem           => 'RedHat',
      :osfamily                  => 'RedHat',
    } }

    it { is_expected.to contain_package('openssl').with_ensure('present') }
    it { is_expected.not_to contain_package('ca-certificates') }
    it { is_expected.not_to contain_exec('update-ca-certificates') }

    it { is_expected.to contain_file('ca-certificates.crt').with(
        :ensure => 'present',
        :owner  => 'root',
        :mode   => '0644',
        :path   => '/etc/pki/tls/certs/ca-bundle.crt'
      )
    }
  end
end
