require 'puppet'
require 'pathname'
require 'puppet/type/dhparam'

# rubocop:disable RSpec/MessageSpies
provider_class = Puppet::Type.type(:dhparam).provider(:openssl)
describe 'The openssl provider for the dhparam type' do
  let(:path) { '/tmp/dhparam.pem' }
  let(:pathname) { Pathname.new(path) }
  let(:resource) { Puppet::Type::Dhparam.new(path: path) }

  context 'when using default size' do
    it 'creates dhpram with the proper options' do
      expect(provider_class).to receive(:openssl).with([
                                                         'dhparam',
                                                         '-out', '/tmp/dhparam.pem',
                                                         512
                                                       ])
      resource.provider.create
    end
  end

  context 'when setting size' do
    it 'creates dhpram with the proper options' do
      resource[:size] = 2048
      allow(provider_class).to receive(:openssl).with([
                                                        'dhparam',
                                                        '-out', '/tmp/dhparam.pem',
                                                        2048
                                                      ])
      resource.provider.create
    end
  end

  it 'deletes file' do
    expect(Pathname).to receive(:new).twice.and_return(pathname)
    expect(pathname).to receive(:delete)
    resource.provider.destroy
  end
end
