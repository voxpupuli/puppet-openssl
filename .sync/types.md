## Types and providers

This module provides three types and associated providers to manage SSL keys and certificates.

In every case, not providing the password (or setting it to _undef_, which is the default) means that __the private key won't be encrypted__ with any symmetric cipher so __it is completely unprotected__.

### ssl\_pkey

This type allows to generate SSL private keys.

Simple usage:

    ssl_pkey { '/path/to/private.key': }

Advanced options:

    ssl_pkey { '/path/to/private.key':
      ensure   => 'present',
      password => 'j(D$',
    }

### x509\_cert

This type allows to generate SSL certificates from a private key. You need to deploy a `template` file (`templates/cert.cnf.erb` is an example).

Simple usage:

    x509_cert { '/path/to/certificate.crt': }

Advanced options:

    x509_cert { '/path/to/certificate.crt':
      ensure      => 'present',
      password    => 'j(D$',
      template    => '/other/path/to/template.cnf',
      private_key => '/there/is/my/private.key',
      days        => 4536,
      force       => false,
    }

### x509\_request

This type allows to generate SSL certificate signing requests from a private key. You need to deploy a `template` file (`templates/cert.cnf.erb` is an example).

Simple usage:

    x509_request { '/path/to/request.csr': }

Advanced options:

    x509_request { '/path/to/request.csr':
      ensure      => 'present',
      password    => 'j(D$',
      template    => '/other/path/to/template.cnf',
      private_key => '/there/is/my/private.key',
      force       => false,
    }

