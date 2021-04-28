require 'spec_helper'
require 'puppet/type/cert_file'
require 'pathname'

describe 'The POSIX provider for type cert_file' do
  let(:path) { '/tmp/cacert_root1.pem' }
  let(:source) { 'http://letsencrypt.org/certs/isrgrootx1.der' }
  let(:resource) { Puppet::Type::Cert_file.new(path: path, source: source) }

  it 'exists? returns false on arbitraty path' do
    allow_any_instance_of(Pathname).to receive(:exist?).and_return(false) # rubocop:disable RSpec/AnyInstance
    expect(resource.provider.exists?).to eq(false)
  end

  it 'downloads a certificate and stores it' do
    resource.provider.create
    expect(File).to exist(path)
  end

  context('default PEM format requested') do
    it 'stored file is formatted as PEM' do
      expect(File.read(path)).to include '-----BEGIN'
    end
  end
  context('DER format requested') do
    let(:path) { '/tmp/cacert_root1.der' }
    let(:resource) { Puppet::Type::Cert_file.new(path: path, source: source, format: :der) }

    it 'stored file is formatted as DER' do
      resource.provider.create
      expect(File.read(path)).not_to include '-----BEGIN'
    end
  end
end
