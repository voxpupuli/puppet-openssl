require 'pathname'
require File.join(File.dirname(__FILE__), '..', '..', '..', 'puppet/provider/openssl')
Puppet::Type.type(:x509_request).provide(
  :openssl,
  parent: Puppet::Provider::Openssl,
) do
  desc 'Manages certificate signing requests with OpenSSL'

  commands openssl: 'openssl'

  def self.private_key(resource)
    file = File.read(resource[:private_key])
    if resource[:authentication] == :dsa
      OpenSSL::PKey::DSA.new(file, resource[:password])
    elsif resource[:authentication] == :rsa
      OpenSSL::PKey::RSA.new(file, resource[:password])
    elsif resource[:authentication] == :ec
      OpenSSL::PKey::EC.new(file, resource[:password])
    else
      raise Puppet::Error,
            "Unknown authentication type '#{resource[:authentication]}'"
    end
  end

  def self.check_private_key(resource)
    request = OpenSSL::X509::Request.new(File.read(resource[:path]))
    priv = private_key(resource)
    request.verify(priv)
  end

  def exists?
    if Pathname.new(resource[:path]).exist?
      if resource[:force] && !self.class.check_private_key(resource)
        return false
      end
      true
    else
      false
    end
  end

  def create
    cmd_args = [
      'req', '-new',
      '-key', resource[:private_key],
      '-config', resource[:template],
      '-out', resource[:path]
    ]

    if resource[:password]
      cmd_args.push('-passin')
      cmd_args.push("pass:#{resource[:password]}")
    end

    unless resource[:encrypted]
      cmd_args.push('-nodes')
    end

    openssl(*cmd_args)
    set_file_perm(resource[:path], resource[:owner], resource[:group], resource[:mode])
  end

  def destroy
    Pathname.new(resource[:path]).delete
  end
end
