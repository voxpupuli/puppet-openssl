# frozen_string_literal: true

require 'pathname'
Puppet::Type.type(:x509_request).provide(:openssl) do
  desc 'Manages certificate signing requests with OpenSSL'

  commands openssl: 'openssl'

  def self.private_key(resource)
    file = File.read(resource[:private_key])
    OpenSSL::PKey.read(file, resource[:password])
  end

  def self.check_private_key(resource)
    request = OpenSSL::X509::Request.new(File.read(resource[:path]))
    priv = private_key(resource)
    request.verify(priv)
  end

  def exists?
    if Pathname.new(resource[:path]).exist?
      return false if resource[:force] && !self.class.check_private_key(resource)

      true
    else
      false
    end
  end

  def create
    options = [
      'req', '-new',
      '-key', resource[:private_key],
      '-config', resource[:template],
      '-out', resource[:path]
    ]

    options << ['-passin', "pass:#{resource[:password]}"] if resource[:password]
    options << ['-nodes'] unless resource[:encrypted]

    openssl options
  end

  def destroy
    Pathname.new(resource[:path]).delete
  end
end
