# OpenSSL Puppet Module

[![Build Status](https://github.com/voxpupuli/puppet-openssl/workflows/CI/badge.svg)](https://github.com/voxpupuli/puppet-openssl/actions?query=workflow%3ACI)
[![Release](https://github.com/voxpupuli/puppet-openssl/actions/workflows/release.yml/badge.svg)](https://github.com/voxpupuli/puppet-openssl/actions/workflows/release.yml)
[![Puppet Forge](https://img.shields.io/puppetforge/v/puppet/openssl.svg)](https://forge.puppetlabs.com/puppet/openssl)
[![Puppet Forge - downloads](https://img.shields.io/puppetforge/dt/puppet/openssl.svg)](https://forge.puppetlabs.com/puppet/openssl)
[![Puppet Forge - endorsement](https://img.shields.io/puppetforge/e/puppet/openssl.svg)](https://forge.puppetlabs.com/puppet/openssl)
[![Puppet Forge - scores](https://img.shields.io/puppetforge/f/puppet/openssl.svg)](https://forge.puppetlabs.com/puppet/openssl)
[![puppetmodule.info docs](http://www.puppetmodule.info/images/badge.png)](http://www.puppetmodule.info/m/puppet-openssl)
[![AGPL v3 License](https://img.shields.io/github/license/voxpupuli/puppet-openssl.svg)](LICENSE)
[![Donated by Camptocamp](https://img.shields.io/badge/donated%20by-camptocamp-fb7047.svg)](#transfer-notice)

**This module enables Puppet to manage PKI entities such as encryption keys, signing requests and X.509 certificates.**

## Setup

Include this module in a manifest:

```puppet
contain openssl
```

By default, this will ensure OpenSSL and ca-certificates are installed.

Change the defaults to pin specific versions of the packages or keep them up to date:

```puppet
class { 'openssl':
  package_ensure         => latest,
  ca_certificates_ensure => latest,
}
```

## Usage

### Create X.509 certificates

One of the most common use-cases is to generate a private key, a certificate signing request and issue a certificate. This can be done using the [openssl::certificate::x509](REFERENCE.md#opensslcertificatex509) defined type, e.g.:

```puppet
openssl::certificate::x509 { 'hostcert':
  commonname => $facts['networking']['fqdn'],
}
```

This will create a series of resources, i.e. the private key in `/etc/ssl/certs/hostcert.key`, the certificate signing request in `/etc/ssl/certs/hostcert.csr` for the subject `DN: CN=<fqdn>` and the self-signed certificate stored in `/etc/ssl/certs/hostcert.crt`.

Note that `openssl::certificate::x509` is a defined type that provides this abstract functionality by leveraging several other resources of the module, which are also available individually for more advanced use cases.

### Create X.509 certificates from a hash

Include the [openssl::certificates](REFERENCE.md#opensslcertificates) class in a node's manifest and set the `certificates` parameter - possibly via Hiera - to a hash of certificate definitions:

```puppet
contain openssl::certificates
```

```yaml
openssl::certificates:
  hostcert:
    commonname: "%{facts['networking']['fqdn']}"
  othercert:
    commonname: "other.example.com"
    owner: www-data
```

This will generate `openssl::certificate::x509` instances for each key in the hash.

### Export a key pair to PKCS#12

Use the [openssl::export::pkcs12](REFERENCE.md#opensslexportpkcs12) defined type to generate a PKCS#12 file:

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

### Export certificate(s) to PEM/x509 format

Use the [openssl::export::pem_cert](REFERENCE.md#opensslexportpem_cert) type to export PEM certificates from a pkcs12 container:

```puppet
openssl::export::pem_cert { 'foo':
  ensure   => 'present',
  pfx_cert => '/here/is/my/certstore.pfx',
  pem_cert => '/here/is/my/cert.pem',
  in_pass  => 'my_pkcs12_password',
}
```

This definition exports PEM certificates from a DER certificate:

```puppet
openssl::export::pem_cert { 'foo':
  ensure   => 'present',
  der_cert => '/here/is/my/certstore.der',
  pem_cert => '/here/is/my/cert.pem',
}
```

### Export a key to PEM format

Use [openssl::export::pem_key](REFERENCE.md#opensslexportpem_key) to export PEM key from a pkcs12 container:

```puppet
openssl::export::pem_key { 'foo':
  ensure   => 'present',
  pfx_cert => '/here/is/my/certstore.pfx',
  pem_key  => '/here/is/my/private.key',
  in_pass  => 'my_pkcs12_password',
  out_pass => 'my_pkey_password',
}
```

### Create Diffie-Hellman parameters

The [openssl::dhparam](REFERENCE.md#openssldhparam) defined type and its back-end resource type [dhparam](REFERENCE.md#dhparam) allow to generate Diffie-Hellman parameters.

Simple usage of the Puppet type:

```puppet
dhparam { '/path/to/dhparam.pem': }
```

Advanced options:

```puppet
dhparam { '/path/to/dhparam.pem':
  size => 2048,
}
```

Or alternatively, using the defined type:

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

### Create a private key

Using the [ssl_pkey](REFERENCE.md#ssl_pkey) type allows to generate SSL private keys.

Note, that the private key is not encrypted by default[^1].

[^1]: In every case, not providing the password (or setting it to _undef_, which is the default) means that **the private key won't be encrypted** with any symmetric cipher so **it is protected by filesystem access mode only**.

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

### Create a certificate signing request

The [x509_request](REFERENCE.md#x509_request) type allows to generate SSL certificate signing requests from a private key. You need to deploy an OpenSSL configuration file containing a section for the request engine and reference it in `template`. You manage configuration files using the [openssl::config](REFERENCE.md#opensslconfig) defined type.

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

### Create a certificate

Using the [x509_cert](REFERENCE.md#x509_cert) type allows to generate SSL certificates. The default provider to this type can create self-signed certificates or use a certification authority - also deployed on the same host - to sign the certificate signing request.

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

### Get a certificate from a remote source

The [cert_file](REFERENCE.md#cert_file) type controls a file containing a serialized X.509 certificate. It accepts the source in either `PEM` or `DER` format and stores it in the desired serialization format to the file.

```puppet
cert_file { '/path/to/certs/cacert_root1.pem':
  ensure => present,
  source => 'http://www.cacert.org/certs/root_X0F.der',
  format => pem,
}
```

Attributes:

* `path` (namevar): path to the file where the certificate should be stored
* `ensure`: `present` or `absent`
* `source`: the URL the certificate should be downloaded from
* `format`: the storage format for the certificate file (`pem` or `der`)

## Functions

### Accessing the CA issuers URL from a certificate

If a certificate contains the authorityInfoAccess extension, the [openssl::cert_aia_caissuers](REFERENCE.md#opensslcert_aia_caissuers) function can be used to parse hte certificate for the authorityInfoAccess extension and return with the URL found as caIssuers, or nil if no URL or extension found. Invoking as deferred function, this can be used to download the issuer certificate:

```puppet
  file { '/ssl/certs/caissuer.crt':
    ensure => file,
    source => Deferred('openssl::cert_aia_caissuers', ["/etc/ssl/certs/${facts['networking']['fqdn']}.crt"]),
  }
```

## Contributing

Please report bugs and feature request using [GitHub issue
tracker](https://github.com/voxpupuli/puppet-openssl/issues).

For pull requests, it is very much appreciated to check your Puppet manifest
with [puppet-lint](https://github.com/puppetlabs/puppet-lint) to follow the recommended Puppet style guidelines from the
[Puppet Labs style guide](http://docs.puppetlabs.com/guides/style_guide.html).

## Transfer Notice

This plugin was originally authored by [Camptocamp](http://www.camptocamp.com).
The maintainer preferred that Puppet Community take ownership of the module for future improvement and maintenance.
Existing pull requests and issues were transferred over, please fork and continue to contribute here instead of Camptocamp.

Previously: https://github.com/camptocamp/puppet-openssl
