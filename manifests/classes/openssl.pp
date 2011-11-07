/*

== Class: openssl

Installs openssl and ensures bundled certificate list is world readable.

*/
class openssl {

  package { "openssl":
    ensure => present
  }

  if $operatingsystem == "Debian" {

    package { "ca-certificates":
      ensure => present,
      before => [Package["openssl"], File["ca-certificates.crt"]],
    }

    exec { "update-ca-certificates":
      refreshonly => true,
      require     => Package["ca-certificates"],
      before      => File["ca-certificates.crt"],
    }
  }

  file { "ca-certificates.crt":
    mode    => 0644,
    owner   => "root",
    path    => $operatingsystem ? {
      Debian => "/etc/ssl/certs/ca-certificates.crt",
      RedHat => "/etc/pki/tls/certs/ca-bundle.crt",
    },
    require => Package["openssl"],
  }
}
