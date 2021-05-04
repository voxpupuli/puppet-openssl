# == Definition: openssl::export::pem_cert
#
# Export certificate(s) to PEM/x509 format
#
# == Parameters
#   [*pfx_cert*]  - PFX certificate/key container
#   [*der_cert*]  - DER certificate
#   [*pem_cert*]  - PEM/x509 certificate
#   [*in_pass*]   - PFX password
#
define openssl::export::pem_cert (
  Enum['present', 'absent']       $ensure   = present,
  Stdlib::Absolutepath            $pem_cert = $title,
  Optional[Stdlib::Absolutepath]  $pfx_cert = undef,
  Optional[Stdlib::Absolutepath]  $der_cert = undef,
  Optional[String]                $in_pass  = undef,

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
    $sslmodule = 'x509'
    $in_cert   = $der_cert
    $module_opt  = '-inform DER'
  } else {
    $sslmodule  = 'pkcs12'
    $in_cert    = $pfx_cert
    $module_opt   = ''
  }

  $passin_opt = $in_pass ? {
    undef   => '',
    default => "-nokeys -passin pass:'${in_pass}'",
  }

  if $ensure == 'present' {
    $cmd = [
      "openssl ${sslmodule}",
      $module_opt,
      "-in ${in_cert}",
      "-out ${pem_cert}",
      $passin_opt,
    ]

    exec { "Export ${in_cert} to ${pem_cert}":
      command => inline_template('<%= @cmd.join(" ") %>'),
      path    => $::path,
      creates => $pem_cert,
    }
  } else {
    file { $pem_cert:
      ensure => absent,
    }
  }
}
