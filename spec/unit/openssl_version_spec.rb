require 'spec_helper'
require 'facter'

describe Facter.fact(:openssl_version) do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      before(:each) do
        Facter.clear
      end
      describe 'openssl_version' do
        context 'with value' do
          before :each do
            allow(Facter::Util::Resolution).to receive(:which).with('openssl').and_return(true)
            allow(Facter::Util::Resolution).to receive(:exec).with('openssl version 2>&1').and_return('OpenSSL 0.9.8zg 14 July 2015')
          end
          it {
            expect(Facter.value(:openssl_version)).to eq('0.9.8zg')
          }
        end
        context 'with broken openssl' do
          before :each do
            allow(Facter::Util::Resolution).to receive(:which).with('openssl').and_return(true)
            allow(Facter::Util::Resolution).to receive(:exec).with('openssl version 2>&1')
                                                             .and_return('openssl: /usr/lib/x86_64-linux-gnu/libcrypto.so.1.0.0: version `OPENSSL_1.0.1s\' not found (required by openssl)')
          end
          it {
            expect(Facter.value(:openssl_version)).to be_nil
          }
        end
      end
      describe 'openssl_version rhel' do
        context 'with value' do
          before :each do
            allow(Facter::Util::Resolution).to receive(:which).with('openssl').and_return(true)
            allow(Facter::Util::Resolution).to receive(:exec).with('openssl version 2>&1').and_return('OpenSSL 1.0.1e-fips 11 Feb 2013')
          end
          it {
            expect(Facter.value(:openssl_version)).to eq('1.0.1e-fips')
          }
        end
      end
      describe 'openssl_version centos' do
        context 'with value' do
          before :each do
            allow(Facter::Util::Resolution).to receive(:which).with('openssl').and_return(true)
            allow(Facter::Util::Resolution).to receive(:exec).with('openssl version 2>&1').and_return('OpenSSL 1.0.2g  1 Mar 2016')
          end
          it {
            expect(Facter.value(:openssl_version)).to eq('1.0.2g')
          }
        end
      end
    end
  end
end
