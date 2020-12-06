require 'spec_helper'

describe 'openssl::dhparam' do
  let(:title) { '/etc/ssl/dhparam.pem' }

  context 'when passing non absolute path' do
    let(:params) do
      {
        path: 'foo',
      }
    end

    it 'fails' do
      expect {
        is_expected.to contain_file('/etc/ssl/dhparam.pem')
      }.to raise_error(%r{got ['barz'|String]})
    end
  end
  context 'when passing wrong value for ensure' do
    let(:params) do
      {
        path: '/etc/ssl/dhparam.pem',
        ensure: 'foo',
      }
    end

    it 'fails' do
      expect {
        is_expected.to contain_file('/etc/ssl/dhparam.pem')
      }.to raise_error(Puppet::Error, %r{got 'foo'})
    end
  end
  context 'when passing non positive size' do
    let(:params) do
      {
        path: '/etc/ssl/dhparam.pem',
        size: -1,
      }
    end

    it 'fails' do
      expect {
        is_expected.to contain_file('/etc/ssl/dhparam.pem')
      }.to raise_error(Puppet::Error, %r{got Integer})
    end
  end
  context 'when passing wrong type for user' do
    let(:params) do
      {
        path: '/etc/ssl/dhparam.pem',
        owner: true,
      }
    end

    it 'fails' do
      expect {
        is_expected.to contain_file('/etc/ssl/dhparam.pem')
      }.to raise_error(Puppet::Error, %r{got Boolean})
    end
  end
  context 'when passing wrong type for group' do
    let(:params) do
      {
        path: '/etc/ssl/dhparam.pem',
        group: true,
      }
    end

    it 'fails' do
      expect {
        is_expected.to contain_file('/etc/ssl/dhparam.pem')
      }.to raise_error(Puppet::Error, %r{got Boolean})
    end
  end
  context 'when passing wrong type for mode' do
    let(:params) do
      {
        path: '/etc/ssl/dhparam.pem',
        mode: true,
      }
    end

    it 'fails' do
      expect {
        is_expected.to contain_file('/etc/ssl/dhparam.pem')
      }.to raise_error(Puppet::Error, %r{got Boolean})
    end
  end
  context 'when using defaults' do
    let(:params) do
      {
        path: '/etc/ssl/dhparam.pem',
      }
    end

    it {
      is_expected.to contain_dhparam('/etc/ssl/dhparam.pem').with(
        ensure: 'present',
        size: 2048,
        owner: 'root',
        group: 'root',
        mode: '0644',
      )
    }
  end

  context 'when using size' do
    let(:params) do
      {
        path: '/etc/ssl/dhparam.pem',
        size: 2048,
      }
    end

    it {
      is_expected.to contain_dhparam('/etc/ssl/dhparam.pem').with(
        ensure: 'present',
        size: 2048,
        owner: 'root',
        group: 'root',
        mode: '0644',
      )
    }
  end

  context 'when passing all parameters' do
    let(:params) do
      {
        path: '/etc/ssl/dhparam.pem',
        owner: 'www-data',
        group: 'adm',
        mode: '0640',
        size: 2048,
      }
    end

    it {
      is_expected.to contain_dhparam('/etc/ssl/dhparam.pem').with(
        ensure: 'present',
        size: 2048,
        owner: 'www-data',
        group: 'adm',
        mode: '0640',
      )
    }
  end
  context 'when absent' do
    let(:params) do
      {
        path: '/etc/ssl/dhparam.pem',
        ensure: 'absent',
      }
    end

    it {
      is_expected.to contain_dhparam('/etc/ssl/dhparam.pem').with(
        ensure: 'absent',
      )
    }
  end
end
