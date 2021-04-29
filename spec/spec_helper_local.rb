require 'webmock/rspec'
require 'openssl'

# HACK: to enable all the expect syntax (like allow_any_instance_of) in rspec-puppet examples
RSpec::Mocks::Syntax.enable_expect(RSpec::Puppet::ManifestMatchers)

RSpec.configure do |config|
  config.mock_with :rspec

  config.before :each do
    # Ensure that we don't accidentally cache facts and environment between
    # test cases.  This requires each example group to explicitly load the
    # facts being exercised with something like
    # Facter.collection.loader.load(:ipaddress)
    Facter.clear
    Facter.clear_messages

    RSpec::Mocks.setup

    test_keys = OpenSSL::PKey::RSA.new(2049)
    test_cert = OpenSSL::X509::Certificate.new
    test_cert.version = 2
    test_cert.serial = 1
    test_cert.subject = OpenSSL::X509::Name.parse('/CN=test-cert.example.org')
    test_cert.public_key = test_keys.public_key
    test_cert.not_before = Time.now
    test_cert.not_after = test_cert.not_before + 3600 # 1 hour
    test_cert.sign(test_keys, OpenSSL::Digest::SHA256.new)

    resp_header = { 'Content-Type': 'application/x-x509-ca-cert' }
    stub_request(:get, 'http://example.org/cert.der')
      .to_return(status: 200, body: test_cert.to_der, headers: resp_header)
    stub_request(:get, 'http://example.org/cert.pem')
      .to_return(status: 200, body: test_cert.to_pem, headers: resp_header)
  end

  config.after :each do
    RSpec::Mocks.verify
    RSpec::Mocks.teardown
  end
end
