# frozen_string_literal: true

Facter.add(:openssl_version) do
  setcode do
    if Facter::Util::Resolution.which('openssl')
      openssl_version = Facter::Util::Resolution.exec('openssl version 2>&1')
      # OracleLinux did some uppercase-lowercase-extras
      matches = %r{^OpenSSL ([\w.]+)[ -]*(fips|FIPS|dev)? +([\d.]+) +([\w.]+) +([\d.]+) *(\([\w:. ]+\))?}.match(openssl_version)
      matches[1] if matches
    end
  end
end
