require 'pathname'
Puppet::Type.type(:x509_cert).provide(:openssl) do
  desc 'Manages certificates with OpenSSL'

  commands :openssl => 'openssl'

  def self.private_key(resource)
    file = File.read(resource[:private_key])
    if resource[:authentication] == :dsa
      OpenSSL::PKey::DSA.new(file, resource[:password])
    elsif resource[:authentication] == :rsa
      OpenSSL::PKey::RSA.new(file, resource[:password])
    else
      raise Puppet::Error,
            "Unknown authentication type '#{resource[:authentication]}'"
    end
  end

  def self.check_private_key(resource)
    cert = OpenSSL::X509::Certificate.new(File.read(resource[:path]))
    priv = self.private_key(resource)
    cert.check_private_key(priv)
  end

  def self.old_cert_is_equal(resource)
    cert = OpenSSL::X509::Certificate.new(File.read(resource[:path]))

    altName = ''
    cert.extensions.each do |ext|
      altName = ext.value if ext.oid == 'subjectAltName'
    end

    cdata = {}
    cert.subject.to_s.split('/').each do |name|
      k,v = name.split('=')
        cdata[k] = v
    end

    require 'inifile'
    ini_file  = IniFile.load(resource[:template])
    ini_file.each do |section, parameter, value|
      return false if parameter == 'subjectAltName' and value.delete(' ').gsub(/^"|"$/, '') != altName.delete(' ').gsub(/^"|"$/, '').gsub('IPAddress','IP')
      return false if parameter == 'commonName' and value != cdata['CN']
    end
    return true
  end

  def exists?
    if Pathname.new(resource[:path]).exist?
      if resource[:force] and !self.class.check_private_key(resource)
        return false
      end
      if !self.class.old_cert_is_equal(resource)
        return false
      end
      return true
    else
      return false
    end
  end

  def create
    options = [
      'req',
      '-config', resource[:template],
      '-new', '-x509',
      '-days', resource[:days],
      '-key', resource[:private_key],
      '-out', resource[:path],
    ]
    options << ['-passin', "pass:#{resource[:password]}",] if resource[:password]
    options << ['-extensions', "req_ext",] if resource[:req_ext] != :false
    openssl options
  end

  def destroy
    Pathname.new(resource[:path]).delete
  end
end
