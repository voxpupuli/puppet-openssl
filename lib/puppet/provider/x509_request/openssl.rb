# frozen_string_literal: true

require 'pathname'
Puppet::Type.type(:x509_request).provide(:openssl) do
  desc 'Manages certificate signing requests with OpenSSL'

  commands openssl: 'openssl'

  def self.private_key(resource)
    file = File.read(resource[:private_key])
    case resource[:authentication]
    when :dsa
      if resource[:password].respond_to?(:unwrap)
        Puppet::Pops::Types::PSensitiveType::Sensitive.new(OpenSSL::PKey::DSA.new(file, resource[:password].unwrap))
      else
        OpenSSL::PKey::DSA.new(file, resource[:password])
      end
    when :rsa
      if resource[:password].respond_to?(:unwrap)
        Puppet::Pops::Types::PSensitiveType::Sensitive.new(OpenSSL::PKey::RSA.new(file, resource[:password].unwrap))
      else
        OpenSSL::PKey::RSA.new(file, resource[:password])
      end
    when :ec
      if resource[:password].respond_to?(:unwrap)
        Puppet::Pops::Types::PSensitiveType::Sensitive.new(OpenSSL::PKey::EC.new(file, resource[:password].unwrap))
      else
        OpenSSL::PKey::EC.new(file, resource[:password])
      end
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

    if resource[:password]&.respond_to?(:unwrap)
      options << ['-passin', "pass:#{resource[:password].unwrap}"]
    elsif resource[:password]
      options << ['-passin', "pass:#{resource[:password]}"]
    end
    options << ['-nodes'] unless resource[:encrypted]

    openssl options
  end

  def destroy
    Pathname.new(resource[:path]).delete
  end
end
