require 'pathname'
Puppet::Type.newtype(:ssl_pkey) do
  desc 'An SSL private key'

  ensurable

  newparam(:path, namevar: true) do
    desc 'The path to the key'
    validate do |value|
      path = Pathname.new(value)
      unless path.absolute?
        raise ArgumentError, "Path must be absolute: #{path}"
      end
    end
  end

  newparam(:authentication) do
    desc "The authentication algorithm: 'rsa', 'dsa or ec'"
    newvalues :rsa, :dsa, :ec
    defaultto :rsa

    munge do |val|
      val.to_sym
    end
  end

  newparam(:size) do
    desc 'The key size'
    newvalues %r{\d+}
    defaultto 2048

    munge do |val|
      val.to_i
    end
  end

  newparam(:curve) do
    desc 'The EC curve'
    defaultto 'secp384r1'
  end

  newparam(:password) do
    desc 'The optional password for the key'
  end

  autorequire(:file) do
    Pathname.new(self[:path]).parent.to_s
  end

  newproperty(:owner) do
    desc 'owner of the file'
    validate do |value|
      unless value =~ %r{^\w+}
        raise ArgumentError, '%s is not a valid user name' % value
      end
    end
  end

  newproperty(:group) do
    desc 'group of the file'
    validate do |value|
      unless value =~ %r{^\w+}
        raise ArgumentError, '%s is not a valid group name' % value
      end
    end
  end

  newproperty(:mode) do
    desc 'mode of the file'
    validate do |value|
      unless value =~ %r{^0\d\d\d$}
        raise ArgumentError, '%s is not a valid file mode' % value
      end
    end
  end
end
