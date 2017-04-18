# == Definition: openssl::export::pem_key
#
# Export a key to PEM format
#
# == Parameters
#   [*pfx_cert*]  - PFX certificate/key container
#   [*pem_key*]   - PEM certificate
#   [*in_pass*]   - PFX container password
#   [*out_pass*]  - PEM key password
#
define openssl::export::pem_key(
  $pfx_cert,
  $pem_key   = $title,
  $ensure    = present,
  $in_pass   = false,
  $out_pass  = false,
) {
  case $ensure {
    'present': {
      $passin_opt = $in_pass ? {
        false   => '',
        default => "-passin pass:'${in_pass}'",
      }

      $passout_opt = $out_pass ? {
        false   => '-nodes',
        default => "-passout pass:'${out_pass}'",
      }

      $cmd = [
        'openssl pkcs12',
        "-in ${pfx_cert}",
        "-out ${pem_key}",
        '-nocerts',
        $passin_opt,
        $passout_opt,
      ]

      exec {"Export ${pfx_cert} to ${pem_key}":
        command => inline_template('<%= @cmd.join(" ") %>'),
        path    => $::path,
        creates => $pem_key,
      }
    }
    'absent': {
      file {$pem_key:
        ensure => absent,
      }
    }
  }
}
