# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'pkcs12 example' do
  it_behaves_like 'the example', 'export_pkcs12_from_key.pp' do
    it { expect(file('/tmp/foo.example.com.crt')).to be_file.and(have_attributes(owner: 'nobody', group: 'root')) }
    it { expect(file('/tmp/foo.example.com.key')).to be_file.and(have_attributes(owner: 'nobody', group: 'root')) }
    it { expect(file('/tmp/export.pkcs12.p12')).to be_file.and(have_attributes(owner: 'root', group: 'root')) }
  end
  describe file('/tmp/export.pkcs12.p12') do
    its(:size) { is_expected.to be > 0 }
  end
end
