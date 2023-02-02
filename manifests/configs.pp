# @summary Generates openssl.conf files using defaults
#
# @param owner
#   default owner for the configuration files
# @param group
#   default group for the configuration files
# @param mode
#   default mode for the configuration files
# @param country
#   default value for country
# @param state
#   default value for state
# @param locality
#   default value for locality
# @param organization
#   default value for organization
# @param unit
#   default value for unit
# @param email
#   default value for email
# @param default_bits
#   default key size to generate
# @param default_md
#   default message digest to use
# @param default_keyfile
#   default name for the keyfile
# @param basicconstraints
#   version 3 certificate extension basic constraints
# @param extendedkeyusages
#   version 3 certificate extension extended key usage
# @param keyusages
#   version 3 certificate extension key usage
# @param subjectaltnames
#   version 3 certificate extension for alternative names
#   currently supported are IP (v4) and DNS
# @param conffiles
#   config files to generate
#
# @example basic usage
#   class { '::openssl::configs':
#     conffiles => { '/path/to/openssl.conf' => { ensure     => 'present',
#                                                 commonname => 'somewhere.org',},
#                    '/a/other/openssl.conf' => { ensure     => 'present',
#                                                 commonname => 'somewhere.else.org' },
#                   }
#   }
#
class openssl::configs (
  String            $owner             = 'root',
  String            $group             = 'root',
  String            $mode              = '0640',
  Optional[String]  $country           = undef,
  Optional[String]  $state             = undef,
  Optional[String]  $locality          = undef,
  Optional[String]  $organization      = undef,
  Optional[String]  $unit              = undef,
  Optional[String]  $email             = undef,
  Integer           $default_bits      = 4096,
  String            $default_md        = 'sha512',
  String            $default_keyfile   = 'privkey.pem',
  Optional[Array]   $basicconstraints  = undef,
  Optional[Array]   $extendedkeyusages = undef,
  Optional[Array]   $keyusages         = undef,
  Optional[Array]   $subjectaltnames   = undef,
  Hash              $conffiles         = {},
) {
  # dpendencies: ensure config file is generated before potential usage
  File<| tag=='openssl-configs' |> -> Ssl_pkey<| |>
  File<| tag=='openssl-configs' |> -> X509_cert<| |>
  File<| tag=='openssl-configs' |> -> X509_request<| |>

  $conffiles.each |String $filename, Hash $vals| {
    file { $filename:
      ensure  => pick($vals['ensure'], 'present'),
      owner   => pick($vals['owner'], $owner),
      group   => pick($vals['group'], $group),
      mode    => pick($vals['mode'], $mode),
      content => epp('openssl/cert.cnf.epp',
        {
          country           => $country,
          state             => $state,
          locality          => $locality,
          organization      => $organization,
          unit              => $unit,
          email             => $email,
          default_bits      => $default_bits,
          default_md        => $default_md,
          default_keyfile   => $default_keyfile,
          basicconstraints  => $basicconstraints,
          extendedkeyusages => $extendedkeyusages,
          keyusages         => $keyusages,
          subjectaltnames   => $subjectaltnames,
        } + delete($vals, ['ensure', 'owner', 'group', 'mode']),
      ),
      tag     => 'openssl-configs',
    }
  }
}
