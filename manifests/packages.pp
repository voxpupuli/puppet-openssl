# == Class: openssl::packages
#
# Sets up packages for openssl
class openssl::packages inherits openssl {

  case $::osfamily {
    'RedHat': {
      $devel_package = 'openssl-devel'
    }

    'Debian': {
      $devel_package = 'openssl-dev'
    }

    default: {
      fail("Operating systems in the ${::osfamily} family are not supported")
    }
  }

  package { 'openssl':
    ensure => present,
  }

  if $install_devel {
    package { 'openssl-devel':
      ensure => present,
      name   => $devel_package,
    }
  }

  if $::osfamily == 'Debian' {
    package { 'ca-certificates':
      ensure => present,
      before => Package['openssl'],
    }

    exec { 'update-ca-certificates':
      refreshonly => true,
      require     => Package['ca-certificates'],
    }
  }
}
