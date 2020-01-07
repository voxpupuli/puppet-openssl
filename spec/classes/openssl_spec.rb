require 'spec_helper'

describe 'openssl' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      it { is_expected.to compile.with_all_deps }

      it { is_expected.to contain_package('openssl').with_ensure('present') }

      context 'on Debian', if: facts[:osfamily] == 'Debian' do
        it { is_expected.to contain_package('ca-certificates') }
        it { is_expected.to contain_exec('update-ca-certificates').with_refreshonly('true') }
      end

      context 'on RedHat', if: facts[:osfamily] == 'RedHat' do
        if facts[:operatingsystemrelease].to_i >= 6
          it { is_expected.to contain_package('ca-certificates') }
        else
          it { is_expected.not_to contain_package('ca-certificates') }
        end
        it { is_expected.not_to contain_exec('update-ca-certificates').with_refreshonly('true') }
      end
    end
  end
end
