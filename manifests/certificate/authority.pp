# == Definition: openssl::certificate::authority
#
# Creates a certificate authority and private key for signing certificates.
#
# === Parameters
#  [*ensure*]         ensure wether certif and its config are present or not
#  [*country*]        certificate countryName
#  [*state*]          certificate stateOrProvinceName
#  [*locality*]       certificate localityName
#  [*common_name*]    certificate CommonName
#  [*altnames*]       certificate subjectAltName.
#                     Can be an array or a single string.
#  [*organization*]   certificate organizationName
#  [*unit*]           certificate organizationalUnitName
#  [*email*]          certificate emailAddress
#  [*days*]           certificate validity
#  [*pki_dir*]       where cnf, crt, csr and key should be placed.
#                     Directory must exist
#  [*owner*]          cnf, crt, csr and key owner. User must exist
#  [*group*]          cnf, crt, csr and key group. Group must exist
#  [*password*]       private key password. undef means no passphrase 
#                     will be used to encrypt private key.
#  [*force*]          whether to override certificate and request
#                     if private key changes
#  [*cnf_tpl*]        Specify an other template to generate ".cnf" file.
#
# === Example
#
#   openssl::certificate::authority { 'ca':
#     ensure       => present,
#     country      => 'CH',
#     organization => 'Example.com',
#     common_name  => $fqdn,
#     pki_dir      => '/var/www/ssl',
#     owner        => 'www-data',
#   }
#
# This will create files "foo.bar.cnf", "foo.bar.crt", "foo.bar.key"
# and "foo.bar.csr" in /var/www/ssl/.
# All files will belong to user "www-data".
#
# Those files can be used as is for apache, openldap and so on.
#
# === Requires
#
#   - `puppetlabs/stdlib`
#
define openssl::certificate::authority (
  $country,
  $organization,
  $common_name,
  $ensure = present,
  $state = undef,
  $locality = undef,
  $unit = undef,
  $altnames = [],
  $email = undef,
  $days = 365,
  $pki_dir = '/etc/ssl/certs',
  $owner = 'root',
  $group = 'root',
  $password = undef,
  $force = true,
  $cnf_tpl = 'openssl/openssl.cnf.erb',
  ) {

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
  validate_string($pki_dir)
  validate_string($owner)
  validate_string($group)
  validate_string($password)
  validate_bool($force)
  validate_re($ensure, '^(present|absent)$',
    "\$ensure must be either 'present' or 'absent', got '${ensure}'")
  validate_string($cnf_tpl)

  file { $pki_dir:
    ensure => directory,
    owner   => $owner,
    group   => $group,
    mode    => '0700',
  } ->
  file { "${pki_dir}/${name}.cnf":
    ensure  => $ensure,
    owner   => $owner,
    group   => $group,
    content => template($cnf_tpl),
  } ->
  file { "${pki_dir}/index.txt":
    ensure  => $ensure,
    owner   => $owner,
    group   => $group,
    mode    => '0600',
  } ->
  file { "${pki_dir}/private":
    ensure  => directory,
    owner   => $owner,
    group   => $group,
    mode    => '0700',
  } ->
  file { "${pki_dir}/certs":
    ensure  => directory,
    owner   => $owner,
    group   => $group,
    mode    => '0700',
  } ->
  file { "${pki_dir}/requests":
    ensure  => directory,
    owner   => $owner,
    group   => $group,
    mode    => '0700',
  } ->
  ssl_pkey { "${pki_dir}/private/${name}_key.key": 
    ensure => present,
  } ~>
  x509_cert { "${pki_dir}/certs/${name}_cert.crt":
    ensure      => present,
    ca          => true,
    template    => "${pki_dir}/${name}.cnf",
    private_key => "${pki_dir}/private/${name}_key.key",
    force       => $force,
    req_ext     => false,
  }

  # Set owner of all files
  file { "${pki_dir}/${name}_key.key":
    ensure  => $ensure,
    owner   => $owner,
    group   => $group,
    mode    => '0600',
    require => Ssl_pkey["${pki_dir}/private/${name}_key.key"],
  }

  file { "${pki_dir}/${name}_cert.crt":
    ensure  => $ensure,
    owner   => $owner,
    group   => $group,
    require => X509_cert["${pki_dir}/certs/${name}_cert.crt"],
  }
}
