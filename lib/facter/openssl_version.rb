# frozen_string_literal: true

Facter.add(:openssl_version) do
  confine { Facter::Core::Execution.which('openssl') }

  setcode do
    openssl_version = Facter::Core::Execution.execute('openssl version 2>&1')
    matches = %r{^OpenSSL ([\w.-]+)(\s+FIPS)?( +)([\d.]+)( +)([\w.]+)( +)([\d.]+)}.match(openssl_version)
    matches[1] if matches
  end
end
