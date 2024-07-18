# frozen_string_literal: true

require 'pathname'
require 'openssl'
Puppet::Type.type(:ssl_pkey).provide(:openssl) do
  desc 'Manages private keys with OpenSSL'

  def self.dirname(resource)
    resource[:path].dirname
  end

  # @see man openssl genpkey
  def self.generate_key(resource)
    case resource[:authentication]
    when :dsa
      params = OpenSSL::PKey.generate_parameters('DSA', 'dsa_paramgen_bits' => resource[:size])
      OpenSSL::PKey.generate_key(params)
    when :rsa
      OpenSSL::PKey.generate_key('RSA', 'rsa_keygen_bits' => resource[:size])
    when :ec
      OpenSSL::PKey.generate_key('EC', 'ec_paramgen_curve' => resource[:curve])
    else
      raise Puppet::Error,
            "Unknown authentication type '#{resource[:authentication]}'"
    end
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
