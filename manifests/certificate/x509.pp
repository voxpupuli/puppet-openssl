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
  $country,
  $organization,
  $commonname,
  $ensure = present,
  $state = undef,
  $locality = undef,
  $unit = undef,
  $altnames = [],
  $email = undef,
  $days = 365,
  $base_dir = '/etc/ssl/certs',
  $cnf_dir = undef,
  $crt_dir = undef,
  $csr_dir = undef,
  $key_dir = undef,
  $cnf = undef,
  $crt = undef,
  $csr = undef,
  $key = undef,
  $key_size = 2048,
  $owner = 'root',
  $group = 'root',
  $key_owner = undef,
  $key_group = undef,
  $key_mode = '0600',
  $password = undef,
  $force = true,
  $cnf_tpl = 'openssl/cert.cnf.erb',
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

  validate_string($name)
  validate_string($country)
  validate_string($organization)
  validate_string($commonname)
  validate_string($ensure)
  validate_string($state)
  validate_string($locality)
  validate_string($unit)
  validate_array($altnames)
  validate_string($email)
  # lint:ignore:only_variable_string
  validate_string("${days}")
  validate_re("${days}", '^\d+$')
  # lint:endignore
  validate_string($base_dir)
  validate_absolute_path($base_dir)
  validate_string($_cnf_dir)
  validate_absolute_path($_cnf_dir)
  validate_string($_csr_dir)
  validate_absolute_path($_csr_dir)
  validate_string($_crt_dir)
  validate_absolute_path($_crt_dir)
  validate_string($_key_dir)
  validate_absolute_path($_key_dir)
  validate_string($_cnf)
  validate_absolute_path($_cnf)
  validate_string($_csr)
  validate_absolute_path($_csr)
  validate_string($_crt)
  validate_absolute_path($_crt)
  validate_string($_key)
  validate_absolute_path($_key)
  # lint:ignore:only_variable_string
  validate_string("${key_size}")
  validate_re("${key_size}", '^\d+$')
  # lint:endignore
  validate_string($owner)
  validate_string($group)
  validate_string($_key_owner)
  validate_string($_key_group)
  validate_string($key_mode)
  validate_string($password)
  validate_bool($force)
  validate_re($ensure, '^(present|absent)$',
    "\$ensure must be either 'present' or 'absent', got '${ensure}'")
  validate_string($cnf_tpl)

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
