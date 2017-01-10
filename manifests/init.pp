# == Class: openssl
#
# Installs openssl and ensures bundled certificate list is world readable.
#
# === Parameters
#  [*package_name*]             openssl package name
#  [*package_ensure*]           openssl package ensure
#  [*ca_certificates_ensure*]   ca-certificates package ensure
#
# === Example
#
#   class { '::openssl':
#     package_name           => 'openssl-othername',
#     package_ensure         => latest,
#     ca_certificates_ensure => latest,
#   }
#
class openssl (
  $package_name           = 'openssl',
  $package_ensure         = present,
  $ca_certificates_ensure = present,
){
  class { '::openssl::packages': } ->
  Class['openssl']
}
