# @summary Installs openssl and ensures bundled certificate list is world readable
#
# @param package_name
#   openssl package name
#
# @param package_ensure
#   openssl package ensure
#
# @param ca_certificates_ensure
#   ca-certificates package ensure
#
# @example basic usage
#   class { 'openssl':
#     package_name           => 'openssl-othername',
#     package_ensure         => latest,
#     ca_certificates_ensure => latest,
#   }
#
class openssl (
  Optional[String[1]] $package_name = undef,
  String[1] $package_ensure = installed,
  String[1] $ca_certificates_ensure = installed,
) {
  contain 'openssl::packages'
}
