# == Class: openssl
#
# Installs openssl and ensures bundled certificate list is world readable.
#
# === Parameters
#
# [*install_devel*]
#   Whether or not to install the OpenSSL development libraries.  Defaults
#   to false.  Must be a boolean.
#
# === Examples
#
# include openssl
#
# class { 'openssl': }
#
# class { 'openssl':
#   install_devel => true
# }
#
class openssl (
  $install_devel = false
) {

  validate_bool($install_devel)

  class { '::openssl::packages': } ->
  class { '::openssl::config': } ->
  Class['openssl']
}
