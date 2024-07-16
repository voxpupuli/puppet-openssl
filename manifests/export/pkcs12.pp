# @summary Export a key pair to PKCS12 format
#
# @param basedir
#   Directory where you want the export to be done. Must exists
# @param pkey
#   Private key
# @param cert
#   Certificate
# @param dynamic
#   dynamically renew PKCS12 file
# @param ensure
#   Whether the PKCS12 file should exist
# @param resources
#   List of resources to subscribe to for PKCS12 renewal
# @param in_pass
#   Private key password
# @param out_pass
#   PKCS12 password
# @param chaincert
#   Chain certificate to include in pkcs12
#
define openssl::export::pkcs12 (
  Stdlib::Absolutepath       $basedir,
  Stdlib::Absolutepath       $pkey,
  Stdlib::Absolutepath       $cert,
  Boolean                    $dynamic   = false,
  Enum['present', 'absent']  $ensure    = present,
  Variant[Type, Array[Type]] $resources = [],
  Optional[String]           $chaincert = undef,
  Optional[String]           $in_pass   = undef,
  Optional[String]           $out_pass  = undef,
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

    $full_path = "${basedir}/${name}.p12"

    if $dynamic {
      $exec_params = {
        refreshonly => true,
        subscribe   => $resources,
      }
    } else {
      $exec_params = { creates => $full_path, }
    }

    exec { "Export ${name} to ${full_path}":
      command => inline_template('<%= @cmd.join(" ") %>'),
      path    => $facts['path'],
      *       => $exec_params,
    }
  } else {
    file { "${basedir}/${name}.p12":
      ensure => absent,
    }
  }
}
