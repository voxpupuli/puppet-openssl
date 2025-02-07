# frozen_string_literal: true

require 'pathname'
require File.join(__dir__, '..', '..', '..', 'puppet/provider/openssl')

Puppet::Type.type(:dhparam).provide(
  :openssl,
  parent: Puppet::Provider::Openssl
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
    options.insert(1, '-dsaparam') if resource[:fastmode]

    openssl options
    set_file_perm(resource[:path], resource[:owner], resource[:group], resource[:mode])
  end

  def destroy
    Pathname.new(resource[:path]).delete
  end
end
