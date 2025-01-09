include openssl
openssl::export::pkcs12 { 'export.pkcs12':
  ensure  => 'present',
  basedir => '/tmp',
  pkey    => '/tmp/private.key',
  cert    => '/tmp/cert.crt',
}
