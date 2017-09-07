require 'pathname'
Puppet::Type.type(:dhparam).provide(:openssl) do
  desc 'Manages dhparam files with OpenSSL'

  commands :openssl => 'openssl'

  def exists?
    Pathname.new(resource[:path]).exist?
  end

  def create
    options = [
      'dhparam',
      '-out', resource[:path],
      resource[:size]
    ]
    options.insert(1, '-dsaparam') if resource[:fastmode]

    openssl options
  end

  def destroy
    Pathname.new(resource[:path]).delete
  end

  def size
    unless valid?
      create
      return
    end
    options = [
      'dhparam',
      '-in', resource[:path],
      '-text'
    ]
    parse_openssl_dhparams_size(openssl(options))
  end

  def size=(_value)
    create
  end

  def valid?
    options = [
      'dhparam',
      '-in', resource[:path],
      '-check'
    ]

    begin
      output = openssl(options)
      return true if output =~ /DH parameters appear to be ok./
    rescue
      Puppet.notice("dhparam file '#{name}' does not appear to contain valid dhparams, regenerating...")
      return false
    end
  end

  def parse_openssl_dhparams_size(output)
      return 0 if output.nil?
      dhparamsline = output.split("\n").first
      dhparamsize = dhparamsline.match(/(\d+)/).captures[0]

      dhparamsize
  end
end
