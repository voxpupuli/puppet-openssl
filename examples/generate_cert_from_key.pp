include openssl

file { '/tmp/template.cnf':
  ensure  => file,
  content => epp('openssl/cert.cnf', {
      'country'           => 'de',
      'state'             => 'BW',
      'locality'          => 'undef',
      'organization'      => 'voxpupuli',
      'unit'              => 'anybody',
      'commonname'        => 'testpipeline.voxpupuli.org',
      'email'             => 'do_not_reply@voxpupuli.org',
      'default_bits'      => 4096,
      'default_md'        => 'sha256',
      'default_keyfile'   => '/tmp/private.key',
      'basicconstraints'  => ['CA:false'],
      'extendedkeyusages' => ['serverAuth'],
      'keyusages'         => ['critical'],
      'subjectaltnames'   => ['cert.voxpupuli.org', 'foo.bar.de'],
  }),
}

x509_cert { '/tmp/cert.crt':
  ensure      => present,
  private_key => '/tmp/private.key',
  template    => '/tmp/template.cnf',
}
