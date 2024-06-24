# @summary Export a key to PEM format
#
# @param pfx_cert
#   PFX certificate/key container
# @param pem_key
#   PEM certificate
# @param ensure
#   Whether the key file should exist
# @param in_pass
#   PFX container password
# @param out_pass
#   PEM key password
#
define openssl::export::pem_key (
  Stdlib::Absolutepath      $pfx_cert,
  Stdlib::Absolutepath      $pem_key  = $title,
  Enum['present', 'absent'] $ensure   = present,
  Optional[String]          $in_pass  = undef,
  Optional[String]          $out_pass = undef,
) {
  if $ensure == 'present' {
    $passin_opt = $in_pass ? {
      undef   => '',
      default => "-passin pass:${in_pass}",
    }

    $passout_opt = $out_pass ? {
      undef   => '-nodes',
      default => "-passout pass:${out_pass}",
    }

    $cmd = [
      'openssl pkcs12',
      "-in ${pfx_cert}",
      "-out ${pem_key}",
      '-nocerts',
      $passin_opt,
      $passout_opt,
    ]

    exec { "Export ${pfx_cert} to ${pem_key}":
      command => inline_template('<%= @cmd.join(" ") %>'),
      path    => $facts['path'],
      creates => $pem_key,
    }
  } else {
    file { $pem_key:
      ensure => absent,
    }
  }
}
