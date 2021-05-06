# frozen_string_literal: true

# @summary Extrating the caIssuers entry from Authority Information Access extension of X509 certificate
#
# Extract a X509 certificate for x509v3 extensions, search for Authority Information Access extension and return the
# contents caIssuers access method.
# For details see [rfc5280#section-4.2.2](https://tools.ietf.org/html/rfc5280#section-4.2.2).
#
# Parameter: path to ssl certificate
#
Puppet::Functions.create_function(:cert_aia_caissuers) do
  # @param certfile Path to the certificate to inspect
  #
  # @return contents of the caIssuers access method of authorityInfoAccess extension, or nil if not found
  #
  dispatch :ca_issuers do
    param 'String', :certfile
  end

  def ca_issuers(certfile)
    require 'openssl'
    require 'common'

    # parsing the certificate
    cert = OpenSSL::X509::Certificate.new(File.read(certfile))
    issuer_from_ext(cert)
  rescue => details
    warn "Function cert_aia_caissuers failed to evaluate on #{certfile}. Caused by #{details}"
    nil
  end
end
