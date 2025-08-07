# Acceptable keyUsage values, defined in [RFC 5280 4.2.1.3](https://datatracker.ietf.org/doc/html/rfc5280#section-4.2.1.3)
type Openssl::Keyusage = Enum[
  'digitalSignature',
  'nonRepudiation',
  'contentCommitment',
  'keyEncipherment',
  'dataEncipherment',
  'keyAgreement',
  'keyCertSign',
  'cRLSign',
  'encipherOnly',
  'decipherOnly',
]
