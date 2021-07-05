# frozen_string_literal: true

require 'pathname'
require File.join(__dir__, '..', '..', '..', 'puppet/provider/openssl')
Puppet::Type.type(:x509_cert).provide(
  :openssl,
  parent: Puppet::Provider::Openssl,
) do
  desc 'Manages certificates with OpenSSL'

  commands openssl: 'openssl'

  def self.private_key(resource)
    file = File.read(resource[:private_key])
    OpenSSL::PKey.read(file, resource[:password])
  end

  def self.check_private_key(resource)
    cert = OpenSSL::X509::Certificate.new(File.read(resource[:path]))
    priv = private_key(resource)
    cert.check_private_key(priv)
  end

  def self.old_cert_is_equal(resource)
    cert = OpenSSL::X509::Certificate.new(File.read(resource[:path]))

    alt_name = ''
    cert.extensions.each do |ext|
      alt_name = ext.value if ext.oid == 'subjectAltName'
    end

    cdata = {}
    cert.subject.to_s.split('/').each do |name|
      k, v = name.split('=')
      cdata[k] = v
    end

    require 'puppet/util/inifile'
    ini_file = Puppet::Util::IniConfig::PhysicalFile.new(resource[:template])
    if (req_ext = ini_file.get_section('req_ext'))
      if (value = req_ext['subjectAltName']) && (value.delete(' ').gsub(%r{^"|"$}, '') != alt_name.delete(' ').gsub(%r{^"|"$}, '').gsub('IPAddress', 'IP'))
        return false
      end
    elsif (req_dn = ini_file.get_section('req_distinguished_name'))
      if (value = req_dn['commonName']) && (value != cdata['CN'])
        return false
      end
    end
    true
  end

  def exists?
    if Pathname.new(resource[:path]).exist?
      return false if resource[:force] && !self.class.check_private_key(resource)
      return false unless self.class.old_cert_is_equal(resource)

      true
    else
      false
    end
  end

  def create
    env = {}

    if resource[:csr]
      options = [
        'x509',
        '-req',
        '-days', resource[:days],
        '-in', resource[:csr],
        '-out', resource[:path]
      ]
      if resource[:ca]
        options += ['-extfile', resource[:template]]
        options += ['-CAcreateserial']
        options += ['-CA', resource[:ca]]
        options += ['-CAkey', resource[:cakey]]
      else
        options += ['-signkey', resource[:private_key]]
        if resource[:req_ext]
          options += [
            '-extensions', 'v3_req',
            '-extfile', resource[:template]
          ]
        end
      end
    else
      options = [
        'req',
        '-config', resource[:template],
        '-new', '-x509',
        '-days', resource[:days],
        '-key', resource[:private_key],
        '-out', resource[:path]
      ]
    end

    password = resource[:cakey_password] || resource[:password]

    if password
      options += ['-passin', 'env:CERTIFICATE_PASSIN']
      env['CERTIFICATE_PASSIN'] = password
    end
    options += ['-extensions', 'v3_req'] if resource[:req_ext]

    # openssl(options) doesn't work because it's impossible to pass an env
    # https://github.com/puppetlabs/puppet/issues/9493
    execute([command('openssl')] + options, { failonfail: true, combine: true, custom_environment: env })
    set_file_perm(resource[:path], resource[:owner], resource[:group], resource[:mode])
  end

  def destroy
    Pathname.new(resource[:path]).delete
  end
end
