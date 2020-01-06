# == Definition: openssl::export::pkcs12
#
# Export a key pair to PKCS12 format
#
# == Parameters
#   [*basedir*]   - directory where you want the export to be done. Must exists
#   [*pkey*]      - private key
#   [*cert*]      - certificate
#   [*in_pass*]   - private key password
#   [*out_pass*]  - PKCS12 password
#   [*chaincert*] - chain certificate to include in pkcs12
#
define openssl::export::pkcs12(
  Stdlib::Absolutepath      $basedir,
  Stdlib::Absolutepath      $pkey,
  Stdlib::Absolutepath      $cert,
  Enum['present', 'absent'] $ensure    = present,
  Boolean                   $chaincert = false,
  Boolean                   $in_pass   = false,
  Boolean                   $out_pass  = false,
) {
  if $ensure == 'present' {
    $pass_opt = $in_pass ? {
      false   => '',
      default => "-passin pass:${in_pass}",
    }

    $passout_opt = $out_pass ? {
      false   => '',
      default => "-passout pass:${out_pass}",
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
      $passout_opt,
    ]

    exec {"Export ${name} to ${basedir}/${name}.p12":
      command => inline_template('<%= @cmd.join(" ") %>'),
      path    => $::path,
      creates => "${basedir}/${name}.p12",
    }
  } else {
    file { "${basedir}/${name}.p12":
      ensure => absent,
    }
  }
}
