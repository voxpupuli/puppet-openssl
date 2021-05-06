Puppet::Type.newtype(:fullchain) do
  @doc = 'Manage a full certificate chain in a single file. For a given
  certificate file it will iteratively lookup and download the chain of
  issuer certificates up until it find the self-signed root certificate
  and store it in a single PEM formated file. It assumes, that all
  certificates are accomodating the X.509v3 authorityInfoAccess extension
  containing the caIssuer access URL. If a certificate in the chain does
  not contain the proper information, the iteration will stop, log the
  issue and write the incomplete chain.'

  ensurable

  newparam(:path, namevar: true) do
    desc 'Path to the fullchain file to manage'
    validate do |value|
      unless Puppet::Util.absolute_path?(value)
        raise Puppet::Error, _("File paths must be fully qualified, not '%{path}'") % { path: value }
      end
    end

    munge do |value|
      if value.start_with?('//') && File.basename(value) == '/'
        # This is a UNC path pointing to a share, so don't add a trailing slash
        File.expand_path(value)
      else
        File.join(File.split(File.expand_path(value)))
      end
    end
  end # newparam(:path)

  newparam(:certificate) do
    desc 'Path to the user certificate serving as origin of the chain.'
    validate do |value|
      unless Puppet::Util.absolute_path?(value)
        raise Puppet::Error, _("File paths must be fully qualified, not '%{path}'") % { path: value }
      end
    end

    munge do |value|
      if value.start_with?('//') && File.basename(value) == '/'
        # This is a UNC path pointing to a share, so don't add a trailing slash
        File.expand_path(value)
      else
        File.join(File.split(File.expand_path(value)))
      end
    end
  end # newparam(:certificate)
end
