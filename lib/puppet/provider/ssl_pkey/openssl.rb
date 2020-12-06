# frozen_string_literal: true

require 'pathname'
require 'openssl'
require File.join(File.dirname(__FILE__), '..', '..', '..', 'puppet/provider/openssl')
Puppet::Type.type(:ssl_pkey).provide(
  :openssl,
  parent: Puppet::Provider::Openssl,
) do
  desc 'Manages private keys with OpenSSL'

  def self.dirname(resource)
    resource[:path].dirname
  end

  def self.generate_key(resource)
    case resource[:authentication]
    when :rsa
      OpenSSL::PKey::RSA.new(resource[:size])
    when :ec
      OpenSSL::PKey::EC.generate(resource[:curve])
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
    set_file_perm(resource[:path], resource[:owner], resource[:group], resource[:mode])
  end

  def destroy
    Pathname.new(resource[:path]).delete
  end
end
