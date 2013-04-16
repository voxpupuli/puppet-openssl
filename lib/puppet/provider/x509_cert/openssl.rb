require 'pathname'
Puppet::Type.type(:x509_cert).provide(:openssl) do
  desc 'Manages certificates with OpenSSL'

  commands :openssl => 'openssl'

  def self.dirname(resource)
    resource[:path].dirname
  end

  def self.template(resource)
    resource[:template] || "#{resource[:path]}.cnf"
  end

  def exists?
    # TODO: add a "force" parameter to force recreation
    # if existing certificate does not match parameters
    Pathname.exists? "#{resource[:path]}.crt"
  end

  def create
    openssl(
      'req', '-config', "#{self.class.template(resource)}", '-new', '-x509',
      '-nodes', '-days', resource[:days],
      '-out', "#{resource[:path]}.crt",
      '-keyout', "#{resource[:path]}.key"
    )
  end

  def destroy
    Pathname.delete "#{resource[:path]}.crt"
    Pathname.delete "#{resource[:path]}.key"
  end
end
