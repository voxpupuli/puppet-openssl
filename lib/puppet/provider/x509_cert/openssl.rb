# frozen_string_literal: true

require 'pathname'
Puppet::Type.type(:x509_cert).provide(:openssl) do
  desc 'Manages certificates with OpenSSL'

  commands openssl: 'openssl'

  def self.private_key(resource)
    file = File.read(resource[:private_key])
    case resource[:authentication]
    when :dsa
      OpenSSL::PKey::DSA.new(file, resource[:password])
    when :rsa
      OpenSSL::PKey::RSA.new(file, resource[:password])
    when :ec
      OpenSSL::PKey::EC.new(file, resource[:password])
    else
      raise Puppet::Error,
            "Unknown authentication type '#{resource[:authentication]}'"
    end
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
    if resource[:csr]
      options = [
        'x509',
        '-req',
        '-days', resource[:days],
        '-in', resource[:csr],
        '-out', resource[:path]
      ]
      if resource[:ca]
        options << ['-extfile', resource[:template]]
        options << ['-CAcreateserial']
        options << ['-CA', resource[:ca]]
        options << ['-CAkey', resource[:cakey]]
      else
        options << ['-signkey', resource[:private_key]]
        if resource[:req_ext]
          options << [
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
    options << ['-passin', "pass:#{resource[:password]}"] if resource[:password]
    options << ['-extensions', 'v3_req'] if resource[:req_ext] != :false
    openssl options
  end

  def destroy
    Pathname.new(resource[:path]).delete
  end
end
