require 'spec_helper'

describe 'openssl::certificates' do
  let :params do
    {
      x509_certs: { '/path/to/certificate.crt' => { 'ensure' => 'present',
                                                    'country'      => 'CH',
                                                    'organization' => 'Corp',
                                                    'commonname'   => 'foo',
                                                    'password'     => 'j(D$',
                                                    'days'         => 4536,
                                                    'force'        => false },
                    '/a/other/certificate.crt' => { 'ensure'       => 'present',
                                                    'country'      => 'FR',
                                                    'organization' => 'OtherCorp',
                                                    'commonname'   => 'bar' } },
    }
  end

  it 'has certs' do
    is_expected.to have_openssl__certificate__x509_resource_count(2)
  end
end
