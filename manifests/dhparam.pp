# @summary Creates Diffie Helman parameters.
#
# @param path
#   path to write DH parameters to
# @param ensure
#   ensure whether DH paramers file is present or absent
# @param size
#   number of bits for the parameter set
# @param owner
#   file owner. User must exist
# @param group
#   file group. Group must exist
# @param mode
#   file mode.
# @param fastmode
#   Use "fastmode" for dhparam generation
define openssl::dhparam (
  Stdlib::Absolutepath      $path = $name,
  Enum['present', 'absent'] $ensure = present,
  Integer[1]                $size = 2048,
  Variant[String, Integer]  $owner = 'root',
  Variant[String, Integer]  $group = 'root',
  Stdlib::Filemode          $mode = '0644',
  Boolean                   $fastmode = false,
) {
  dhparam { $path:
    ensure   => $ensure,
    size     => $size,
    fastmode => $fastmode,
  }

  # Set file access
  file { $path:
    ensure  => $ensure,
    owner   => $owner,
    group   => $group,
    mode    => $mode,
    require => Dhparam[$path];
  }
}
