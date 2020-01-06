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
  Stdlib::Absolutepath      $pfx_cert,
  Stdlib::Absolutepath      $pem_key  = $title,
  Enum['present', 'absent'] $ensure   = present,
  Boolean                   $in_pass  = false,
  Boolean                   $out_pass = false,
) {
  if $ensure == 'present' {
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
  } else {
    file { $pem_key:
      ensure => absent,
    }
  }
}
