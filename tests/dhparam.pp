dhparam { '/etc/ssl/certs/dhparam.pem':
  ensure => 'present',
  size   => 4096,
}
