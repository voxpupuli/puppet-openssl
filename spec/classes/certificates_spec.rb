require 'spec_helper'

describe 'openssl::certificates' do
  let :params do
    {
      :x509_certs => { '/path/to/certificate.crt' => { 'ensure'      => 'present',
                                                       'password'    => 'j(D$',
                                                       'template'    => '/other/path/to/template.cnf',
                                                       'private_key' => '/there/is/my/private.key',
                                                       'days'        => 4536,
                                                       'force'       => false,},
                       '/a/other/certificate.crt' => { 'ensure'      => 'present', },
                     }
    }
  end
  it 'has certs' do
    expect {
      is_expected.to have_openssl__certificate__x509_count(2)
    }
  end
end
