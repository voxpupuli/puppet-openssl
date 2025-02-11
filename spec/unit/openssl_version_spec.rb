# frozen_string_literal: true

require 'spec_helper'
require 'facter'

fact_matrix = {
  'debian-11-x86_64' => {
    return_string: 'OpenSSL 1.1.1w  11 Sep 2023',
    version_string: '1.1.1w',
  },
  'debian-12-x86_64' => {
    return_string: 'OpenSSL 3.0.15 3 Sep 2024 (Library: OpenSSL 3.0.15 3 Sep 2024)',
    version_string: '3.0.15',
  },
  'ubuntu-20.04-x86_64' => {
    return_string: 'OpenSSL 1.1.1f  31 Mar 2020',
    version_string: '1.1.1f',
  },
  'ubuntu-22.04-x86_64' => {
    return_string: 'OpenSSL 3.0.2 15 Mar 2022 (Library: OpenSSL 3.0.2 15 Mar 2022)',
    version_string: '3.0.2',
  },
  'ubuntu-24.04-x86_64' => {
    return_string: 'OpenSSL 3.0.13 30 Jan 2024 (Library: OpenSSL 3.0.13 30 Jan 2024)',
    version_string: '3.0.13',
  },
  'redhat-8-legacy' => {
    return_string: 'OpenSSL 1.1.1c FIPS  28 May 2019',
    version_string: '1.1.1c',
  },
  'redhat-8-x86_64' => {
    return_string: 'OpenSSL 1.1.1k  FIPS 25 Mar 2021',
    version_string: '1.1.1k',
  },
  'redhat-9-x86_64' => {
    return_string: 'OpenSSL 9.9.9zzz FIPS 1 Jan 2099',
    version_string: '9.9.9zzz',
  },
  'oraclelinux-8-x86_64' => {
    return_string: 'OpenSSL 1.1.1k  FIPS 25 Mar 2021',
    version_string: '1.1.1k',
  },
  'oraclelinux-9-x86_64' => {
    return_string: 'OpenSSL 3.2.2 4 Jun 2024 (Library: OpenSSL 3.2.2 4 Jun 2024)',
    version_string: '3.2.2',
  },
  'rocky-8-x86_64' => {
    return_string: 'OpenSSL 1.1.1k  FIPS 25 Mar 2021',
    version_string: '1.1.1k',
  },
  'rocky-9-x86_64' => {
    return_string: 'OpenSSL 3.2.2 4 Jun 2024 (Library: OpenSSL 3.2.2 4 Jun 2024)',
    version_string: '3.2.2',
  },
  'almalinux-8-x86_64' => {
    return_string: 'OpenSSL 1.1.1k  FIPS 25 Mar 2021',
    version_string: '1.1.1k',
  },
  'almalinux-9-x86_64' => {
    return_string: 'OpenSSL 3.2.2 4 Jun 2024 (Library: OpenSSL 3.2.2 4 Jun 2024)',
    version_string: '3.2.2',
  },
  'centos-9-x86_64' => {
    return_string: 'OpenSSL 1.0.2g  1 Mar 2016',
    version_string: '1.0.2g',
  },
  'vanilla-openssl' => {
    return_string: 'OpenSSL 3.5.0-dev  (Library: OpenSSL 3.5.0-dev )',
    version_string: '3.5.0-dev',
  },
  'legacy' => {
    return_string: 'OpenSSL 0.9.8zg 14 July 2015',
    version_string: '0.9.8zg',
  },
}

describe Facter.fact(:openssl_version) do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      before do
        Facter.clear
      end

      describe 'openssl_version' do
        context 'with value' do
          before do
            allow(Facter::Util::Resolution).to receive(:which).with('openssl').and_return(true)
            allow(Facter::Util::Resolution).to receive(:exec).with('openssl version 2>&1').and_return(fact_matrix[os][:return_string])
          end

          it {
            expect(Facter.value(:openssl_version)).to eq(fact_matrix[os][:version_string])
          }
        end

        context 'with broken openssl' do
          before do
            allow(Facter::Util::Resolution).to receive(:which).with('openssl').and_return(true)
            allow(Facter::Util::Resolution).to receive(:exec).with('openssl version 2>&1').
              and_return('openssl: /usr/lib/x86_64-linux-gnu/libcrypto.so.1.0.0: version `OPENSSL_1.0.1s\' not found (required by openssl)')
          end

          it {
            expect(Facter.value(:openssl_version)).to be_nil
          }
        end
      end
    end
  end

  filler_facts = on_supported_os['redhat-9-x86_64']
  ['legacy', 'redhat-8-legacy'].each do |special_case|
    context "on #{special_case}" do
      let(:facts) { filler_facts }

      before do
        Facter.clear
      end

      describe 'openssl_version' do
        context 'with value' do
          before do
            allow(Facter::Util::Resolution).to receive(:which).with('openssl').and_return(true)
            allow(Facter::Util::Resolution).to receive(:exec).with('openssl version 2>&1').and_return(fact_matrix[special_case][:return_string])
          end

          it {
            expect(Facter.value(:openssl_version)).to eq(fact_matrix[special_case][:version_string])
          }
        end
      end
    end
  end
end
