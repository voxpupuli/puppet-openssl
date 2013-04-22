require 'pathname'
Puppet::Type.type(:x509_key).provide(:openssl) do
  desc 'Manages private keys with OpenSSL'

  commands :openssl => 'openssl'

  def self.dirname(resource)
    resource[:path].dirname
  end

  def exists?
    Pathname.new(resource[:path]).exist?
  end

  def create
    if resource[:authentication] == :dsa
      dsaparam = Tempfile.new(['dsaparam', '.pem'])
      openssl(
        'dsaparam',
        '-out', dsaparam.path, resource[:size]
      )
      openssl(
        'gendsa', '-des3',
        '-out', resource[:path], dsaparam.path
      )
      dsaparam.close
    elsif resource[:authentication] == :rsa
      openssl(
        'genrsa', '-des3',
        '-out', resource[:path], resource[:size]
      )
    else
      raise Puppet::Error,
            "Unknown authentication type '#{resource[:authentication]}'"
    end
  end

  def destroy
    Pathname.new(resource[:path]).delete
  end
end
