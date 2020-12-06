require 'pathname'
Puppet::Type.newtype(:dhparam) do
  desc 'A Diffie Helman parameter file'

  ensurable

  newparam(:path, namevar: true) do
    validate do |value|
      path = Pathname.new(value)
      unless path.absolute?
        raise ArgumentError, "Path must be absolute: #{path}"
      end
    end
  end

  newparam(:size) do
    desc 'The key size'
    newvalues %r{\d+}
    defaultto 512
    validate do |value|
      size = value.to_i
      if size <= 0 || value.to_s != size.to_s
        raise ArgumentError, "Size must be a positive integer: #{value.inspect}"
      end
    end
  end

  newparam(:fastmode) do
    desc 'Enable fast mode'
    defaultto false
    validate do |value|
      if !value.is_a?(TrueClass) && !value.is_a?(FalseClass)
        raise ArgumentError, "Fastmode must be a boolean: #{value.inspect} #{value.class}"
      end
    end
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
