# == Class: openssl
#
# Installs openssl and ensures bundled certificate list is world readable.
#
# === Parameters
#  [*package_name*]             openssl package name
#  [*package_ensure*]           openssl package ensure
#  [*ca_certificates_ensure*]   ca-certificates package ensure
#  [*dev_package_ensure*]       dev package ensure (currently only Ubuntu)
#
# === Example
#
#   class { '::openssl':
#     package_name           => 'openssl-othername',
#     package_ensure         => latest,
#     ca_certificates_ensure => latest,
#     dev_package_ensure     => latest,
#   }
#
class openssl (
  $package_name           = 'openssl',
  $package_ensure         = present,
  $ca_certificates_ensure = present,
  $dev_package_ensure     = undef,
){
  class { '::openssl::packages': }
  -> Class['openssl']
}
