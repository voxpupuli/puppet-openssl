# @summary Generates openssl.conf files using defaults
#
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
  Hash              $conffiles         = {},
) {
  # dependencies: ensure config file is generated before potential usage
  File<| tag=='openssl-configs' |> -> Ssl_pkey<| |>
  File<| tag=='openssl-configs' |> -> X509_cert<| |>
  File<| tag=='openssl-configs' |> -> X509_request<| |>

  if $conffiles {
    ensure_resources('openssl::config', $conffiles)
  }
}
