# == Class: openssl::certificates
#
# Generates x509 certificates based on class parameters
#
# === Parameters
#  [*x509_certs*]
#
# === Example
#
#   class { '::openssl::certificate':
#     x509_certs => { '/path/to/certificate.crt' => {  ensure      => 'present',
#                                                      password    => 'j(D$',
#                                                      template    => '/other/path/to/template.cnf',
#                                                      private_key => '/there/is/my/private.key',
#                                                      days        => 4536,
#                                                      force       => false,},
#                     '/a/other/certificate.crt' => {  ensure      => 'present', },
#                   }
#   }
#
class openssl::certificates (
  $x509_certs = {},
){
  validate_hash($x509_certs)

  if $x509_certs {
    ensure_resources('openssl::certificate::x509', $x509_certs)
  }
}
