include openssl
openssl::export::pem_key { 'key-UUID':
  ensure   => present,
  pfx_cert => '/tmp/export.pkcs12.p12',
  pem_key  => '/tmp/key.pem',
}
