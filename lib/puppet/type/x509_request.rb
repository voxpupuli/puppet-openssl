require 'pathname'
Puppet::Type.newtype(:x509_request) do
  desc 'An x509 certificate signing request'

  ensurable

  newparam(:path, namevar: true) do
    validate do |value|
      path = Pathname.new(value)
      unless path.absolute?
        raise ArgumentError, "Path must be absolute: #{path}"
      end
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

  newparam(:private_key) do
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

  newparam(:authentication) do
    desc "The authentication algorithm: 'rsa', 'dsa' or ec"
    newvalues :rsa, :dsa, :ec
    defaultto :rsa
  end

  newparam(:encrypted, boolean: true) do
    desc 'Whether to generate the key unencrypted. This is needed by some applications like OpenLDAP'
    newvalues(:true, :false)
    defaultto true
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
    self[:private_key]
  end

  autorequire(:file) do
    Pathname.new(self[:path]).parent.to_s
  end

  def refresh
    provider.create
  end
end
