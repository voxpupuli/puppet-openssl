require 'pathname'
Puppet::Type.type(:dhparam).provide(:openssl) do
  desc 'Manages dhparam files with OpenSSL'

  commands :openssl => 'openssl'

  def exists?
    Pathname.new(resource[:path]).exist?
  end

  def create
    options = [
      'dhparam',
      '-out', resource[:path],
      resource[:size]
    ]
    openssl options
  end

  def destroy
    Pathname.new(resource[:path]).delete
  end
end
