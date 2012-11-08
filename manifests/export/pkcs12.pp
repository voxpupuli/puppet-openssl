/*

=Definition: openssl::export::pkcs12
Export a key pair to PKCS12 format

Args:
  $basedir   - directory where you want the export to be done. Must exists
  $pkey      - private key
  $cert      - certificate
  $pkey_pass - private key password

*/
define openssl::export::pkcs12($ensure=present,
                               $basedir,
                               $pkey='',
                               $cert,
                               $pkey_pass) {
  case $ensure {
    present: {
      $in_opt = $pkey ? {
        ''      => '',
        default => "-inkey ${pkey}",
      }

      exec {"Export $name to ${basedir}/${name}.p12":
        command => "openssl pkcs12 -export -in ${cert} ${in_opt} -out ${basedir}/${name}.p12 -name ${name} -nodes -noiter -passout pass:${pkey_pass}",
        creates => "${basedir}/${name}.p12",
      }
    }
    absent: {
      file {"${basedir}/${name}.p12":
        ensure => absent,
      }
    }
  }
}
