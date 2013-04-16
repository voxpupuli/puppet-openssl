/*

== Definition: openssl::certificate::x509

Creates a certificate, key and CSR according to datas provided.

Parameters:
- *$ensure*:       ensure wether certif and its config are present or not
- *$country*:      certificate countryName
- *$state*:        certificate stateOrProvinceName
- *$locality*:     certificate localityName
- *$commonname*:   certificate CommonName
- *$altnames*:     certificate subjectAltName. Can be an array or a single string.
- *$organisation*: certificate organizationName
- *$unit*:         certificate organizationalUnitName
- *$email*:        certificate emailAddress
- *$days*:         certificate validity
- *$base_dir*:     where cnf, crt, csr and key should be placed. Directory must exist
- *$owner*:        cnf, crt, csr and key owner. User must exist

Example:
node "foo.bar" {
  openssl::certificate::x509 {"foo.bar":
    ensure       => present,
    country      => "CH",
    organisation => "Example.com",
    commonname   => $fqdn,
    base_dir     => "/var/www/ssl",
    owner        => "www-data",
  }
}

This will create files "foo.bar.cnf", "foo.bar.crt", "foo.bar.key" and "foo.bar.csr" in /var/www/ssl/.
All files will belong to user "www-data".

Those files can be used as is for apache, openldap and so on.

*/
define openssl::certificate::x509($ensure=present,
  $country,
  $state=false,
  $locality=false,
  $organisation,
  $commonname,
  $unit=false,
  $altnames=false,
  $email=false,
  $days=365,
  $base_dir='/etc/ssl/certs',
  $owner='root'
  ) {

  file {"${base_dir}/${name}.cnf":
    ensure  => $ensure,
    owner   => $owner,
    content => template('openssl/cert.cnf.erb'),
  }

  x509_cert { $base_dir:
    ensure   => $ensure,
    template => "${base_dir}/${name}.cnf",
    days     => $days,
  }

  x509_csr { "${base_dir}/${name}.csr":
    ensure      => $ensure,
    template    => "${base_dir}/${name}.cnf",
    private_key => "${base_dir}/${name}.key",
  }
}
