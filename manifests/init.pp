# == Class: openssl
#
# Installs openssl and ensures bundled certificate list is world readable.
#
class openssl (
  $package_ensure         = present,
  $ca_certificates_ensure = present,
){
  class { '::openssl::packages': } ->
  Class['openssl']
}
