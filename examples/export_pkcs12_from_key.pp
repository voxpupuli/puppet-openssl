include openssl
openssl::certificate::x509 { 'foo.example.com':
  ensure       => present,
  country      => 'CH',
  organization => 'Example.com',
  commonname   => 'foo.example.com',
  base_dir     => '/tmp',
  owner        => 'nobody',
  password     => 'mahje1Qu',
  # This is just to speed up CI - use 2048 or more in production
  key_size     => 1024,
}
-> openssl::export::pkcs12 { 'export.pkcs12':
  ensure   => 'present',
  basedir  => '/tmp',
  pkey     => '/tmp/foo.example.com.key',
  cert     => '/tmp/foo.example.com.crt',
  in_pass  => 'mahje1Qu',
  out_pass => 'mahje1Qu',
}

# same as above, just no password for the X509
openssl::certificate::x509 { 'foo2.example.com':
  ensure       => present,
  country      => 'CH',
  organization => 'Example.com',
  commonname   => 'foo2.example.com',
  base_dir     => '/tmp',
  owner        => 'nobody',
  # This is just to speed up CI - use 2048 or more in production
  key_size     => 1024,
}
-> openssl::export::pkcs12 { 'export2.pkcs12':
  ensure   => 'present',
  basedir  => '/tmp',
  pkey     => '/tmp/foo2.example.com.key',
  cert     => '/tmp/foo2.example.com.crt',
  out_pass => 'mahje1Qu',
}
