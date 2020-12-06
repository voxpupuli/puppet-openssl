require 'pathname'
Puppet::Type.newtype(:x509_cert) do
  desc 'An x509 certificate'

  ensurable

  newparam(:path, namevar: true) do
    desc 'The path to the certificate'
    validate do |value|
      path = Pathname.new(value)
      unless path.absolute?
        raise ArgumentError, "Path must be absolute: #{path}"
      end
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
      unless path.absolute?
        raise ArgumentError, "Path must be absolute: #{path}"
      end
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

  newparam(:req_ext, boolean: true) do
    desc 'Whether adding v3 SAN from config'
    newvalues(:true, :false)
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
      unless path.absolute?
        raise ArgumentError, "Path must be absolute: #{path}"
      end
    end
  end

  newparam(:authentication) do
    desc "The authentication algorithm: 'rsa', 'dsa or ec'"
    newvalues :rsa, :dsa, :ec
    defaultto :rsa
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
