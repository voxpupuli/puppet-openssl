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
    desc "The authentication algorithm: 'rsa', 'dsa or ec'"
    newvalues :rsa, :dsa, :ec
    defaultto :rsa

    munge(&:to_sym)
  end

  newparam(:size) do
    desc 'The key size'
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
end
