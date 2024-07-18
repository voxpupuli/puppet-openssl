# frozen_string_literal: true

require 'pathname'
require 'openssl'
Puppet::Type.type(:ssl_pkey).provide(:openssl) do
  desc 'Manages private keys with OpenSSL'

  def self.dirname(resource)
    resource[:path].dirname
  end

  def self.generate_key(resource)
    case resource[:authentication]
    when :dsa
      OpenSSL::PKey::DSA.new(resource[:size])
    when :rsa
      OpenSSL::PKey::RSA.new(resource[:size])
    when :ec
      OpenSSL::PKey::EC.new(resource[:curve]).generate_key
    else
      raise Puppet::Error,
            "Unknown authentication type '#{resource[:authentication]}'"
    end
  end

  def self.to_pem(resource, key)
    if resource[:password]
      cipher = OpenSSL::Cipher.new('aes-256-cbc')
      key.to_pem(cipher, resource[:password])
    else
      key.to_pem
    end
  end

  def exists?
    Pathname.new(resource[:path]).exist?
  end

  def create
    key = self.class.generate_key(resource)
    pem = self.class.to_pem(resource, key)
    File.write(resource[:path], pem)
  end

  def destroy
    Pathname.new(resource[:path]).delete
  end
end
