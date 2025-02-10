# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'pkcs12 example' do
  it_behaves_like 'the example', 'export_pkcs12_from_key.pp' do
    it { expect(file('/tmp/foo.example.com.crt')).to be_file.and(have_attributes(owner: 'nobody', group: 'root')) }
    it { expect(file('/tmp/foo.example.com.key')).to be_file.and(have_attributes(owner: 'nobody', group: 'root')) }
    it { expect(file('/tmp/export.pkcs12.p12')).to be_file.and(have_attributes(owner: 'root', group: 'root')) }
    it { expect(file('/tmp/foo2.example.com.crt')).to be_file.and(have_attributes(owner: 'nobody', group: 'root')) }
    it { expect(file('/tmp/foo2.example.com.key')).to be_file.and(have_attributes(owner: 'nobody', group: 'root')) }
    it { expect(file('/tmp/export2.pkcs12.p12')).to be_file.and(have_attributes(owner: 'root', group: 'root')) }
    it { expect(file('/tmp/foo3.example.com.crt')).to be_file.and(have_attributes(owner: 'nobody', group: 'root')) }
    it { expect(file('/tmp/foo3.example.com.key')).to be_file.and(have_attributes(owner: 'nobody', group: 'root')) }
    it { expect(file('/tmp/export3.pkcs12.p12')).to be_file.and(have_attributes(owner: 'root', group: 'root')) }
    it { expect(file('/tmp/foo4.example.com.crt')).to be_file.and(have_attributes(owner: 'nobody', group: 'root')) }
    it { expect(file('/tmp/foo4.example.com.key')).to be_file.and(have_attributes(owner: 'nobody', group: 'root')) }
    it { expect(file('/tmp/export4.pkcs12.p12')).to be_file.and(have_attributes(owner: 'root', group: 'root')) }
  end
  # rubocop:disable RSpec/RepeatedExampleGroupBody
  describe file('/tmp/export.pkcs12.p12') do
    its(:size) { is_expected.to be > 0 }
  end

  describe file('/tmp/export2.pkcs12.p12') do
    its(:size) { is_expected.to be > 0 }
  end

  describe file('/tmp/export3.pkcs12.p12') do
    its(:size) { is_expected.to be > 0 }
  end

  describe file('/tmp/export4.pkcs12.p12') do
    its(:size) { is_expected.to be > 0 }
  end

  if fact('openssl_version').split('.').first.to_i > 1
    describe command('openssl pkcs12 -info -in /tmp/export3.pkcs12.p12 -passin pass: -passout pass:') do
      its(:stdout) { is_expected.to contain('-----BEGIN CERTIFICATE-----') }
      its(:stdout) { is_expected.to contain('-----BEGIN ENCRYPTED PRIVATE KEY-----') }
      its(:exit_status) { is_expected.to eq 0 }
    end

    describe command('openssl pkcs12 -info -in /tmp/export.pkcs12.p12 -passin pass:mahje1Qu -passout pass:') do
      its(:stdout) { is_expected.to contain('-----BEGIN CERTIFICATE-----') }
      its(:stdout) { is_expected.to contain('-----BEGIN ENCRYPTED PRIVATE KEY-----') }
      its(:exit_status) { is_expected.to eq 0 }
    end
  end

  # rubocop:enable RSpec/RepeatedExampleGroupBody
end
