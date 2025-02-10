# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'pkcs12 example' do
  it_behaves_like 'the example', 'export_pem_from_pkcs12.pp' do
    it { expect(file('/tmp/export_pem_from_pkcs12.example.com.crt')).to be_file.and(have_attributes(owner: 'nobody', group: 'root')) }
    it { expect(file('/tmp/export_pem_from_pkcs12.example.com.key')).to be_file.and(have_attributes(owner: 'nobody', group: 'root')) }
    it { expect(file('/tmp/export1_pem_from_pkcs12.pkcs12.p12')).to be_file.and(have_attributes(owner: 'root', group: 'root')) }
    it { expect(file('/tmp/export2_pem_from_pkcs12.pkcs12.p12')).to be_file.and(have_attributes(owner: 'root', group: 'root')) }
    it { expect(file('/tmp/export3_pem_from_pkcs12.pkcs12.p12')).to be_file.and(have_attributes(owner: 'root', group: 'root')) }
    it { expect(file('/tmp/export4_pem_from_pkcs12.pkcs12.p12')).to be_file.and(have_attributes(owner: 'root', group: 'root')) }
  end
  # rubocop:disable RSpec/RepeatedExampleGroupBody
  describe file('/tmp/export1_pem_from_pkcs12.pkcs12.p12') do
    its(:size) { is_expected.to be > 0 }
  end

  describe file('/tmp/export2_pem_from_pkcs12.pkcs12.p12') do
    its(:size) { is_expected.to be > 0 }
  end

  describe file('/tmp/export3_pem_from_pkcs12.pkcs12.p12') do
    its(:size) { is_expected.to be > 0 }
  end

  describe file('/tmp/export4_pem_from_pkcs12.pkcs12.p12') do
    its(:size) { is_expected.to be > 0 }
  end
  # rubocop:enable RSpec/RepeatedExampleGroupBody
end
