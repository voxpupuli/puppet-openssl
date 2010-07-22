/*

== Class: openssl::genx509

Only install a single script.
This class is required by openssl::certificate::x509 definition

*/
class openssl::genx509 {
  file {"/usr/local/sbin/generate-x509-cert.sh":
    ensure => present,
    owner  => root,
    group  => root,
    mode   => 0755,
    source => "puppet:///modules/openssl/generate-x509-cert.sh",
  }
}
