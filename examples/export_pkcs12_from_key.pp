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
