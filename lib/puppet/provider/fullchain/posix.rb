require 'pp'
require 'common'
require 'openssl'

Puppet::Type.type(:fullchain).provide :posix do
  confine feature: :posix

  def exists?
    return false unless Pathname.new(resource[:path]).exist?

    # load the existing chain
    store = OpenSSL::X509::Store.new
    store.add_file(resource[:path])

    # parse the top certificate from chain file
    cert = OpenSSL::X509::Certificate.new(File.read(resource[:path]))

    # verify the top certificate against the chain
    store.verify(cert)
  end

  def create
    basecert = OpenSSL::X509::Certificate.new(File.read(resource[:certificate]))
    debug "Base certificate parsed as #{basecert.pretty_inspect}"

    fullchain = chain(basecert)
    File.open(resource[:path], 'wt') do |fullchain_file|
      fullchain.each do |chain_element|
        fullchain_file.write(chain_element.to_pem)
      end
    end
  end

  def destroy
    Pathname.new(resource[:path]).delete
  end

  private

  def chain(cert)
    chain = []
    chain.push(cert)
    while cert.issuer != cert.subject
      issuerurl = issuer_from_ext(cert)
      raise "Certificate #{cert.subject} has no caIssuer in its authorityInfoAccess extension." if issuerurl.nil?

      cert = remotecert(issuerurl)
      raise "Failed to get issuer certificate from #{issueurl}" if cert.nil?

      chain.push(cert)
    end
    chain
  rescue => details
    debug "Chain incomplete. Iteration aborted due to: #{details}"
    chain
  end
end
