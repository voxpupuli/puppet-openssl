# frozen_string_literal: true

require 'pathname'
Puppet::Type.newtype(:ssl_pkey) do
  desc 'An SSL private key'

  ensurable

  newparam(:path, namevar: true) do
    desc 'The path to the key'
    validate do |value|
      path = Pathname.new(value)
      raise ArgumentError, "Path must be absolute: #{path}" unless path.absolute?
    end
  end

  newparam(:authentication) do
    desc 'The authentication algorithm'
    newvalues :rsa, :ec
    defaultto :rsa

    munge(&:to_sym)
  end

  newparam(:size) do
    desc 'The key size for RSA keys'
    newvalues %r{\d+}
    defaultto 2048

    munge(&:to_i)
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
