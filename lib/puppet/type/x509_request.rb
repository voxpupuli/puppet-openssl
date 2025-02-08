# frozen_string_literal: true

require 'pathname'
Puppet::Type.newtype(:x509_request) do
  desc 'An x509 certificate signing request'

  ensurable

  newparam(:path, namevar: true) do
    desc 'The path of the certificate signing request'
    validate do |value|
      path = Pathname.new(value)
      raise ArgumentError, "Path must be absolute: #{path}" unless path.absolute?
    end
  end

  newparam(:force, boolean: true) do
    desc 'Whether to replace the certificate if the private key mismatches'
    newvalues(:true, :false)
    defaultto false
  end

  newparam(:password) do
    desc 'The optional password for the private key'
  end

  newparam(:template) do
    desc 'The template to use'
    defaultto do
      path = Pathname.new(@resource[:path])
      "#{path.dirname}/#{path.basename(path.extname)}.cnf"
    end
    validate do |value|
      path = Pathname.new(value)
      raise ArgumentError, "Path must be absolute: #{path}" unless path.absolute?
    end
  end

  newparam(:private_key) do
    desc 'The path of the private key'
    defaultto do
      path = Pathname.new(@resource[:path])
      "#{path.dirname}/#{path.basename(path.extname)}.key"
    end
    validate do |value|
      path = Pathname.new(value)
      raise ArgumentError, "Path must be absolute: #{path}" unless path.absolute?
    end
  end

  newparam(:encrypted, boolean: true) do
    desc 'Whether to generate the key unencrypted. This is needed by some applications like OpenLDAP'
    newvalues(:true, :false)
    defaultto true
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

  autorequire(:x509_cert) do
    path = Pathname.new(self[:private_key])
    "#{path.dirname}/#{path.basename(path.extname)}"
  end

  autorequire(:file) do
    self[:private_key]
  end

  autorequire(:file) do
    Pathname.new(self[:path]).parent.to_s
  end

  def refresh
    provider.create
  end
end
