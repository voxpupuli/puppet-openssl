contain openssl
ssl_pkey { '/tmp/private.key':
  ensure => present,
}

