require 'spec_helper'

describe 'openssl' do
  on_puppet_supported_platforms.each do |version, platforms|
    platforms.each do |platform, facts|
      context "on #{version} #{platform}" do
        let(:facts) { facts }

        it { is_expected.to compile.with_all_deps }

        it { is_expected.to contain_package('openssl').with_ensure('present') }

        if facts[:osfamily] == 'Debian'
          it { is_expected.to contain_package('ca-certificates') }
          it { is_expected.to contain_exec('update-ca-certificates').with_refreshonly('true') }
          it { is_expected.to contain_file('ca-certificates.crt').with(
            :ensure => 'present',
            :owner  => 'root',
            :mode   => '0644',
            :path   => '/etc/ssl/certs/ca-certificates.crt'
            )
          }
        elsif facts[:osfamily] == 'RedHat'
          it { is_expected.not_to contain_package('ca-certificates') }
          it { is_expected.not_to contain_exec('update-ca-certificates').with_refreshonly('true') }

          it { is_expected.to contain_file('ca-certificates.crt').with(
            :ensure => 'present',
            :owner  => 'root',
            :mode   => '0644',
            :path   => '/etc/pki/tls/certs/ca-bundle.crt'
            )
          }
        end
      end
    end
  end
end
