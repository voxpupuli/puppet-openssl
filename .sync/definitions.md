## Definitions

### openssl::certificate::x509

This definition is a wrapper around the `ssl_pkey`, `x509_cert` and `x509_request` types. It generates a certificate template, then generates the private key, certificate and certificate signing request and sets the owner of the files.

Simple usage:

    openssl::certificate::x509 { 'foo':
      country      => 'CH',
      organization => 'Example.com',
      commonname   => $fqdn,
    }

Advanced options:

    openssl::certificate::x509 { 'foo':
      ensure       => present,
      country      => 'CH',
      organization => 'Example.com',
      commonname   => $fqdn,
      state        => 'Here',
      locality     => 'Myplace',
      unit         => 'MyUnit',
      altnames     => ['a.com', 'b.com', 'c.com'],
      email        => 'contact@foo.com',
      days         => 3456,
      base_dir     => '/var/www/ssl',
      owner        => 'www-data',
      group        => 'www-data',
      password     => 'j(D$',
      force        => false,
      cnf_tpl      => 'my_module/cert.cnf.erb'
    }

### openssl::export::pkcs12

This definition generates a pkcs12 file:

    openssl::export::pkcs12 { 'foo':
      ensure   => 'present',
      basedir  => '/path/to/dir',
      pkey     => '/here/is/my/private.key',
      cert     => '/there/is/the/cert.crt',
      in_pass  => 'my_pkey_password',
      out_pass => 'my_pkcs12_password',
    }

