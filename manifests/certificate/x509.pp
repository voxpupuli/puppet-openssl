# @summary Creates a certificate, key and CSR according to datas provided.
#
# @param ensure
#   ensure wether certif and its config are present or not
# @param country
#   certificate countryName
# @param state
#   certificate stateOrProvinceName
# @param locality
#   certificate localityName
# @param commonname
#   certificate CommonName
# @param altnames
#   certificate subjectAltName.
#   Can be an array or a single string.
# @param extkeyusage
#   certificate extended key usage
#   Value           | Meaning
#   ----------------|-------------------------------------
#   serverAuth      | SSL/TLS Web Server Authentication.
#   clientAuth      | SL/TLS Web Client Authentication.
#   codeSigning     | Code signing.
#   emailProtection | E-mail Protection (S/MIME).
#   timeStamping    | Trusted Timestamping
#   OCSPSigning     | OCSP Signing
#   ipsecIKE        | ipsec Internet Key Exchange
#   msCodeInd       | Microsoft Individual Code Signing (authenticode)
#   msCodeCom       | Microsoft Commercial Code Signing (authenticode)
#   msCTLSign       | Microsoft Trust List Signing
#   msEFS           | Microsoft Encrypted File System
#
# @param organization
#   certificate organizationName
# @param unit
#   certificate organizationalUnitName
# @param email
#   certificate emailAddress
# @param days
#   certificate validity
# @param base_dir
#   where cnf, crt, csr and key should be placed.
#   Directory must exist
# @param key_size
#   Size of the key to generate.
# @param owner
#   cnf, crt, csr and key owner. User must exist
# @param group
#   cnf, crt, csr and key group. Group must exist
# @param key_owner
#   key owner. User must exist. defaults to $owner
# @param key_group
#   key group. Group must exist. defaults to $group
# @param key_mode
#   key group.
# @param password
#   private key password. undef means no passphrase
#   will be used to encrypt private key.
# @param force
#   whether to override certificate and request
#   if private key changes
# @param cnf_dir
#   where cnf should be placed.
#   Directory must exist, defaults to $base_dir.
# @param crt_dir
#   where crt should be placed.
#   Directory must exist, defaults to $base_dir.
# @param csr_dir
#   where csr should be placed.
#   Directory must exist, defaults to $base_dir.
# @param key_dir
#   where key should be placed.
#   Directory must exist, defaults to $base_dir.
# @param cnf
#   override cnf path entirely.
#   Directory must exist, defaults to $cnf_dir/$title.cnf
# @param crt
#   override crt path entirely.
#   Directory must exist, defaults to $crt_dir/$title.crt
# @param csr
#   override csr path entirely.
#   Directory must exist, defaults to $csr_dir/$title.csr
# @param key
#   override key path entirely.
#   Directory must exist, defaults to $key_dir/$title.key
# @param encrypted
#   Flag requesting the exported key to be unencrypted by
#   specifying the -nodes option during the CSR generation. Turning
#   off encryption is needed by some applications, such as OpenLDAP.
#   Defaults to true (key is encrypted)
# @param ca
#   Path to CA certificate for signing. Undef means no CA will be
#   provided for signing the certificate.
# @param cakey
#   Path to CA private key for signing. Undef mean no CAkey will be
#   provided.
#
# @example basic usage
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
#   This will create files "foo.bar.cnf", "foo.bar.crt", "foo.bar.key"
#   and "foo.bar.csr" in /var/www/ssl/.
#   All files will belong to user "www-data".
#
#   Those files can be used as is for apache, openldap and so on.
#
#   If you wish to ensure a key is read-only to a process:
#   set $key_group to match the group of the process,
#   and set $key_mode to '0640'.
#
define openssl::certificate::x509 (
  Enum['present', 'absent']      $ensure = present,
  Optional[String]               $country = undef,
  Optional[String]               $organization = undef,
  Optional[String]               $unit = undef,
  Optional[String]               $state = undef,
  Optional[String]               $commonname = undef,
  Optional[String]               $locality = undef,
  Array                          $altnames = [],
  Array                          $extkeyusage = [],
  Optional[String]               $email = undef,
  Integer                        $days = 365,
  Stdlib::Absolutepath           $base_dir = '/etc/ssl/certs',
  Stdlib::Absolutepath           $cnf_dir = $base_dir,
  Stdlib::Absolutepath           $crt_dir = $base_dir,
  Stdlib::Absolutepath           $csr_dir = $base_dir,
  Stdlib::Absolutepath           $key_dir = $base_dir,
  Stdlib::Absolutepath           $cnf = "${cnf_dir}/${name}.cnf",
  Stdlib::Absolutepath           $crt = "${crt_dir}/${name}.crt",
  Stdlib::Absolutepath           $csr = "${csr_dir}/${name}.csr",
  Stdlib::Absolutepath           $key = "${key_dir}/${name}.key",
  Integer                        $key_size = 3072,
  Variant[String, Integer]       $owner = 'root',
  Variant[String, Integer]       $group = 'root',
  Variant[String, Integer]       $key_owner = $owner,
  Variant[String, Integer]       $key_group = $group,
  Stdlib::Filemode               $key_mode = '0600',
  Optional[String]               $password = undef,
  Boolean                        $force = true,
  Boolean                        $encrypted = true,
  Optional[Stdlib::Absolutepath] $ca = undef,
  Optional[Stdlib::Absolutepath] $cakey = undef,
) {
  unless $country or $organization or $unit or $state or $commonname {
    fail('At least one of $country, $organization, $unit, $state or $commonname is required.')
  }
  ssl_pkey { $key:
    ensure   => $ensure,
    password => $password,
    size     => $key_size,
  }
  ~> openssl::config { $cnf:
    ensure            => $ensure,
    owner             => $owner,
    group             => $group,
    commonname        => $commonname,
    country           => $country,
    state             => $state,
    locality          => $locality,
    organization      => $organization,
    unit              => $unit,
    email             => $email,
    extendedkeyusages => $extkeyusage,
    subjectaltnames   => $altnames,
  }
  ~> x509_request { $csr:
    ensure      => $ensure,
    template    => $cnf,
    private_key => $key,
    password    => $password,
    force       => $force,
    encrypted   => $encrypted,
  }
  ~> x509_cert { $crt:
    ensure   => $ensure,
    template => $cnf,
    csr      => $csr,
    days     => $days,
    password => $password,
    req_ext  => !empty($altnames) and !empty($extkeyusage),
    force    => $force,
    ca       => $ca,
    cakey    => $cakey,
  }

  # Set owner of all files
  file {
    $key:
      ensure  => $ensure,
      owner   => $key_owner,
      group   => $key_group,
      mode    => $key_mode,
      require => Ssl_pkey[$key];

    $crt:
      ensure  => $ensure,
      owner   => $owner,
      group   => $group,
      require => X509_cert[$crt];

    $csr:
      ensure  => $ensure,
      owner   => $owner,
      group   => $group,
      require => X509_request[$csr];
  }
}
