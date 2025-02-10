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
  $full_path = "${basedir}/${name}.p12"

  if $ensure == 'present' {
    if $in_pass {
      $passin_opt = ['-nokeys', '-passin', 'env:CERTIFICATE_PASSIN']
      $passin_env = ["CERTIFICATE_PASSIN=${in_pass}"]
    } else {
      $passin_opt = []
      $passin_env = []
    }

    if $out_pass {
      $passout_opt = ['-nokeys', '-passout', 'env:CERTIFICATE_PASSOUT']
      $passout_env = ["CERTIFICATE_PASSOUT=${out_pass}"]
    } else {
      $passout_opt = []
      $passout_env = []
    }

    $chain_opt = $chaincert ? {
      undef   => [],
      default => ['-chain', '-CAfile', $chaincert],
    }

    $cmd = [
      'openssl', 'pkcs12', '-export',
      '-in', $cert,
      '-inkey', $pkey,
      '-out', $full_path,
      '-name', $name,
      '-nodes', '-noiter',
    ] + $chain_opt + $passin_opt + $passout_opt

    $exec_params = if $dynamic {
      { refreshonly => true, subscribe => $resources }
    } else {
      { creates => $full_path }
    }

    exec { "Export ${name} to ${full_path}":
      command     => $cmd,
      environment => $passin_env + $passout_env,
      path        => $facts['path'],
      *           => $exec_params,
    }
  } else {
    file { $full_path:
      ensure => absent,
    }
  }
}
