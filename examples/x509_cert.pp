openssl::certificate::x509 { 'foo.example.com':
  ensure       => present,
  country      => 'CH',
  organization => 'Example.com',
  commonname   => 'foo.example.com',
  base_dir     => '/tmp',
  owner        => 'nobody',
  password     => 'mahje1Qu',
}
