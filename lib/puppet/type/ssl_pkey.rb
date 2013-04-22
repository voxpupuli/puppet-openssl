require 'pathname'
Puppet::Type.newtype(:ssl_pkey) do
  desc 'An SSL private key'

  ensurable

  newparam(:path, :namevar => true) do
    validate do |value|
      path = Pathname.new(value)
      unless path.absolute?
        raise ArgumentError, "Path must be absolute: #{path}"
      end
    end
  end

  newparam(:authentication) do
    newvalues /[dr]sa/
    defaultto :rsa
  end

  newparam(:size) do
    newvalues /\d+/
    defaultto 2048
  end

  newparam(:password) do
  end
end
