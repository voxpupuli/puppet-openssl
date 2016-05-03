# OpenSSL Puppet Module

[![Puppet Forge Version](http://img.shields.io/puppetforge/v/camptocamp/openssl.svg)](https://forge.puppetlabs.com/camptocamp/openssl)
[![Puppet Forge Downloads](http://img.shields.io/puppetforge/dt/camptocamp/openssl.svg)](https://forge.puppetlabs.com/camptocamp/openssl)
[![Build Status](https://img.shields.io/travis/camptocamp/puppet-openssl/master.svg)](https://travis-ci.org/camptocamp/puppet-openssl)
[![Puppet Forge Endorsement](https://img.shields.io/puppetforge/e/camptocamp/openssl.svg)](https://forge.puppetlabs.com/camptocamp/openssl)
[![Gemnasium](https://img.shields.io/gemnasium/camptocamp/puppet-openssl.svg)](https://gemnasium.com/camptocamp/puppet-openssl)
[![By Camptocamp](https://img.shields.io/badge/by-camptocamp-fb7047.svg)](http://www.camptocamp.com)

**This module manages OpenSSL.**

## Class openssl

Make sure openssl is installed:

```puppet
include ::openssl
```

Specify openssl and ca-certificates package versions:

```puppet
class { '::openssl':
  package_ensure         => latest,
  ca_certificates_ensure => latest,
}
```

Create certificates (see the x509 defined type):

```puppet
class { '::openssl::certificates':
  x509_certs => { '/path/to/certificate.crt' => { ensure      => 'present',
                                                  password    => 'j(D$',
                                                  template    => '/other/path/to/template.cnf',
                                                  private_key => '/there/is/my/private.key',
                                                  days        => 4536,
                                                  force       => false,},
                  '/a/other/certificate.crt' => { ensure      => 'present', },
                }
}
```

Specify openssl and compat package

```puppet
class { '::openssl':
  package_name  => ['openssl', 'openssl-compat', ],
}
```

## Types and providers

This module provides three types and associated providers to manage SSL keys and certificates.

In every case, not providing the password (or setting it to _undef_, which is the default) means that __the private key won't be encrypted__ with any symmetric cipher so __it is completely unprotected__.

### dhparam

This type allows to generate Diffie Hellman parameters.

Simple usage:

```puppet
dhparam { '/path/to/dhparam.pem': }
```

Advanced options:

```puppet
dhparam { '/path/to/dhparam.pem':
  size => 2048,
}
```

### ssl\_pkey

This type allows to generate SSL private keys.

Simple usage:

```puppet
ssl_pkey { '/path/to/private.key': }
```

Advanced options:

```puppet
ssl_pkey { '/path/to/private.key':
  ensure   => 'present',
  password => 'j(D$',
}
```

### x509\_cert

This type allows to generate SSL certificates from a private key. You need to deploy a `template` file (`templates/cert.cnf.erb` is an example).

Simple usage:

```puppet
x509_cert { '/path/to/certificate.crt': }
```

Advanced options:

```puppet
x509_cert { '/path/to/certificate.crt':
  ensure      => 'present',
  password    => 'j(D$',
  template    => '/other/path/to/template.cnf',
  private_key => '/there/is/my/private.key',
  days        => 4536,
  force       => false,
  subscribe   => '/other/path/to/template.cnf',
}
```

### x509\_request

This type allows to generate SSL certificate signing requests from a private key. You need to deploy a `template` file (`templates/cert.cnf.erb` is an example).

Simple usage:

```puppet
x509_request { '/path/to/request.csr': }
```

Advanced options:

```puppet
x509_request { '/path/to/request.csr':
  ensure      => 'present',
  password    => 'j(D$',
  template    => '/other/path/to/template.cnf',
  private_key => '/there/is/my/private.key',
  force       => false,
  subscribe   => '/other/path/to/template.cnf',
}
```

## Definitions

### openssl::certificate::x509

This definition is a wrapper around the `ssl_pkey`, `x509_cert` and `x509_request` types. It generates a certificate template, then generates the private key, certificate and certificate signing request and sets the owner of the files.

Simple usage:

```puppet
openssl::certificate::x509 { 'foo':
  country      => 'CH',
  organization => 'Example.com',
  commonname   => $fqdn,
}
```

Advanced options:

```puppet
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
```

### openssl::export::pkcs12

This definition generates a pkcs12 file:

```puppet
openssl::export::pkcs12 { 'foo':
  ensure   => 'present',
  basedir  => '/path/to/dir',
  pkey     => '/here/is/my/private.key',
  cert     => '/there/is/the/cert.crt',
  in_pass  => 'my_pkey_password',
  out_pass => 'my_pkcs12_password',
}
```

### openssl::dhparam

This definition creates a dhparam PEM file:


Simple usage:

```puppet
openssl::dhparam { '/path/to/dhparam.pem': }
```

which is equivalent to:

```puppet
openssl::dhparam { '/path/to/dhparam.pem':
  ensure => 'present',
  size   => 512,
  owner  => 'root',
  group  => 'root',
  mode   => '0644',
}
```

Advanced usage:

```puppet
openssl::dhparam { '/path/to/dhparam.pem':
  ensure => 'present',
  size   => 2048,
  owner  => 'www-data',
  group  => 'adm',
  mode   => '0640',
}
```

## Contributing

Please report bugs and feature request using [GitHub issue
tracker](https://github.com/camptocamp/puppet-openssl/issues).

For pull requests, it is very much appreciated to check your Puppet manifest
with [puppet-lint](https://github.com/rodjek/puppet-lint) to follow the recommended Puppet style guidelines from the
[Puppet Labs style guide](http://docs.puppetlabs.com/guides/style_guide.html).
