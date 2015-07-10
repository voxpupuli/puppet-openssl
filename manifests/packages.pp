# == Class: openssl::packages
#
# Sets up packages for openssl
class openssl::packages {
  package { 'openssl':
    ensure => $openssl::package_ensure,
  }

  if $::osfamily == 'Debian' {
    package { 'ca-certificates':
      ensure => $openssl::ca_certificates_ensure,
      before => Package['openssl'],
    }

    exec { 'update-ca-certificates':
      path        => $::path,
      refreshonly => true,
      require     => Package['ca-certificates'],
    }
  }
}
