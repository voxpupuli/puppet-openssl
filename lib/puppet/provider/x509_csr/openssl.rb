require 'pathname'
Puppet::Type.type(:x509_csr).provide(:openssl) do
  desc 'Manages certificate signing requests with OpenSSL'

  commands :openssl => 'openssl'

  def self.dirname(resource)
    resource[:path].dirname
  end

  def exists?
    Pathname.new(resource[:path]).exist?
  end

  def create
    openssl(
      'req', '-new',
      '-key', resource[:private_key],
      '-config', resource[:template],
      '-out', resource[:path]
    )
  end

  def destroy
    Pathname.new(resource[:path]).delete
  end
end

