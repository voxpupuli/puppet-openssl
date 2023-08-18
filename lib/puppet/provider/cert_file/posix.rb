# frozen_string_literal: true

require 'pp'

Puppet::Type.type(:cert_file).provide :posix do
  desc 'POSIX provider for certificate files'

  confine feature: :posix

  def exists?
    return false unless Pathname.new(resource[:path]).exist?

    debug "Checking file format #{resource[:path]}"
    localcert_file = File.read(resource[:path])
    return false unless cert_format?(localcert_file, resource[:format])

    localcert = OpenSSL::X509::Certificate.new(localcert_file)
    debug "File parsed as #{localcert.pretty_inspect}"
    localcert == remotecert
  end

  def create
    case resource[:format]
    when :pem
      File.write(resource[:path], remotecert.to_pem)
    when :der
      File.binwrite(resource[:path], remotecert.to_der)
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
    Puppet.runtime[:http].get(URI(resource[:source]), options: { include_system_store: true }) do |response|
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

  def cert_format?(blob, format)
    OpenSSL::X509::Certificate.new(blob)
    (format == :pem) == (blob[0..9] == '-----BEGIN')
  rescue StandardError
    false
  end
end
