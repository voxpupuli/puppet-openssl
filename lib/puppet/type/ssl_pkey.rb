require 'pathname'
Puppet::Type.newtype(:ssl_pkey) do
  desc 'An SSL private key'

  ensurable

  newparam(:path, :namevar => true) do
    desc 'The path to the key'
    validate do |value|
      path = Pathname.new(value)
      unless path.absolute?
        raise ArgumentError, "Path must be absolute: #{path}"
      end
    end
  end

  newparam(:authentication) do
    desc "The authentication algorithm: 'rsa' or 'dsa'"
    newvalues :rsa, :dsa
    defaultto :rsa

    munge do |val|
      val.to_sym
    end
  end

  newparam(:size) do
    desc 'The key size'
    newvalues /\d+/
    defaultto 2048

    munge do |val|
      val.to_i
    end
  end

  newparam(:password) do
    desc 'The optional password for the key'
  end
end
