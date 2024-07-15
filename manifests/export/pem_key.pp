# @summary Export a key to PEM format
#
# @param pfx_cert
#   PFX certificate/key container
# @param pem_key
#   PEM certificate
# @param dynamic
#   dynamically renew key file
# @param ensure
#   Whether the keyfile should exist
# @param resources
#   List of resources to subcribe for key renewal
# @param in_pass
#   PFX container password
# @param out_pass
#   PEM key password
#
define openssl::export::pem_key (
  Stdlib::Absolutepath       $pfx_cert,
  Stdlib::Absolutepath       $pem_key   = $title,
  Boolean                    $dynamic   = false,
  Enum['present', 'absent']  $ensure    = present,
  Variant[Type, Array[Type]] $resources = [],
  Optional[String]           $in_pass   = undef,
  Optional[String]           $out_pass  = undef,
) {
  if $ensure == 'present' {
    $passin_opt = $in_pass ? {
      undef   => '',
      default => "-passin pass:${shellquote($in_pass)}",
    }

    $passout_opt = $out_pass ? {
      undef   => '-nodes',
      default => "-passout pass:${shellquote($out_pass)}",
    }

    $cmd = [
      'openssl pkcs12',
      "-in ${pfx_cert}",
      "-out ${pem_key}",
      '-nocerts',
      $passin_opt,
      $passout_opt,
    ]

    if $dynamic {
      $exec_params = {
        refreshonly => true,
        subscribe   => $resources,
      }
    } else {
      $exec_params = { creates => $pem_key, }
    }

    exec { "Export ${pfx_cert} to ${pem_key}":
      command => inline_template('<%= @cmd.join(" ") %>'),
      path    => $facts['path'],
      *       => $exec_params,
    }
  } else {
    file { $pem_key:
      ensure => absent,
    }
  }
}
