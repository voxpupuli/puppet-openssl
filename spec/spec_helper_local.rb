require 'webmock/rspec'

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

    stub_request(:get, 'http://example.org/cert.der')
      .to_return(status: 200, body: File.new(File.join(File.dirname(__FILE__), 'fixtures/test-cert.der')), headers: {})
    stub_request(:get, 'http://example.org/cert.pem')
      .to_return(status: 200, body: File.new(File.join(File.dirname(__FILE__), 'fixtures/test-cert.pem')), headers: {})
  end

  config.after :each do
    RSpec::Mocks.verify
    RSpec::Mocks.teardown
  end
end
