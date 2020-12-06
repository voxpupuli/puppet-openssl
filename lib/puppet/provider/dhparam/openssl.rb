require 'pathname'
require File.join(File.dirname(__FILE__), '..', '..', '..', 'puppet/provider/openssl')

Puppet::Type.type(:dhparam).provide(
  :openssl,
  parent: Puppet::Provider::Openssl,
) do
  desc 'Manages dhparam files with OpenSSL'

  commands openssl: 'openssl'

  def exists?
    Pathname.new(resource[:path]).exist?
  end

  def create
    options = [
      'dhparam',
      '-out', resource[:path],
      resource[:size]
    ]
    if resource[:fastmode]
      options.insert(1, '-dsaparam')
    end

    openssl options
    set_file_perm(resource[:path], resource[:owner], resource[:group], resource[:mode])
  end

  def destroy
    Pathname.new(resource[:path]).delete
  end
end
