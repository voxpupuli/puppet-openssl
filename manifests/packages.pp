# == Class: openssl::packages
#
# Sets up packages for openssl
class openssl::packages {
  package { 'openssl':
    ensure => $openssl::package_ensure,
    name   => $openssl::package_name,
  }

  if $::osfamily == 'Debian' or (
  $::osfamily == 'RedHat' and versioncmp($::operatingsystemrelease, '6.0') >= 0) {
    ensure_packages(['ca-certificates'], {
      ensure => $openssl::ca_certificates_ensure,
    })

    if $::osfamily == 'Debian' {
      exec { 'update-ca-certificates':
        path        => $::path,
        refreshonly => true,
        require     => Package['ca-certificates'],
      }
    }
  }
}
