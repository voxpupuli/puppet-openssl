# @summary Export a key pair to PKCS12 format
#
# @param basedir
#   Directory where you want the export to be done. Must exists
# @param pkey
#   Private key
# @param cert
#   Certificate
# @param ensure
#   Whether the PKCS12 file should exist
# @param in_pass
#   Private key password
# @param out_pass
#   PKCS12 password
# @param chaincert
#   Chain certificate to include in pkcs12
#
define openssl::export::pkcs12 (
  Stdlib::Absolutepath      $basedir,
  Stdlib::Absolutepath      $pkey,
  Stdlib::Absolutepath      $cert,
  Enum['present', 'absent'] $ensure    = present,
  Optional[String]          $chaincert = undef,
  Optional[String]          $in_pass   = undef,
  Optional[String]          $out_pass  = undef,
) {
  if $ensure == 'present' {
    $pass_opt = $in_pass ? {
      undef   => '',
      default => "-passin pass:${shellquote($in_pass)}",
    }

    $passout_opt = $out_pass ? {
      undef   => '',
      default => "-passout pass:${shellquote($out_pass)}",
    }

    $chain_opt = $chaincert ? {
      undef   => '',
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

    exec { "Export ${name} to ${basedir}/${name}.p12":
      command => inline_template('<%= @cmd.join(" ") %>'),
      path    => $facts['path'],
      creates => "${basedir}/${name}.p12",
    }
  } else {
    file { "${basedir}/${name}.p12":
      ensure => absent,
    }
  }
}
