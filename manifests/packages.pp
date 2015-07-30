# == Class: openssl::packages
#
# Sets up packages for openssl
class openssl::packages {
  package { 'openssl':
    ensure => $openssl::package_ensure,
  }

  if $::osfamily == 'Debian' or (
  $::osfamily == 'RedHat' and versioncmp($::operatingsystemrelease, '6.0') >= 0) {
    package { 'ca-certificates':
      ensure => $openssl::ca_certificates_ensure,
      before => Package['openssl'],
    }

    if $::osfamily == 'Debian' {
      exec { 'update-ca-certificates':
        path        => $::path,
        refreshonly => true,
        require     => Package['ca-certificates'],
      }
    }
  }
}
