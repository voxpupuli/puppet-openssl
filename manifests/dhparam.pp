# == Definition: openssl::dhparam
#
# Creates Diffie Helman parameters.
#
# === Parameters
#  [*path*]    path to write DH parameters to
#  [*ensure*]  ensure whether DH paramers file is present or absent
#  [*size*]    number of bits for the parameter set
#  [*owner*]   file owner. User must exist
#  [*group*]   file group. Group must exist
#  [*mode*]    file mode.
#
# === Requires
#
#   - `puppetlabs/stdlib`
#
define openssl::dhparam(
  $path,
  $ensure = present,
  $size = 512,
  $owner = 'root',
  $group = 'root',
  $mode = '0644',
) {

  validate_absolute_path($path)
  validate_re($ensure, '^(present|absent)$',
    "\$ensure must be either 'present' or 'absent', got '${ensure}'")
  validate_integer($size, '', 1) # positive integer
  validate_string($owner)
  validate_string($group)
  validate_string($mode)

  dhparam { $path:
    ensure => $ensure,
    size   => $size,
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
