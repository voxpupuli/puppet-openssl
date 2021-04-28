Puppet::Type.newtype(:cert_file) do
  @doc = 'Manages X.509 certificate files downloaded from a source location, saved in the specified format.'

  ensurable

  newparam(:path, namevar: true) do
    desc 'Path to the file to manage'
    validate do |value|
      unless Puppet::Util.absolute_path?(value)
        raise Puppet::Error, _("File paths must be fully qualified, not '%{path}'") % { path: value }
      end
    end

    munge do |value|
      if value.start_with?('//') && ::File.basename(value) == '/'
        # This is a UNC path pointing to a share, so don't add a trailing slash
        File.expand_path(value)
      else
        File.join(::File.split(::File.expand_path(value)))
      end
    end
  end # newparam(:path)

  newparam(:source) do
    validate do |source|
      begin
        uri = URI.parse(Puppet::Util.uri_encode(source))
      rescue => detail
        raise Puppet::Error, "Could not understand source #{source}: #{detail}", detail
      end

      raise "Cannot use relative URLs '#{source}'" unless uri.absolute?
      raise "Cannot use opaque URLs '#{source}'" unless uri.hierarchical?
      unless ['http', 'https'].include?(uri.scheme)
        raise "Cannot use URLs of type '#{uri.scheme}' as source for fileserving"
      end
    end
  end # newparam(:source)

  newparam(:format) do
    desc 'Format which the loaded certificate should be written to file.'
    newvalues(:der, :pem)
    defaultto :pem
  end # newparam(:format)
end
