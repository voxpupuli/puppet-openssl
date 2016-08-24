Facter.add(:openssl_version) do
  setcode do
    if Facter::Util::Resolution.which('openssl')
      openssl_version = Facter::Util::Resolution.exec('openssl version 2>&1')
      matches = %r{^OpenSSL ([\w\.\-]+)([ ]+)([\d\.]+)([ ]+)([\w\.]+)([ ]+)([\d\.]+)}.match(openssl_version)
      matches[1] if matches
    end
  end
end
