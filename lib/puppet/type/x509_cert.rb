Puppet::Type.newtype(:x509_cert) do
  desc 'An x509 certificate'

  ensurable

  newparam(:path, :namevar => true) do
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
  end

  newparam(:owner) do
  end
end
