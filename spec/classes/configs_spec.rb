# frozen_string_literal: true

require 'spec_helper'

describe 'openssl::configs' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      context 'without ownership defaults' do
        let :params do
          {
            country: 'CH',
            organization: 'Existing Ltd',
            conffiles: {
              '/path/to/openssl.conf' => { 'country' => 'US', 'commonname' => 'servername.xyz.org' },
              '/other/path/to/openssl.conf' => { 'group' => 'vpn', 'commonname' => ['test.ch', 'test2.ch'] },
              '/absent.conf' => { 'ensure' => 'absent', 'commonname' => 'blah' },
            },
          }
        end

        it { is_expected.to compile }

        it {
          is_expected.to contain_file('/path/to/openssl.conf').
            with_ensure('present').
            with_owner('root').
            with_mode('0640')
        }

        it {
          is_expected.to contain_file('/other/path/to/openssl.conf').
            with_ensure('present').
            with_owner('root').
            with_group('vpn').
            with_mode('0640')
        }

        it {
          is_expected.to contain_file('/absent.conf').
            with_ensure('absent')
        }
      end

      context 'with ownership defaults' do
        let :params do
          {
            owner: 'someone',
            group: 'somegroup',
            mode: '0000',
            conffiles: {
              '/path/to/openssl.conf' => { 'commonname' => 'servername.xyz.org' },
              '/tmp/openssl.conf' => { 'commonname' => 'some', 'owner' => 'whoever', 'group' => 'agroup', 'mode' => '1111' },
            },
          }
        end

        it {
          is_expected.to contain_file('/path/to/openssl.conf').
            with_ensure('present').
            with_owner('someone').
            with_group('somegroup').
            with_mode('0000')
        }

        it {
          is_expected.to contain_file('/tmp/openssl.conf').
            with_ensure('present').
            with_owner('whoever').
            with_group('agroup').
            with_mode('1111')
        }
      end
    end
  end
end
