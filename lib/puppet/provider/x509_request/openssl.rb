# frozen_string_literal: true

require 'pathname'
require File.join(__dir__, '..', '..', '..', 'puppet/provider/openssl')
Puppet::Type.type(:x509_request).provide(
  :openssl,
  parent: Puppet::Provider::Openssl,
) do
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
    env = {}
    options = [
      'req', '-new',
      '-key', resource[:private_key],
      '-config', resource[:template],
      '-out', resource[:path]
    ]

    if resource[:password]
      options += ['-passin', 'env:CERTIFICATE_PASSIN']
      env['CERTIFICATE_PASSIN'] = resource[:password]
    end
    options << '-nodes' unless resource[:encrypted]

    # openssl(options) doesn't work because it's impossible to pass an env
    # https://github.com/puppetlabs/puppet/issues/9493
    execute([command('openssl')] + options, { failonfail: true, combine: true, custom_environment: env })

    set_file_perm(resource[:path], resource[:owner], resource[:group], resource[:mode])
  end

  def destroy
    Pathname.new(resource[:path]).delete
  end
end
