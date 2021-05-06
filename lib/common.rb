require 'openssl'
require 'pp'

def issuer_from_ext(cert)
  value = nil
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

def remotecert(url)
  cert = nil
  Puppet.runtime[:http].get(URI(url)) do |response|
    if response.success?
      response.read_body do |data|
        cert = OpenSSL::X509::Certificate.new(data)
        debug "Certificate from #{url} parsed as #{cert.pretty_inspect}"
      end
    else
      warn "Failed to get certificate from #{url}: #{response.code} - #{response.reason}"
    end
  end
  cert
end
