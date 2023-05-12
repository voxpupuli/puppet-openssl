# frozen_string_literal: true

# @summary
#
#   Checks SSL cetificate date validity.
#
# Parameter: path to ssl certificate
#
Puppet::Functions.create_function(:'openssl::cert_date_valid') do
  # @param certfile The certificate file to check.
  #
  # @return false if the certificate is expired or not yet valid,
  # or the number of seconds the certificate is still valid for.
  #
  dispatch :valid? do
    param 'String', :certfile
  end

  def valid?(certfile)
    require 'time'
    require 'openssl'

    content = File.read(certfile)
    cert = OpenSSL::X509::Certificate.new(content)

    raise 'No date found in certificate' if cert.not_before.nil? && cert.not_after.nil?

    now = Time.now

    if now > cert.not_after
      # certificate is expired
      false
    elsif now < cert.not_before # rubocop:disable Lint/DuplicateBranch
      # certificate is not yet valid
      false
    elsif cert.not_after <= cert.not_before # rubocop:disable Lint/DuplicateBranch
      # certificate will never be valid
      false
    else
      # return number of seconds certificate is still valid for
      (cert.not_after - now).to_i
    end
  end
end
