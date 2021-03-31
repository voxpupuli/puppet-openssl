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
    value = nil

    require 'openssl'

    # parsing the certificate
    cert = OpenSSL::X509::Certificate.new(File.read(certfile))

    # iterating over all extensions
    cert.extensions.each do |ext|
      # decoding the extension and looking into it
      data = OpenSSL::ASN1.decode_all(ext)
      data.entries.each do |access_description|
        # skip to next extension unless AIA found
        next unless access_description.entries[0].value == 'authorityInfoAccess'

        # decode AIA
        content = OpenSSL::ASN1.decode_all(access_description.entries[1].value)
        content.entries.each do |aia|
          aia.entries.each do |aia_access_description|
            if aia_access_description.entries[0].value == 'caIssuers'
              value = aia_access_description.entries[1].value
            end
          end
        end
      end
    end
    value
  end
end
