# @summary Export certificate(s) to PEM/x509 format
#
# @param dynamic
#   dynamically renew certificate file
# @param ensure
#   Whether the certificate file should exist
# @param resources
#   List of resources to subscribe to for certificate file renewal
# @param pfx_cert
#   PFX certificate/key container
# @param der_cert
#   DER certificate
# @param pem_cert
#   PEM/x509 certificate
# @param in_pass
#   PFX password
#
define openssl::export::pem_cert (
  Boolean                         $dynamic   = false,
  Enum['present', 'absent']       $ensure    = present,
  Variant[Type, Array[Type]]      $resources = [],
  Stdlib::Absolutepath            $pem_cert  = $title,
  Optional[Stdlib::Absolutepath]  $pfx_cert  = undef,
  Optional[Stdlib::Absolutepath]  $der_cert  = undef,
  Optional[String]                $in_pass   = undef,

) {
  #local variables

  # If ensure = present and  der_cert and $pfx_cert as being specified, then throw error
  if $ensure == present and !$der_cert and !$pfx_cert {
    fail('Parameter Error: either pfx_cert or der_cert must be specified')
  }

  if $der_cert and $pfx_cert {
    fail('Parameter Error: pfx_cert and der_cert are mutually-exclusive')
  }

  if $der_cert {
    $sslmodule = ['x509', '-inform', 'DER']
    $in_cert   = $der_cert
  } else {
    $sslmodule  = ['pkcs12']
    $in_cert    = $pfx_cert
  }

  if $in_pass {
    $passin_opt = ['-nokeys', '-passin', 'env:CERTIFICATE_PASSIN']
    $passin_env = ["CERTIFICATE_PASSIN=${in_pass}"]
  } else {
    $passin_opt = []
    $passin_env = []
  }

  if $ensure == 'present' {
    $cmd = ['openssl'] + $sslmodule + ['-in', $in_cert, '-out', $pem_cert] + $passin_opt

    if $dynamic {
      $exec_params = {
        refreshonly => true,
        subscribe   => $resources,
      }
    } else {
      $exec_params = { creates => $pem_cert, }
    }

    # lint:ignore:exec_idempotency
    exec { "Export ${in_cert} to ${pem_cert}":
      command     => $cmd,
      environment => $passin_env,
      path        => $facts['path'],
      *           => $exec_params,
    }
    # lint:endignore
  } else {
    file { $pem_cert:
      ensure => absent,
    }
  }
}
