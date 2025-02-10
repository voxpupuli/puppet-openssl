openssl::certificate::x509 { 'export_pem_from_pkcs12.example.com':
  ensure       => present,
  country      => 'CH',
  organization => 'Example.com',
  commonname   => 'export_pem_from_pkcs12.example.com',
  base_dir     => '/tmp',
  owner        => 'nobody',
  # This is just to speed up CI - use 2048 or more in production
  key_size     => 1024,
}
-> openssl::export::pkcs12 { 'export1_pem_from_pkcs12.pkcs12':
  ensure   => 'present',
  basedir  => '/tmp',
  pkey     => '/tmp/export_pem_from_pkcs12.example.com.key',
  cert     => '/tmp/export_pem_from_pkcs12.example.com.crt',
  out_pass => 'mahje1Qu',
}
-> openssl::export::pkcs12 { 'export2_pem_from_pkcs12.pkcs12':
  ensure  => 'present',
  basedir => '/tmp',
  pkey    => '/tmp/export_pem_from_pkcs12.example.com.key',
  cert    => '/tmp/export_pem_from_pkcs12.example.com.crt',
}
# import pkcs12 without pass, generate pem with pass
-> openssl::export::pem_key { '/tmp/export1_pem_from_pkcs12.pem':
  pfx_cert => '/tmp/export2_pem_from_pkcs12.pkcs12.p12',
  out_pass => 'mahje1Qu',
}
# import pkcs12 with pass, generate pem with pass
-> openssl::export::pem_key { '/tmp/export2_pem_from_pkcs12.pem':
  pfx_cert => '/tmp/export1_pem_from_pkcs12.pkcs12.p12',
  in_pass  => 'mahje1Qu',
  out_pass => 'mahje1Qu',
}
# import pkcs12 with pass, generate pem without pass
-> openssl::export::pem_key { '/tmp/export3_pem_from_pkcs12.pem':
  pfx_cert => '/tmp/export1_pem_from_pkcs12.pkcs12.p12',
  in_pass  => 'mahje1Qu',
}
# import pkcs12 without pass, generate pem without pass
-> openssl::export::pem_key { '/tmp/export4_pem_from_pkcs12.pem':
  pfx_cert => '/tmp/export2_pem_from_pkcs12.pkcs12.p12',
}
