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
define openssl::export::pem_cert(
  Stdlib::Absolutepath      $pfx_cert,
  Stdlib::Filesource        $der_cert,
  Stdlib::Absolutepath      $pem_cert = $title,
  Enum['present', 'absent'] $ensure   = present,
  Optional[String]          $in_pass  = undef,
) {
  if $der_cert ? {
    $sslmodule = 'x509',
    $in_cert = $der_cert,
  } else {
    $sslmodule = 'pkcs12'
    $in_cert = $pfx_cert,
    $passin_opt = $in_pass ? {
      undef   => '',
      default => "-nokeys -passin pass:'${in_pass}'",
    }
    
  }
  
  if $ensure == 'present' {
    $cmd = [
      'openssl $sslmodule',
      "-in ${in_cert}",
      "-out ${pem_cert}",
      $passin_opt,
    ]

    exec {"Export ${in_cert} to ${pem_cert}":
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
