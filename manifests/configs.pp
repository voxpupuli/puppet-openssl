# @summary Generates openssl.conf files using manually set defaults or defaults from openssl::config
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
#   default version 3 certificate extension basic constraints
# @param extendedkeyusages
#   default version 3 certificate extension extended key usage
# @param keyusages
#   default version 3 certificate extension key usage
# @param subjectaltnames
#   default version 3 certificate extension for alternative names
#   currently supported are IP (v4) and DNS
# @param conffiles
#   config files to generate
#
# @example basic usage
#   class { 'openssl::configs':
#     country   => 'mycountry',
#     conffiles => { '/path/to/openssl.conf' => { ensure       => 'present',
#                                                 commonname   => 'somewhere.org',
#                                                 organization => 'myorg' },
#                    '/a/other/openssl.conf' => { ensure       => 'present',
#                                                 commonname   => 'somewhere.else.org',
#                                                 organization => 'myotherorg' },
#                   }
#   }
#
class openssl::configs (
  Optional[String[1]]  $owner           = undef,
  Optional[String[1]]  $group           = undef,
  Optional[Stdlib::Filemode] $mode      = undef,
  Optional[String[1]]  $country         = undef,
  Optional[String[1]]  $state           = undef,
  Optional[String[1]]  $locality        = undef,
  Optional[String[1]]  $organization    = undef,
  Optional[String[1]]  $unit            = undef,
  Optional[String[1]]  $email           = undef,
  Optional[Integer] $default_bits       = undef,
  Optional[String[1]]  $default_md      = undef,
  Optional[String[1]]  $default_keyfile = undef,
  Optional[Array]   $basicconstraints   = undef,
  Optional[Array]   $extendedkeyusages  = undef,
  Optional[Array]   $keyusages          = undef,
  Optional[Array]   $subjectaltnames    = undef,
  Hash              $conffiles          = {},
) {
  # dependencies: ensure config file is generated before potential usage
  File<| tag=='openssl-configs' |> -> Ssl_pkey<| |>
  File<| tag=='openssl-configs' |> -> X509_cert<| |>
  File<| tag=='openssl-configs' |> -> X509_request<| |>

  $conffiles.each | String $filename, Hash $vals | {
    openssl::config { $filename:
      * => {
        owner             => $owner,
        group             => $group,
        mode              => $mode,
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
      } + $vals,
    }
  }
}
