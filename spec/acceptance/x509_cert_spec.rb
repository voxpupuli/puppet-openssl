# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'x509_cert example' do
  it_behaves_like 'the example', 'x509_cert.pp' do
    it { expect(file('/tmp/foo.example.com.crt')).to be_file.and(have_attributes(owner: 'nobody')) }
    it { expect(x509_certificate('/tmp/foo.example.com.crt')).to be_certificate.and(have_attributes(subject: 'C = CH, O = Example.com, CN = foo.example.com')) }

    it { expect(file('/tmp/foo.example.com.key')).to be_file.and(have_attributes(owner: 'nobody', mode: '600')) }
    it { expect(x509_private_key('/tmp/foo.example.com.key', passin: 'pass:mahje1Qu')).to have_matching_certificate('/tmp/foo.example.com.crt') }
  end
end
