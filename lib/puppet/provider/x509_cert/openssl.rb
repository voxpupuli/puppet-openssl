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

  def exists?
    if Pathname.new(resource[:path]).exist?
      if resource[:force] and !self.class.check_private_key(resource)
        return false
      end
      return true
    else
      return false
    end
  end

  def create
    if resource[:request]
      options = [
        'ca',
        '-create_serial',
        '-batch',
        '-in', resource[:request],
      ]
    else
      options = [
        'req',
        '-new',
        '-key', resource[:private_key],
      ]

      options << '-x509' if resource[:ca]

      if resource[:password]
        options << "-passin pass:#{resource[:password]}"
      else
        options << '-nodes'
      end
    end

    options << ['-config', resource[:template]]
    options << ['-out', resource[:path]]
    options << ['-extensions', "req_ext",] if resource[:req_ext] != :false

    if resource[:server]
      options << ['-extensions', 'ssl_server']
    elsif resource[:client]
      options << ['-extensions', 'ssl_client']
    end

    openssl(options)
  end

  def destroy
    Pathname.new(resource[:path]).delete
  end
end
