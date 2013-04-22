require 'pathname'
require 'openssl'
Puppet::Type.type(:x509_key).provide(:openssl) do
  desc 'Manages private keys with OpenSSL'

  commands :openssl => 'openssl'

  def self.dirname(resource)
    resource[:path].dirname
  end

  def exists?
    Pathname.new(resource[:path]).exist?
  end

  def create
    k = nil
    if resource[:authentication] == :dsa
      if resource[:password]
        k = OpenSSL::PKey::DSA.new(resource[:size], resource[:password])
      else
        k = OpenSSL::PKey::DSA.new(resource[:size])
      end
    elsif resource[:authentication] == :rsa
      if resource[:password]
        k = OpenSSL::PKey::RSA.new(resource[:size], resource[:password])
      else
        k = OpenSSL::PKey::RSA.new(resource[:size])
      end
    else
      raise Puppet::Error,
            "Unknown authentication type '#{resource[:authentication]}'"
    end
    File.open(resource[:path], 'w') do |f|
      f.write(k.to_pem)
    end
  end

  def destroy
    Pathname.new(resource[:path]).delete
  end
end
