# frozen_string_literal: true

require 'spec_helper'

describe 'openssl::export::pem_cert' do
  let(:title) { '/etc/ssl/certs/foo.pem' }
  let(:facts) do
    {
      path: '/usr/bin:/bin:/usr/sbin:/sbin',
    }
  end

  context 'when enable and no pfx or der cert' do
    let(:params) do
      {
        ensure: :present,
      }
    end

    it { is_expected.to compile.and_raise_error(%r{either}) }
  end

  context 'when enable and pfx and der cert is provided' do
    let(:params) do
      {
        ensure: :present,
        pfx_cert: '/etc/ssl/certs/foo.pfx',
        der_cert: '/etc/ssl/certs/foo.der',
      }
    end

    it { is_expected.to compile.and_raise_error(%r{mutually-exclusive}) }
  end

  context 'when using defaults pkcs12 to PEM' do
    let(:params) do
      {
        ensure: :present,
        pfx_cert: '/etc/ssl/certs/foo.pfx',
      }
    end

    it {
      is_expected.to contain_exec('Export /etc/ssl/certs/foo.pfx to /etc/ssl/certs/foo.pem').with(
        command: ['openssl', 'pkcs12', '-in', '/etc/ssl/certs/foo.pfx', '-out', '/etc/ssl/certs/foo.pem'],
        creates: '/etc/ssl/certs/foo.pem',
        path: '/usr/bin:/bin:/usr/sbin:/sbin'
      )
    }
  end

  context 'when using defaults pkcs12 to PEM with dynamic refresh' do
    let(:params) do
      {
        ensure: :present,
        pfx_cert: '/etc/ssl/certs/foo.pfx',
        dynamic: true,
      }
    end

    it {
      is_expected.to contain_exec('Export /etc/ssl/certs/foo.pfx to /etc/ssl/certs/foo.pem').with(
        command: ['openssl', 'pkcs12', '-in', '/etc/ssl/certs/foo.pfx', '-out', '/etc/ssl/certs/foo.pem'],
        path: '/usr/bin:/bin:/usr/sbin:/sbin',
        refreshonly: true
      )
    }
  end

  context 'when converting pkcs12 to PEM with password for just the certificate' do
    let(:params) do
      {
        ensure: :present,
        pfx_cert: '/etc/ssl/certs/foo.pfx',
        in_pass: '5r$}^',

      }
    end

    it {
      is_expected.to contain_exec('Export /etc/ssl/certs/foo.pfx to /etc/ssl/certs/foo.pem').with(
        command: ['openssl', 'pkcs12', '-in', '/etc/ssl/certs/foo.pfx', '-out', '/etc/ssl/certs/foo.pem', '-nokeys', '-passin', 'env:CERTIFICATE_PASSIN'],
        environment: ['CERTIFICATE_PASSIN=5r$}^'],
        creates: '/etc/ssl/certs/foo.pem',
        path: '/usr/bin:/bin:/usr/sbin:/sbin'
      )
    }
  end

  context 'when converting from DER to PEM' do
    let(:params) do
      {
        ensure: :present,
        der_cert: '/etc/ssl/certs/foo.der',
      }
    end

    it {
      is_expected.to contain_exec('Export /etc/ssl/certs/foo.der to /etc/ssl/certs/foo.pem').with(
        command: ['openssl', 'x509', '-inform', 'DER', '-in', '/etc/ssl/certs/foo.der', '-out', '/etc/ssl/certs/foo.pem'],
        creates: '/etc/ssl/certs/foo.pem',
        path: '/usr/bin:/bin:/usr/sbin:/sbin'
      )
    }
  end

  context 'when ensuring absence' do
    let(:params) do
      {
        ensure: 'absent',
      }
    end

    it {
      is_expected.to contain_file('/etc/ssl/certs/foo.pem').with(
        ensure: 'absent'
      )
    }
  end
end
