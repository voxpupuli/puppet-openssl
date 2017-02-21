# == Definition: openssl::export::pem_cert
#
# Export certificate(s) to PEM/x509 format
#
# == Parameters
#   [*pfx_cert*]  - PFX certificate/key container
#   [*pem_cert*]  - PEM/x509 certificate
#   [*in_pass*]   - PFX password
#
define openssl::export::pem_cert(
  $pfx_cert,
  $pem_cert  = $title,
  $ensure    = present,
  $in_pass   = false,
) {
  case $ensure {
    'present': {
      $passin_opt = $in_pass ? {
        false   => '',
        default => "-passin pass:'${in_pass}'",
      }

      $cmd = [
        'openssl pkcs12',
        "-in ${pfx_cert}",
        "-out ${pem_cert}",
        '-nokeys',
        $passin_opt,
      ]

      exec {"Export ${pfx_cert} to ${pem_cert}":
        command => inline_template('<%= @cmd.join(" ") %>'),
        path    => $::path,
        creates => $pem_cert,
      }
    }
    'absent': {
      file {$pem_cert:
        ensure => absent,
      }
    }
  }
}
