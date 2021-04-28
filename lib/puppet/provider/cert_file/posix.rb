require 'pp'

Puppet::Type.type(:cert_file).provide :posix do
  confine feature: :posix

  def exists?
    return false unless Pathname.new(resource[:path]).exist?

    debug "Checking file format #{resource[:path]}"
    localcert_file = File.read(resource[:path])
    unless identify_cert_format(localcert_file) == resource[:format]
      debug "File format is not #{resource[:format]}"
      return false
    end
    localcert = OpenSSL::X509::Certificate.new(localcert_file)
    debug "File parsed as #{localcert.pretty_inspect}"
    localcert == remotecert
  end

  def create
    case resource[:format]
    when :pem
      File.open(resource[:path], 'wt') do |localcert_file|
        localcert_file.write(remotecert.to_pem)
      end
    when :der
      File.open(resource[:path], 'wb') do |localcert_file|
        localcert_file.write(remotecert.to_der)
      end
    else
      raise ArgumentError, 'Output format not implemented.'
    end
  end

  def destroy
    Pathname.new(resource[:path]).delete
  end

  private

  def remotecert
    cert = nil
    Puppet.runtime[:http].get(URI(resource[:source])) do |response|
      if response.success?
        response.read_body do |data|
          cert = OpenSSL::X509::Certificate.new(data)
          debug "Certificate from #{resource[:source]} parsed as #{cert.pretty_inspect}"
        end
      else
        debug "Failed to get certificate: #{response.code} - #{response.reason}"
      end
    end
    cert
  end

  def identify_cert_format(blob)
    OpenSSL::X509::Certificate.new(blob)
    return :pem if blob[0..9] == '-----BEGIN'
    :der
  rescue OpenSSL::X509::CertificateError
    :unknown
  end
end
