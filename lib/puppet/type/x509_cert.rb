require 'pathname'
Puppet::Type.newtype(:x509_cert) do
  desc 'An x509 certificate'

  ensurable

  newparam(:path, :namevar => true) do
    validate do |value|
      path = Pathname.new(value)
      unless path.absolute?
        raise ArgumentError, "Path must be absolute: #{path}"
      end
    end
  end

  newparam(:country) do
  end

  newparam(:state) do
  end

  newparam(:locality) do
  end

  newparam(:commonname) do
  end

  newparam(:altnames, :array_matching => :all) do
  end

  newparam(:organisation) do
  end

  newparam(:unit) do
  end

  newparam(:email) do
  end

  newparam(:days) do
    newvalues(/\d+/)
    defaultto(3650)
  end

  newparam(:owner) do
  end
end
