require 'spec_helper'
# rubocop:disable RSpec/MessageSpies
describe 'cert_date_valid' do
  it { is_expected.not_to eq(nil) }

  it 'raises an error if called with no argument' do
    is_expected.to run.with_params.and_raise_error(StandardError)
  end

  it 'raises an error if there is more than 1 arguments' do
    is_expected.to run.with_params({ 'foo' => 1 }, 'bar' => 2).and_raise_error(StandardError)
  end

  it 'raises an error if argument is not the proper type' do
    is_expected.to run.with_params(true).and_raise_error(ArgumentError)
  end

  context 'when the argument is correct' do
    let(:cert) { OpenSSL::X509::Certificate.new }

    before do
      allow(File).to receive(:read).and_return('bleh')
    end

    it 'returns false if cert is not valid anymore' do
      expect(OpenSSL::X509::Certificate).to receive(:new).with('bleh').and_return(cert)
      cert.not_before = Time.now - 3600
      cert.not_after = Time.now - 1000
      is_expected.to run.with_params('/path/to/cert').and_return(false)
    end

    it 'returns false if cert is not valid yet' do
      expect(OpenSSL::X509::Certificate).to receive(:new).with('bleh').and_return(cert)
      cert.not_before = Time.now + 1000
      cert.not_after = Time.now + 3600
      is_expected.to run.with_params('/path/to/cert').and_return(false)
    end

    it 'returns false if cert will never be valid' do
      expect(OpenSSL::X509::Certificate).to receive(:new).with('bleh').and_return(cert)
      cert.not_before = Time.now + 1000
      cert.not_after = Time.now - 1000
      is_expected.to run.with_params('/path/to/cert').and_return(false)
    end

    it 'returns true if it is still valid' do
      expect(OpenSSL::X509::Certificate).to receive(:new).with('bleh').and_return(cert)
      cert.not_before = Time.now - 1000
      cert.not_after = cert.not_before + 2000
      is_expected.to run.with_params('/path/to/cert').and_return(999)
    end
  end
end
