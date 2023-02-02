# @summary Generates x509 certificates based on class parameters
#
# @param x509_certs
#
# @example basic usage
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
  Hash $x509_certs = {},
) {
  if $x509_certs {
    ensure_resources('openssl::certificate::x509', $x509_certs)
  }
}
