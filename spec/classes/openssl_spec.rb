require 'spec_helper'

describe 'openssl' do

  context "parameter validation" do
    let (:params) {{ :install_devel => "asdf" }}

    it do
      expect {
        should true
      }.to raise_error(Puppet::Error, %r{.*is not a boolean.*})
    end
  end

  context 'when on Solaris' do
    let (:facts) {{
      :osfamily => 'Solaris'
    }}

    it do
      expect {
        should true
      }.to raise_error(Puppet::Error, %r{Operating systems in the Solaris family are not supported})
    end
  end

  context 'when on Debian with' do
    let (:facts) { {
      :operatingsystem => 'Debian',
      :osfamily        => 'Debian',
    } }

    it { should contain_package('openssl').with_ensure('present') }
    it { should contain_package('ca-certificates').with_ensure('present') }
    it { should contain_exec('update-ca-certificates').with_refreshonly('true') }

    it { should contain_file('ca-certificates.crt').with(
        :ensure => 'present',
        :owner  => 'root',
        :mode   => '0644',
        :path   => '/etc/ssl/certs/ca-certificates.crt'
      )
    }

    context "with default parameters" do
      let (:params) { {} }

      it { should_not contain_package('openssl-dev') }
    end

    context "explicitly not installing development packages" do
      let (:params) {
        { :install_devel => false }
      }

      it { should_not contain_package('openssl-dev') }
    end

    context "installing development packages" do
      let (:params) {
        { :install_devel => true }
      }

      it { should contain_package('openssl-devel').with_name('openssl-dev') }
    end
  end

  context 'when on RedHat' do
    let (:facts) { {
      :operatingsystem => 'RedHat',
      :osfamily        => 'RedHat',
    } }

    it { should contain_package('openssl').with_ensure('present') }
    it { should_not contain_package('ca-certificates') }
    it { should_not contain_exec('update-ca-certificates') }

    it { should contain_file('ca-certificates.crt').with(
        :ensure => 'present',
        :owner  => 'root',
        :mode   => '0644',
        :path   => '/etc/pki/tls/certs/ca-bundle.crt'
      )
    }

    context "with default parameters" do
      let (:params) { {} }

      it { should_not contain_package('openssl-devel') }
    end

    context "explicitly not installing development packages" do
      let (:params) {
        { :install_devel => false }
      }

      it { should_not contain_package('openssl-devel') }
    end

    context "installing development packages" do
      let (:params) {
        { :install_devel => true }
      }

      it { should contain_package('openssl-devel').with_name('openssl-devel') }
    end
  end
end
