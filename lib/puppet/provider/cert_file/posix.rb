# frozen_string_literal: true

require 'pp'
require 'common'

Puppet::Type.type(:cert_file).provide :posix do
  confine feature: :posix

  def exists?
    return false unless Pathname.new(resource[:path]).exist?

    debug "Checking file format #{resource[:path]}"
    localcert_file = File.read(resource[:path])
    return false unless cert_format?(localcert_file, resource[:format])

    localcert = OpenSSL::X509::Certificate.new(localcert_file)
    debug "File parsed as #{localcert.pretty_inspect}"
    localcert == remotecert(resource[:source])
  end

  def create
    case resource[:format]
    when :pem
      File.open(resource[:path], 'wt') do |localcert_file|
        localcert_file.write(remotecert(resource[:source]).to_pem)
      end
    when :der
      File.open(resource[:path], 'wb') do |localcert_file|
        localcert_file.write(remotecert(resource[:source]).to_der)
      end
    else
      raise ArgumentError, 'Output format not implemented.'
    end
  end

  def destroy
    Pathname.new(resource[:path]).delete
  end

  private

  def cert_format?(blob, format)
    OpenSSL::X509::Certificate.new(blob)
    (format == :pem) == (blob[0..9] == '-----BEGIN')
  rescue StandardError
    false
  end
end
