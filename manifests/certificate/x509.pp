# == Definition: openssl::certificate::x509
#
# Creates a certificate, key and CSR according to datas provided.
#
# === Parameters
#  [*ensure*]         ensure wether certif and its config are present or not
#  [*country*]        certificate countryName
#  [*state*]          certificate stateOrProvinceName
#  [*locality*]       certificate localityName
#  [*commonname*]     certificate CommonName
#  [*altnames*]       certificate subjectAltName.
#                     Can be an array or a single string.
#  [*organization*]   certificate organizationName
#  [*unit*]           certificate organizationalUnitName
#  [*email*]          certificate emailAddress
#  [*days*]           certificate validity
#  [*base_dir*]       where cnf, crt, csr and key should be placed.
#                     Directory must exist
#  [*owner*]          cnf, crt, csr and key owner. User must exist
#  [*group*]          cnf, crt, csr and key group. Group must exist
#  [*key_owner*]      key owner. User must exist. defaults to $owner
#  [*key_group*]      key group. Group must exist. defaults to $group
#  [*key_mode*]       key group.
#  [*password*]       private key password. undef means no passphrase
#                     will be used to encrypt private key.
#  [*force*]          whether to override certificate and request
#                     if private key changes
#  [*cnf_tpl*]        Specify an other template to generate ".cnf" file.
#  [*cnf_dir*]        where cnf should be placed.
#                     Directory must exist, defaults to $base_dir.
#  [*crt_dir*]        where crt should be placed.
#                     Directory must exist, defaults to $base_dir.
#  [*csr_dir*]        where csr should be placed.
#                     Directory must exist, defaults to $base_dir.
#  [*key_dir*]        where key should be placed.
#                     Directory must exist, defaults to $base_dir.
#  [*cnf*]            override cnf path entirely.
#                     Directory must exist, defaults to $cnf_dir/$title.cnf
#  [*crt*]            override crt path entirely.
#                     Directory must exist, defaults to $crt_dir/$title.crt
#  [*csr*]            override csr path entirely.
#                     Directory must exist, defaults to $csr_dir/$title.csr
#  [*key*]            override key path entirely.
#                     Directory must exist, defaults to $key_dir/$title.key
#
# === Example
#
#   openssl::certificate::x509 { 'foo.bar':
#     ensure       => present,
#     country      => 'CH',
#     organization => 'Example.com',
#     commonname   => $fqdn,
#     base_dir     => '/var/www/ssl',
#     owner        => 'www-data',
#   }
#
# This will create files "foo.bar.cnf", "foo.bar.crt", "foo.bar.key"
# and "foo.bar.csr" in /var/www/ssl/.
# All files will belong to user "www-data".
#
# Those files can be used as is for apache, openldap and so on.
#
# If you wish to ensure a key is read-only to a process:
# set $key_group to match the group of the process,
# and set $key_mode to '0640'.
#
# === Requires
#
#   - `puppetlabs/stdlib`
#
define openssl::certificate::x509(
  String                         $country,
  String                         $organization,
  String                         $commonname,
  Enum['present', 'absent']      $ensure = present,
  Optional[String]               $state = undef,
  Optional[String]               $locality = undef,
  Optional[String]               $unit = undef,
  Array                          $altnames = [],
  Optional[String]               $email = undef,
  Integer                        $days = 365,
  Stdlib::Absolutepath           $base_dir = '/etc/ssl/certs',
  Optional[Stdlib::Absolutepath] $cnf_dir = undef,
  Optional[Stdlib::Absolutepath] $crt_dir = undef,
  Optional[Stdlib::Absolutepath] $csr_dir = undef,
  Optional[Stdlib::Absolutepath] $key_dir = undef,
  Optional[Stdlib::Absolutepath] $cnf = undef,
  Optional[Stdlib::Absolutepath] $crt = undef,
  Optional[Stdlib::Absolutepath] $csr = undef,
  Optional[Stdlib::Absolutepath] $key = undef,
  Integer                        $key_size = 2048,
  String                         $owner = 'root',
  String                         $group = 'root',
  Optional[String]               $key_owner = undef,
  Optional[String]               $key_group = undef,
  String                         $key_mode = '0600',
  Optional[String]               $password = undef,
  Boolean                        $force = true,
  String                         $cnf_tpl = 'openssl/cert.cnf.erb',
  ) {

  $_key_owner = pick($key_owner, $owner)
  $_key_group = pick($key_group, $group)
  $_cnf_dir = pick($cnf_dir, $base_dir)
  $_csr_dir = pick($csr_dir, $base_dir)
  $_crt_dir = pick($crt_dir, $base_dir)
  $_key_dir = pick($key_dir, $base_dir)
  $_cnf = pick($cnf, "${_cnf_dir}/${name}.cnf")
  $_crt = pick($crt, "${_crt_dir}/${name}.crt")
  $_csr = pick($csr, "${_csr_dir}/${name}.csr")
  $_key = pick($key, "${_key_dir}/${name}.key")

  if !empty($altnames) {
    $req_ext = true
  } else {
    $req_ext = false
  }

  file { $_cnf:
    ensure  => $ensure,
    owner   => $owner,
    group   => $group,
    content => template($cnf_tpl),
  }

  ssl_pkey { $_key:
    ensure   => $ensure,
    password => $password,
    size     => $key_size,
  }

  x509_cert { $_crt:
    ensure      => $ensure,
    template    => $_cnf,
    private_key => $_key,
    days        => $days,
    password    => $password,
    req_ext     => $req_ext,
    force       => $force,
    require     => File[$_cnf],
  }

  x509_request { $_csr:
    ensure      => $ensure,
    template    => $_cnf,
    private_key => $_key,
    password    => $password,
    force       => $force,
    require     => File[$_cnf],
    subscribe   => File[$_cnf],
    notify      => X509_cert[$_crt],
  }

  # Set owner of all files
  file {
    $_key:
      ensure  => $ensure,
      owner   => $_key_owner,
      group   => $_key_group,
      mode    => $key_mode,
      require => Ssl_pkey[$_key];

    $_crt:
      ensure  => $ensure,
      owner   => $owner,
      group   => $group,
      require => X509_cert[$_crt];

    $_csr:
      ensure  => $ensure,
      owner   => $owner,
      group   => $group,
      require => X509_request[$_csr];
  }
}
