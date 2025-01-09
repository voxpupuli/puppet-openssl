openssl::certificate::x509 { 'sample_x509':
  ensure       => present,
  base_dir     => '/tmp',
  key_size     => 1024, #entropy in CI is limited
  organization => 'voxpupuli',
}

-> openssl::export::pkcs12 { 'export':
  ensure  => 'present',
  basedir => '/tmp',
  pkey    => '/tmp/sample_x509.key',
  cert    => '/tmp/sample_x509.crt',
}

-> openssl::export::pem_key { 'key-UUID':
  ensure   => present,
  pfx_cert => '/tmp/export.p12',
  pem_key  => '/tmp/key.pem',
}
