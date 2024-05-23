# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'x509_cert example' do
  it_behaves_like 'the example', 'dhparam.pp' do
    it { expect(file('/etc/ssl/certs/dhparam.pem')).to be_file }
  end
end
