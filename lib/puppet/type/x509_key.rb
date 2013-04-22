require 'pathname'
Puppet::Type.newtype(:x509_key) do
  desc 'An x509 private key'

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
end
