# frozen_string_literal: true

require 'spec_helper_acceptance'

# the openssl output changed and differs between EL9 vs older versions
# https://github.com/mizzy/serverspec/commit/ac366dd40015f0b53e70a3ed881b931dfc83c603 might not be a correct fix
# Ewoud is working on a fix in https://github.com/ekohl/serverspec/commit/64874e9c8cc70b097300c3a60281572a3528768e
# in the meantime we won't use x509_certificate matcher
describe 'x509 to pkcs12 to pem key' do
  it_behaves_like 'the example', 'x509_pkcs12_pemkey.pp' do
    it { expect(file('/tmp/sample_x509.crt')).to be_file.and(its(:size) { is_expected.to > 0 }) }
    it { expect(file('/tmp/sample_x509.key')).to be_file.and(its(:size) { is_expected.to > 0 }) }
    it { expect(file('/tmp/export.pkcs12.p12')).to be_file.and(its(:size) { is_expected.to > 0 }) }

    describe x509_certificate('/tmp/sample_x509.crt') do
      it { is_expected.to be_certificate }
      it { is_expected.to be_valid }
      its(:keylength) { is_expected.to eq 1024 }
    end

    describe command('openssl -text -noout -in /tmp/export.pkcs12.p12 -inpass pass:') do
      its(:exit_status) { is_expected.to eq 0 }
    end
  end
end
