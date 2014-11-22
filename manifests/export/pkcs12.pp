# == Definition: openssl::export::pkcs12
#
# Export a key pair to PKCS12 format
#
# == Parameters
#   [*basedir*]   - directory where you want the export to be done. Must exists
#   [*pkey*]      - private key
#   [*cert*]      - certificate
#   [*pkey_pass*] - private key password
#   [*chaincert*] - chain certificate to include in pkcs12
#
define openssl::export::pkcs12(
  $basedir,
  $pkey,
  $cert,
  $ensure    = present,
  $chaincert = false,
  $pkey_pass = false,
) {
  case $ensure {
    present: {
      $pass_opt = $pkey_pass ? {
        false   => '',
        default => "-passout pass:${pkey_pass}",
      }

      $chain_opt = $chaincert ? {
        false   => '',
        default => "-chain -CAfile ${chaincert}",
      }

      $cmd = [
        'openssl pkcs12 -export',
        "-in ${cert}",
        "-inkey ${pkey}",
        "-out ${basedir}/${name}.p12",
        "-name ${name}",
        '-nodes -noiter',
        $chain_opt,
        $pass_opt,
      ]

      exec {"Export ${name} to ${basedir}/${name}.p12":
        command => inline_template('<%= @cmd.join(" ") %>'),
        creates => "${basedir}/${name}.p12",
      }
    }
    absent: {
      file {"${basedir}/${name}.p12":
        ensure => absent,
      }
    }
  }
}
