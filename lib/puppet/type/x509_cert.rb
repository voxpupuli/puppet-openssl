# frozen_string_literal: true

require 'puppet/parameter/boolean'
require 'pathname'
Puppet::Type.newtype(:x509_cert) do
  desc 'An x509 certificate'

  ensurable

  newparam(:path, namevar: true) do
    desc 'The path to the certificate'
    validate do |value|
      path = Pathname.new(value)
      raise ArgumentError, "Path must be absolute: #{path}" unless path.absolute?
    end
  end

  newparam(:private_key) do
    desc 'The path to the private key'
    defaultto do
      path = Pathname.new(@resource[:path])
      "#{path.dirname}/#{path.basename(path.extname)}.key"
    end
    validate do |value|
      path = Pathname.new(value)
      raise ArgumentError, "Path must be absolute: #{path}" unless path.absolute?
    end
  end

  newparam(:days) do
    desc 'The validity of the certificate'
    newvalues(%r{\d+})
    defaultto(3650)
  end

  newparam(:force, boolean: true) do
    desc 'Whether to replace the certificate if the private key mismatches'
    newvalues(:true, :false)
    defaultto false
  end

  newparam(:password) do
    desc 'The optional password for the private key'
  end

  newparam(:req_ext, boolean: true, parent: Puppet::Parameter::Boolean) do
    desc 'Whether adding v3 SAN from config'
    defaultto false
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

  newparam(:csr) do
    desc 'The optional certificate signing request path'
  end

  newparam(:ca) do
    desc 'The optional ca certificate filepath'
  end

  newparam(:cakey) do
    desc 'The optional ca private key filepath'
  end

  newparam(:cakey_password) do
    desc 'The optional CA key password'
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

  autorequire(:file) do
    self[:template]
  end

  autorequire(:ssl_pkey) do
    self[:private_key]
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
