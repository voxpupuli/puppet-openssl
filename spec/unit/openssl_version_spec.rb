require "spec_helper"
require "facter"

describe Facter::Util::Fact do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }
      before {
        Facter.clear
      }
      describe "openssl_version" do
        context 'with value' do
          before :each do
            Facter::Util::Resolution.stubs(:which).with('openssl').returns(true)
            Facter::Util::Resolution.stubs(:exec).with('openssl version 2>&1').returns('OpenSSL 0.9.8zg 14 July 2015')
          end
          it {
            expect(Facter.value(:openssl_version)).to eq('0.9.8zg')
          }
        end
      end
    end
  end
end
