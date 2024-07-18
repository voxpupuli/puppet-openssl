# frozen_string_literal: true

require 'spec_helper_acceptance'

# the openssl output changed and differs between EL9 vs older versions
# https://github.com/mizzy/serverspec/commit/ac366dd40015f0b53e70a3ed881b931dfc83c603 might not be a correct fix
# Ewoud is working on a fix in https://github.com/ekohl/serverspec/commit/64874e9c8cc70b097300c3a60281572a3528768e
# in the meantime we won't use x509_certificate matcher
describe 'x509_cert example' do
  it_behaves_like 'the example', 'x509_cert.pp' do
    it { expect(file('/tmp/foo.example.com.crt')).to be_file.and(have_attributes(owner: 'nobody')) }
    # it { expect(x509_certificate('/tmp/foo.example.com.crt')).to be_certificate.and(have_attributes(subject: 'C = CH, O = Example.com, CN = foo.example.com')) }

    describe x509_certificate('/tmp/foo.example.com.crt') do
      it { is_expected.to be_certificate }
      it { is_expected.to be_valid }
      its(:subject) { is_expected.to match_without_whitespace(%r{C = CH, O = Example.com, CN = foo.example.com}) }
      its(:keylength) { is_expected.to eq 3072 }
    end

    it { expect(file('/tmp/foo.example.com.key')).to be_file.and(have_attributes(owner: 'nobody', mode: '600')) }
    it { expect(x509_private_key('/tmp/foo.example.com.key', passin: 'pass:mahje1Qu')).to have_matching_certificate('/tmp/foo.example.com.crt') }
  end
end
