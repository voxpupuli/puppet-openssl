require 'pathname'
Puppet::Type.type(:x509_cert).provide(:openssl) do
  desc 'Manages certificates with OpenSSL'

  commands :openssl => 'openssl'

  def exists?
    # TODO: add a "force" parameter to force recreation
    # if existing certificate does not match parameters
    Pathname.exists? "#{resource[:path]}.crt"
  end
end
