# frozen_string_literal: true

require 'pathname'
require 'openssl'
Puppet::Type.type(:ssl_pkey).provide(:openssl) do
  desc 'Manages private keys with OpenSSL'

  def self.dirname(resource)
    resource[:path].dirname
  end

  def self.generate_key(resource)
    options = {}
    case resource[:authentication]
    when :dsa
      options[:dsa_paramgen_bits] = resource[:size] if resource[:size]
    when :rsa
      options[:rsa_keygen_bits] = resource[:size] if resource[:size]
    when :ec
      options[:ec_paramgen_curve] = resource[:curve] if resource[:curve]
    end

    OpenSSL::PKey.generate_key(resource[:authentication].to_s.upcase, options)
  end

  def self.to_pem(resource, key)
    if resource[:password]
      cipher = OpenSSL::Cipher.new('des3')
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
