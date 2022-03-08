# frozen_string_literal: true

require 'spec_helper'

describe 'cert_aia_caissuers' do
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

  context 'when the argument does not exists' do
    it 'returns nil if cert does not exists or readable' do
      is_expected.to run.with_params('/path/to/cert').and_return(nil)
    end
  end

  context 'when the argument is correct' do
    let(:cert) { OpenSSL::X509::Certificate.new }

    before do
      allow(File).to receive(:read).and_return('foo')
    end

    it 'returns nil if cert does not contains AIA extension' do
      expect(OpenSSL::X509::Certificate).to receive(:new).with('foo').and_return(cert)
      is_expected.to run.with_params('/path/to/cert').and_return(nil)
    end

    it 'returns caIssuers URL if cert contains it' do
      expect(OpenSSL::X509::Certificate).to receive(:new).with('foo').and_return(cert)
      extension_factory = OpenSSL::X509::ExtensionFactory.new
      aia = extension_factory.create_extension(
        'authorityInfoAccess',
        'caIssuers;URI:http://ca.example.org/cer',
        false
      )
      cert.add_extension(aia)
      is_expected.to run.with_params('/path/to/cert').and_return('http://ca.example.org/cer')
    end
  end
end
