# frozen_string_literal: true

require 'spec_helper'

describe 'openssl::certificate::x509' do
  let(:title) { 'foo' }

  context 'when passing non absolute path as base_dir' do
    let(:params) do
      {
        country: 'com',
        organization: 'bar',
        commonname: 'baz',
        base_dir: 'barz',
      }
    end

    it { is_expected.to compile.and_raise_error(%r{got ['barz|Sting]}) }
  end

  context 'when not passing a country, organization, unit, state and commonname' do
    let(:params) do
      {
        base_dir: '/tmp/foo',
      }
    end

    it { is_expected.to raise_error(Puppet::PreformattedError) }
  end

  context 'when passing wrong type for country' do
    let(:params) do
      {
        country: true,
        organization: 'bar',
        commonname: 'baz',
        base_dir: '/tmp/foo',
      }
    end

    it { is_expected.to compile.and_raise_error(%r{got Boolean}) }
  end

  context 'when passing wrong type for organization' do
    let(:params) do
      {
        country: 'CH',
        organization: true,
        commonname: 'baz',
        base_dir: '/tmp/foo',
      }
    end

    it { is_expected.to compile.and_raise_error(%r{got Boolean}) }
  end

  context 'when passing wrong type for commonname' do
    let(:params) do
      {
        country: 'CH',
        organization: 'bar',
        commonname: true,
        base_dir: '/tmp/foo',
      }
    end

    it { is_expected.to compile.and_raise_error(%r{got Boolean}) }
  end

  context 'when passing wrong value for ensure' do
    let(:params) do
      {
        ensure: 'foo',
        country: 'CH',
        organization: 'bar',
        commonname: 'baz',
        base_dir: '/tmp/foo',
      }
    end

    it { is_expected.to compile.and_raise_error(%r{got 'foo'}) }
  end

  context 'when passing wrong type for state' do
    let(:params) do
      {
        country: 'CH',
        organization: 'bar',
        commonname: 'baz',
        base_dir: '/tmp/foo',
        state: true,
      }
    end

    it { is_expected.to compile.and_raise_error(%r{got Boolean}) }
  end

  context 'when passing wrong type for locality' do
    let(:params) do
      {
        country: 'CH',
        organization: 'bar',
        commonname: 'baz',
        base_dir: '/tmp/foo',
        locality: true,
      }
    end

    it { is_expected.to compile.and_raise_error(%r{got Boolean}) }
  end

  context 'when passing wrong type for unit' do
    let(:params) do
      {
        country: 'CH',
        organization: 'bar',
        commonname: 'baz',
        base_dir: '/tmp/foo',
        unit: true,
      }
    end

    it { is_expected.to compile.and_raise_error(%r{got Boolean}) }
  end

  context 'when passing wrong type for altnames' do
    let(:params) do
      {
        country: 'CH',
        organization: 'bar',
        commonname: 'baz',
        base_dir: '/tmp/foo',
        altnames: true,
      }
    end

    it { is_expected.to compile.and_raise_error(%r{got Boolean}) }
  end

  context 'when passing wrong type for extkeyusage' do
    let(:params) do
      {
        country: 'CH',
        organization: 'bar',
        commonname: 'baz',
        base_dir: '/tmp/foo',
        extkeyusage: true,
      }
    end

    it { is_expected.to compile.and_raise_error(%r{got Boolean}) }
  end

  context 'when passing wrong type for email' do
    let(:params) do
      {
        country: 'CH',
        organization: 'bar',
        commonname: 'baz',
        base_dir: '/tmp/foo',
        email: true,
      }
    end

    it { is_expected.to compile.and_raise_error(%r{got Boolean}) }
  end

  context 'when passing wrong type for days' do
    let(:params) do
      {
        country: 'CH',
        organization: 'bar',
        commonname: 'baz',
        base_dir: '/tmp/foo',
        days: true,
      }
    end

    it { is_expected.to compile.and_raise_error(%r{got Boolean}) }
  end

  context 'when passing wrong type for base_dir' do
    let(:params) do
      {
        country: 'CH',
        organization: 'bar',
        commonname: 'baz',
        base_dir: true,
      }
    end

    it { is_expected.to compile.and_raise_error(%r{got Boolean}) }
  end

  context 'when passing wrong type for owner' do
    let(:params) do
      {
        country: 'CH',
        organization: 'bar',
        commonname: 'baz',
        owner: true,
        base_dir: '/tmp/foo',
      }
    end

    it { is_expected.to compile.and_raise_error(%r{got Boolean}) }
  end

  context 'when passing wrong type for password' do
    let(:params) do
      {
        country: 'CH',
        organization: 'bar',
        commonname: 'baz',
        base_dir: '/tmp/foo',
        password: true,
      }
    end

    it { is_expected.to compile.and_raise_error(%r{got Boolean}) }
  end

  context 'when passing wrong type for force' do
    let(:params) do
      {
        country: 'CH',
        organization: 'bar',
        commonname: 'baz',
        base_dir: '/tmp/foo',
        force: 'foobar',
      }
    end

    it { is_expected.to compile.and_raise_error(%r{got String}) }
  end

  context 'when passing wrong type for key_size' do
    let(:params) do
      {
        country: 'CH',
        organization: 'bar',
        commonname: 'baz',
        base_dir: '/tmp/foo',
        key_size: true,
      }
    end

    it { is_expected.to compile.and_raise_error(%r{got Boolean}) }
  end

  context 'when passing numeric owner' do
    let(:params) do
      {
        country: 'foo',
        organization: 'bar',
        commonname: 'baz',
        owner: 0,
      }
    end

    it {
      is_expected.to contain_file('/etc/ssl/certs/foo.key').with(
        ensure: 'present',
        owner: 0
      )
    }

    it {
      is_expected.to contain_file('/etc/ssl/certs/foo.crt').with(
        ensure: 'present',
        owner: 0
      )
    }

    it {
      is_expected.to contain_file('/etc/ssl/certs/foo.csr').with(
        ensure: 'present',
        owner: 0
      )
    }
  end

  context 'when passing numeric group' do
    let(:params) do
      {
        country: 'foo',
        organization: 'bar',
        commonname: 'baz',
        group: 0,
      }
    end

    it {
      is_expected.to contain_file('/etc/ssl/certs/foo.key').with(
        ensure: 'present',
        group: 0
      )
    }

    it {
      is_expected.to contain_file('/etc/ssl/certs/foo.crt').with(
        ensure: 'present',
        group: 0
      )
    }

    it {
      is_expected.to contain_file('/etc/ssl/certs/foo.csr').with(
        ensure: 'present',
        group: 0
      )
    }
  end

  context 'when passing numeric key_owner' do
    let(:params) do
      {
        country: 'foo',
        organization: 'bar',
        commonname: 'baz',
        key_owner: 0,
      }
    end

    it {
      is_expected.to contain_file('/etc/ssl/certs/foo.key').with(
        ensure: 'present',
        owner: 0
      )
    }
  end

  context 'when passing numeric key_group' do
    let(:params) do
      {
        country: 'foo',
        organization: 'bar',
        commonname: 'baz',
        key_group: 0,
      }
    end

    it {
      is_expected.to contain_file('/etc/ssl/certs/foo.key').with(
        ensure: 'present',
        group: 0
      )
    }
  end

  context 'when using defaults' do
    let(:params) do
      {
        country: 'com',
        organization: 'bar',
        commonname: 'baz',
      }
    end

    it {
      is_expected.to contain_file('/etc/ssl/certs/foo.cnf').with(
        ensure: 'present',
        owner: 'root'
      ).with_content(
        %r{countryName\s+=\s+com}
      ).with_content(
        %r{organizationName\s+=\s+bar}
      ).with_content(
        %r{commonName\s+=\s+baz}
      ).without_content(
        %r{v3_req}
      )
    }

    it {
      is_expected.to contain_ssl_pkey('/etc/ssl/certs/foo.key').with(
        ensure: 'present',
        password: nil
      )
    }

    it {
      is_expected.to contain_x509_cert('/etc/ssl/certs/foo.crt').with(
        ensure: 'present',
        template: '/etc/ssl/certs/foo.cnf',
        csr: '/etc/ssl/certs/foo.csr',
        days: 365,
        password: nil,
        force: true
      )
    }

    it {
      is_expected.to contain_x509_request('/etc/ssl/certs/foo.csr').with(
        ensure: 'present',
        template: '/etc/ssl/certs/foo.cnf',
        private_key: '/etc/ssl/certs/foo.key',
        password: nil,
        force: true
      )
    }

    it {
      is_expected.to contain_file('/etc/ssl/certs/foo.key').with(
        ensure: 'present',
        owner: 'root'
      )
    }

    it {
      is_expected.to contain_file('/etc/ssl/certs/foo.crt').with(
        ensure: 'present',
        owner: 'root'
      )
    }

    it {
      is_expected.to contain_file('/etc/ssl/certs/foo.csr').with(
        ensure: 'present',
        owner: 'root'
      )
    }
  end

  context 'when passing all parameters' do
    let(:params) do
      {
        country: 'com',
        organization: 'bar',
        commonname: 'baz',
        state: 'FR',
        locality: 'here',
        unit: 'braz',
        altnames: ['a.com', 'b.com', 'c.com'],
        extkeyusage: %w[serverAuth clientAuth],
        email: 'contact@foo.com',
        days: 4567,
        key_size: 4096,
        owner: 'www-data',
        password: '5r$}^',
        force: false,
        base_dir: '/tmp/foobar',
      }
    end

    it {
      is_expected.to contain_file('/tmp/foobar/foo.cnf').with(
        ensure: 'present',
        owner: 'www-data'
      ).with_content(
        %r{countryName\s+=\s+com}
      ).with_content(
        %r{stateOrProvinceName\s+=\s+FR}
      ).with_content(
        %r{localityName\s+=\s+here}
      ).with_content(
        %r{organizationName\s+=\s+bar}
      ).with_content(
        %r{organizationalUnitName\s+=\s+braz}
      ).with_content(
        %r{commonName\s+=\s+baz}
      ).with_content(
        %r{emailAddress\s+=\s+contact@foo\.com}
      ).with_content(
        %r{extendedKeyUsage\s+=\s+serverAuth,\s+clientAuth}
      ).with_content(
        %r{subjectAltName\s+=\s+@alt_names}
      ).with_content(
        %r{DNS\.0\s+=\s+a\.com}
      ).with_content(
        %r{DNS\.1\s+=\s+b\.com}
      ).with_content(
        %r{DNS\.2\s+=\s+c\.com}
      )
    }

    it {
      is_expected.to contain_ssl_pkey('/tmp/foobar/foo.key').with(
        ensure: 'present',
        password: '5r$}^',
        size: 4096
      )
    }

    it {
      is_expected.to contain_x509_cert('/tmp/foobar/foo.crt').with(
        ensure: 'present',
        template: '/tmp/foobar/foo.cnf',
        csr: '/tmp/foobar/foo.csr',
        days: 4567,
        password: '5r$}^',
        force: false
      )
    }

    it {
      is_expected.to contain_x509_request('/tmp/foobar/foo.csr').with(
        ensure: 'present',
        template: '/tmp/foobar/foo.cnf',
        private_key: '/tmp/foobar/foo.key',
        password: '5r$}^',
        force: false
      )
    }

    it {
      is_expected.to contain_file('/tmp/foobar/foo.key').with(
        ensure: 'present',
        owner: 'www-data'
      )
    }

    it {
      is_expected.to contain_file('/tmp/foobar/foo.crt').with(
        ensure: 'present',
        owner: 'www-data'
      )
    }

    it {
      is_expected.to contain_file('/tmp/foobar/foo.csr').with(
        ensure: 'present',
        owner: 'www-data'
      )
    }
  end
end
