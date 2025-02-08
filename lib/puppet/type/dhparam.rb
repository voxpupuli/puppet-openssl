# frozen_string_literal: true

require 'pathname'
Puppet::Type.newtype(:dhparam) do
  desc 'A Diffie Helman parameter file'

  ensurable

  newparam(:path, namevar: true) do
    desc 'The path of the file'
    validate do |value|
      path = Pathname.new(value)
      raise ArgumentError, "Path must be absolute: #{path}" unless path.absolute?
    end
  end

  newparam(:size) do
    desc 'The key size'
    newvalues %r{\d+}
    defaultto 512
    validate do |value|
      size = value.to_i
      raise ArgumentError, "Size must be a positive integer: #{value.inspect}" if size <= 0 || value.to_s != size.to_s
    end
  end

  newparam(:fastmode) do
    desc 'Enable fast mode'
    defaultto false
    validate do |value|
      raise ArgumentError, "Fastmode must be a boolean: #{value.inspect} #{value.class}" if !value.is_a?(TrueClass) && !value.is_a?(FalseClass)
    end
  end

  autorequire(:file) do
    Pathname.new(self[:path]).parent.to_s
  end

  newproperty(:owner) do
    desc 'owner of the file'
    validate do |value|
      raise ArgumentError, "#{value} is not a valid user name" unless value =~ %r{^\w+$}
    end
  end

  newproperty(:group) do
    desc 'group of the file'
    validate do |value|
      raise ArgumentError, "#{value} is not a valid group name" unless value =~ %r{^\w+$}
    end
  end

  newproperty(:mode) do
    desc 'mode of the file'
    validate do |value|
      raise ArgumentError, "#{value} is not a valid file mode" unless value =~ %r{^0\d\d\d$}
    end
  end
end
