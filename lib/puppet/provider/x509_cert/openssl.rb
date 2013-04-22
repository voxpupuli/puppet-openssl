require 'pathname'
Puppet::Type.type(:x509_cert).provide(:openssl) do
  desc 'Manages certificates with OpenSSL'

  commands :openssl => 'openssl'

  def self.dirname(resource)
    resource[:path].dirname
  end

  def exists?
    # TODO: add a "force" parameter to force recreation
    # if existing certificate does not match private key
    Pathname.new(resource[:path]).exist?
  end

  def create
    openssl(
      'req',
      '-config', resource[:template],
      '-new', '-x509',
      '-days', resource[:days],
      '-key', resource[:private_key],
      '-out', resource[:path]
    )
  end

  def destroy
    Pathname.new(resource[:path]).delete
  end
end
