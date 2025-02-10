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
  # rubocop:enable RSpec/RepeatedExampleGroupBody
end
