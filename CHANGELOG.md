# Changelog

All notable changes to this project will be documented in this file.
Each new release typically also includes the latest modulesync defaults.
These should not affect the functionality of the module.

## [v3.1.1](https://github.com/voxpupuli/puppet-openssl/tree/v3.1.1) (2024-07-11)

[Full Changelog](https://github.com/voxpupuli/puppet-openssl/compare/v3.1.0...v3.1.1)

**Fixed bugs:**

- r10k generate types fails [\#197](https://github.com/voxpupuli/puppet-openssl/issues/197)
- export/{pem\_cert,pem\_key,pkcs12}: `passin`, `passout`: use `shellquote()` instead of single quotation marks [\#199](https://github.com/voxpupuli/puppet-openssl/pull/199) ([pavelkovtunov](https://github.com/pavelkovtunov))
- Add missing require so that generate types works. [\#198](https://github.com/voxpupuli/puppet-openssl/pull/198) ([ncstate-daniel](https://github.com/ncstate-daniel))
- fix logic bug with extkeyusage and altnames [\#195](https://github.com/voxpupuli/puppet-openssl/pull/195) ([rtib](https://github.com/rtib))

## [v3.1.0](https://github.com/voxpupuli/puppet-openssl/tree/v3.1.0) (2024-05-02)

[Full Changelog](https://github.com/voxpupuli/puppet-openssl/compare/v3.0.0...v3.1.0)

**Implemented enhancements:**

- Improve documentation [\#183](https://github.com/voxpupuli/puppet-openssl/pull/183) ([rtib](https://github.com/rtib))

**Fixed bugs:**

- Release 3.0.0 broken [\#178](https://github.com/voxpupuli/puppet-openssl/issues/178)
- Fix handling of request extensions in x509\_cert type and provider [\#180](https://github.com/voxpupuli/puppet-openssl/pull/180) ([rtib](https://github.com/rtib))
- Fix config template issues and add some improvements [\#179](https://github.com/voxpupuli/puppet-openssl/pull/179) ([rtib](https://github.com/rtib))

## [v3.0.0](https://github.com/voxpupuli/puppet-openssl/tree/v3.0.0) (2024-03-19)

[Full Changelog](https://github.com/voxpupuli/puppet-openssl/compare/v2.0.1...v3.0.0)

**Breaking changes:**

- Require puppetlabs-stdlib 9.x [\#165](https://github.com/voxpupuli/puppet-openssl/pull/165) ([smortex](https://github.com/smortex))
- moves config management to config provider for X509 certificate; moves certificate from v1 to v3 [\#164](https://github.com/voxpupuli/puppet-openssl/pull/164) ([zilchms](https://github.com/zilchms))
- Drop Puppet 6 support [\#163](https://github.com/voxpupuli/puppet-openssl/pull/163) ([zilchms](https://github.com/zilchms))
- add puppet7 support; namespace all functions [\#162](https://github.com/voxpupuli/puppet-openssl/pull/162) ([zilchms](https://github.com/zilchms))
- enable single config file support [\#159](https://github.com/voxpupuli/puppet-openssl/pull/159) ([zilchms](https://github.com/zilchms))
- Enlarge key size based on new security requirement [\#143](https://github.com/voxpupuli/puppet-openssl/pull/143) ([Vampouille](https://github.com/Vampouille))

**Implemented enhancements:**

- move from own regex to stdlib ip type adding ipv6 support for SANS [\#166](https://github.com/voxpupuli/puppet-openssl/pull/166) ([zilchms](https://github.com/zilchms))
- refactor x509\_request to be consistent with x509\_cert provider [\#155](https://github.com/voxpupuli/puppet-openssl/pull/155) ([zilchms](https://github.com/zilchms))
- add ability to certificate provider to get signed against a CA cert [\#153](https://github.com/voxpupuli/puppet-openssl/pull/153) ([zilchms](https://github.com/zilchms))
- Allow cert\_file to download certificates via https [\#146](https://github.com/voxpupuli/puppet-openssl/pull/146) ([rtib](https://github.com/rtib))

**Fixed bugs:**

- templates/cert.cnf.erb should use @, not $ [\#149](https://github.com/voxpupuli/puppet-openssl/pull/149) ([mikerenfro](https://github.com/mikerenfro))
- fix openssl\_version on EL8 OpenSSL 1.1.1k [\#135](https://github.com/voxpupuli/puppet-openssl/pull/135) ([fraenki](https://github.com/fraenki))

**Closed issues:**

- Move on from puppet6 [\#161](https://github.com/voxpupuli/puppet-openssl/issues/161)
- Bug/Maintenance in/for configuration templates [\#158](https://github.com/voxpupuli/puppet-openssl/issues/158)

**Merged pull requests:**

- Remove legacy top-scope syntax [\#171](https://github.com/voxpupuli/puppet-openssl/pull/171) ([smortex](https://github.com/smortex))
- Use puppet-strings comments [\#151](https://github.com/voxpupuli/puppet-openssl/pull/151) ([smortex](https://github.com/smortex))

## [v2.0.1](https://github.com/voxpupuli/puppet-openssl/tree/v2.0.1) (2022-03-09)

[Full Changelog](https://github.com/voxpupuli/puppet-openssl/compare/2.0.0...v2.0.1)

**Fixed bugs:**

- incorrect behaviour of cert\_aia\_caissuers if file does not exists [\#126](https://github.com/voxpupuli/puppet-openssl/pull/126) ([rtib](https://github.com/rtib))

**Closed issues:**

- openssl\_version fact resolves to nil [\#134](https://github.com/voxpupuli/puppet-openssl/issues/134)

**Merged pull requests:**

- Rework README.md/add correct badges [\#141](https://github.com/voxpupuli/puppet-openssl/pull/141) ([bastelfreak](https://github.com/bastelfreak))
- Tests: Use modern rspec syntax [\#140](https://github.com/voxpupuli/puppet-openssl/pull/140) ([bastelfreak](https://github.com/bastelfreak))
- puppet-lint: fix current violations [\#138](https://github.com/voxpupuli/puppet-openssl/pull/138) ([bastelfreak](https://github.com/bastelfreak))
- init: fix Puppet Strings docs syntax [\#137](https://github.com/voxpupuli/puppet-openssl/pull/137) ([kenyon](https://github.com/kenyon))
- puppet-lint: fix top\_scope\_facts warnings [\#133](https://github.com/voxpupuli/puppet-openssl/pull/133) ([bastelfreak](https://github.com/bastelfreak))
- allow stdlib 8.0.0 [\#130](https://github.com/voxpupuli/puppet-openssl/pull/130) ([kenyon](https://github.com/kenyon))

## [2.0.0](https://github.com/voxpupuli/puppet-openssl/tree/2.0.0) (2021-05-04)

[Full Changelog](https://github.com/voxpupuli/puppet-openssl/compare/1.14.0...2.0.0)

**Breaking changes:**

- update pdk, dependencies and requirements [\#125](https://github.com/voxpupuli/puppet-openssl/pull/125) ([rtib](https://github.com/rtib))

**Implemented enhancements:**

- add cert\_file type [\#124](https://github.com/voxpupuli/puppet-openssl/pull/124) ([rtib](https://github.com/rtib))
- Allow DER certificates to be converted to PEM format [\#122](https://github.com/voxpupuli/puppet-openssl/pull/122) ([n3mawashi](https://github.com/n3mawashi))
- function to extract caIssuers URL from authorityInfoAccess extension [\#120](https://github.com/voxpupuli/puppet-openssl/pull/120) ([rtib](https://github.com/rtib))
- Allow openssl\_version regex to match more FIPS versions [\#112](https://github.com/voxpupuli/puppet-openssl/pull/112) ([runejuhl](https://github.com/runejuhl))

**Closed issues:**

- Parameters for openssl.cnf [\#41](https://github.com/voxpupuli/puppet-openssl/issues/41)

**Merged pull requests:**

- readd dependencies to class to generate configs [\#119](https://github.com/voxpupuli/puppet-openssl/pull/119) ([trefzer](https://github.com/trefzer))
- add autorequire for file path to all defined types [\#117](https://github.com/voxpupuli/puppet-openssl/pull/117) ([trefzer](https://github.com/trefzer))
- add class to generate configs [\#116](https://github.com/voxpupuli/puppet-openssl/pull/116) ([trefzer](https://github.com/trefzer))
- add support for OpenBSD [\#115](https://github.com/voxpupuli/puppet-openssl/pull/115) ([trefzer](https://github.com/trefzer))
- fix spec test, failing Time.now is not executed in same second [\#114](https://github.com/voxpupuli/puppet-openssl/pull/114) ([trefzer](https://github.com/trefzer))
- allow for numeric owner and group IDs for file resources [\#113](https://github.com/voxpupuli/puppet-openssl/pull/113) ([kenyon](https://github.com/kenyon))

## [1.14.0](https://github.com/voxpupuli/puppet-openssl/tree/1.14.0) (2020-03-05)

[Full Changelog](https://github.com/voxpupuli/puppet-openssl/compare/1.13.0...1.14.0)

**Breaking changes:**

- in\_pass, out\_pass and chaincert params to Optional\[String\] [\#111](https://github.com/voxpupuli/puppet-openssl/pull/111) ([raphink](https://github.com/raphink))

**Implemented enhancements:**

- Update stdlib dependency [\#109](https://github.com/voxpupuli/puppet-openssl/pull/109) ([treydock](https://github.com/treydock))

**Closed issues:**

- 1.13.0 introduced bug in `openssl::export::pkcs12` [\#110](https://github.com/voxpupuli/puppet-openssl/issues/110)

## [1.13.0](https://github.com/voxpupuli/puppet-openssl/tree/1.13.0) (2020-01-07)

[Full Changelog](https://github.com/voxpupuli/puppet-openssl/compare/1.12.0...1.13.0)

**Implemented enhancements:**

- Rubocop [\#108](https://github.com/voxpupuli/puppet-openssl/pull/108) ([raphink](https://github.com/raphink))
- Port specs to rspec 3 [\#107](https://github.com/voxpupuli/puppet-openssl/pull/107) ([raphink](https://github.com/raphink))
- Port cert\_date\_valid function to Puppet 4.x API [\#106](https://github.com/voxpupuli/puppet-openssl/pull/106) ([raphink](https://github.com/raphink))
- Convert to PDK [\#105](https://github.com/voxpupuli/puppet-openssl/pull/105) ([raphink](https://github.com/raphink))
- Manifests cleanup [\#104](https://github.com/voxpupuli/puppet-openssl/pull/104) ([raphink](https://github.com/raphink))

## [1.12.0](https://github.com/voxpupuli/puppet-openssl/tree/1.12.0) (2019-04-17)

[Full Changelog](https://github.com/voxpupuli/puppet-openssl/compare/1.11.0...1.12.0)

**Implemented enhancements:**

- Add ability to generate Elliptic Curve key pairs [\#99](https://github.com/voxpupuli/puppet-openssl/pull/99) ([fabbks](https://github.com/fabbks))

## [1.11.0](https://github.com/voxpupuli/puppet-openssl/tree/1.11.0) (2019-03-01)

[Full Changelog](https://github.com/voxpupuli/puppet-openssl/compare/1.10.0...1.11.0)

**Implemented enhancements:**

- Ability to generate x509 certificates with extKeyUsage [\#96](https://github.com/voxpupuli/puppet-openssl/pull/96) ([madchap](https://github.com/madchap))
- Add the x509\_extensions directive to support SAN in certificate [\#89](https://github.com/voxpupuli/puppet-openssl/pull/89) ([johnbillion](https://github.com/johnbillion))
- Changes to support unencrypted CSRs [\#84](https://github.com/voxpupuli/puppet-openssl/pull/84) ([WetHippie](https://github.com/WetHippie))

**Closed issues:**

- dhparam doesn't work without 'ensure' [\#90](https://github.com/voxpupuli/puppet-openssl/issues/90)
- Request for ability to create unencrypted private key [\#83](https://github.com/voxpupuli/puppet-openssl/issues/83)
- Can't add SAN records [\#44](https://github.com/voxpupuli/puppet-openssl/issues/44)

**Merged pull requests:**

- Fix spec tests [\#97](https://github.com/voxpupuli/puppet-openssl/pull/97) ([coreone](https://github.com/coreone))
- Update dhparams example in README.md [\#92](https://github.com/voxpupuli/puppet-openssl/pull/92) ([tlcowling](https://github.com/tlcowling))

## [1.10.0](https://github.com/voxpupuli/puppet-openssl/tree/1.10.0) (2017-04-18)

[Full Changelog](https://github.com/voxpupuli/puppet-openssl/compare/1.9.0...1.10.0)

**Breaking changes:**

- Make the $fastmode parameter for openssl::dhparam default to false. [\#86](https://github.com/voxpupuli/puppet-openssl/pull/86) ([rpasing](https://github.com/rpasing))
- Fastmode, Default Keysize increased, path defaults to name  [\#80](https://github.com/voxpupuli/puppet-openssl/pull/80) ([c33s](https://github.com/c33s))

**Implemented enhancements:**

- Data types [\#87](https://github.com/voxpupuli/puppet-openssl/pull/87) ([raphink](https://github.com/raphink))
- Add definitions to export PEM cert/key from PKCS12 container [\#85](https://github.com/voxpupuli/puppet-openssl/pull/85) ([michalmiddleton](https://github.com/michalmiddleton))

**Closed issues:**

- Add "fastmode" for dhparam generation [\#79](https://github.com/voxpupuli/puppet-openssl/issues/79)
- Readme for dhparam wrong? [\#78](https://github.com/voxpupuli/puppet-openssl/issues/78)

## [1.9.0](https://github.com/voxpupuli/puppet-openssl/tree/1.9.0) (2017-01-10)

[Full Changelog](https://github.com/voxpupuli/puppet-openssl/compare/1.8.2...1.9.0)

**Implemented enhancements:**

- handle refresh \(RE: \#71\) [\#75](https://github.com/voxpupuli/puppet-openssl/pull/75) ([gaima8](https://github.com/gaima8))
- Check if there are matches before returning [\#74](https://github.com/voxpupuli/puppet-openssl/pull/74) ([raphink](https://github.com/raphink))

**Closed issues:**

- x509\_request doesn't handle refresh [\#71](https://github.com/voxpupuli/puppet-openssl/issues/71)

**Merged pull requests:**

- Error: Unknown authentication type 'dsa' when setting authentication [\#72](https://github.com/voxpupuli/puppet-openssl/pull/72) ([christophelec](https://github.com/christophelec))

## [1.8.2](https://github.com/voxpupuli/puppet-openssl/tree/1.8.2) (2016-08-19)

[Full Changelog](https://github.com/voxpupuli/puppet-openssl/compare/1.8.1...1.8.2)

## [1.8.1](https://github.com/voxpupuli/puppet-openssl/tree/1.8.1) (2016-08-19)

[Full Changelog](https://github.com/voxpupuli/puppet-openssl/compare/1.8.0...1.8.1)

**Closed issues:**

- Error "failure to load inifile" resulting in failed Puppet run [\#63](https://github.com/voxpupuli/puppet-openssl/issues/63)

**Merged pull requests:**

- Use Puppet::Util::Inifile instead of Inifile [\#73](https://github.com/voxpupuli/puppet-openssl/pull/73) ([raphink](https://github.com/raphink))

## [1.8.0](https://github.com/voxpupuli/puppet-openssl/tree/1.8.0) (2016-08-18)

[Full Changelog](https://github.com/voxpupuli/puppet-openssl/compare/1.7.2...1.8.0)

**Merged pull requests:**

- Add argument key\_size to openssl::certificate::x509 [\#55](https://github.com/voxpupuli/puppet-openssl/pull/55) ([kronos-pbrideau](https://github.com/kronos-pbrideau))

## [1.7.2](https://github.com/voxpupuli/puppet-openssl/tree/1.7.2) (2016-06-29)

[Full Changelog](https://github.com/voxpupuli/puppet-openssl/compare/1.7.1...1.7.2)

**Closed issues:**

- dhparam generation fails  [\#58](https://github.com/voxpupuli/puppet-openssl/issues/58)

**Merged pull requests:**

- Fix validation of the size parameter [\#70](https://github.com/voxpupuli/puppet-openssl/pull/70) ([mmalchuk](https://github.com/mmalchuk))

## [1.7.1](https://github.com/voxpupuli/puppet-openssl/tree/1.7.1) (2016-03-30)

[Full Changelog](https://github.com/voxpupuli/puppet-openssl/compare/1.7.0...1.7.1)

**Closed issues:**

- Error: Facter: error while resolving custom fact "openssl\_version" [\#62](https://github.com/voxpupuli/puppet-openssl/issues/62)

**Merged pull requests:**

- fixes \#62 - error resolving openssl\_version on RHEL 6 [\#66](https://github.com/voxpupuli/puppet-openssl/pull/66) ([mike-es](https://github.com/mike-es))
- altnames can represent ip addresses [\#61](https://github.com/voxpupuli/puppet-openssl/pull/61) ([garrettrowell](https://github.com/garrettrowell))

## [1.7.0](https://github.com/voxpupuli/puppet-openssl/tree/1.7.0) (2016-03-18)

[Full Changelog](https://github.com/voxpupuli/puppet-openssl/compare/1.6.1...1.7.0)

**Closed issues:**

- Add openssl\_version fact [\#57](https://github.com/voxpupuli/puppet-openssl/issues/57)

**Merged pull requests:**

- Fixes \#57 [\#60](https://github.com/voxpupuli/puppet-openssl/pull/60) ([jyaworski](https://github.com/jyaworski))

## [1.6.1](https://github.com/voxpupuli/puppet-openssl/tree/1.6.1) (2016-02-22)

[Full Changelog](https://github.com/voxpupuli/puppet-openssl/compare/1.6.0...1.6.1)

**Merged pull requests:**

- Fix failure to load inifile causing Puppet agent to fail. [\#56](https://github.com/voxpupuli/puppet-openssl/pull/56) ([olavmrk](https://github.com/olavmrk))

## [1.6.0](https://github.com/voxpupuli/puppet-openssl/tree/1.6.0) (2016-02-18)

[Full Changelog](https://github.com/voxpupuli/puppet-openssl/compare/1.5.1...1.6.0)

**Implemented enhancements:**

- dhparam: add [\#53](https://github.com/voxpupuli/puppet-openssl/pull/53) ([josephholsten](https://github.com/josephholsten))
- Change cert existance logic [\#51](https://github.com/voxpupuli/puppet-openssl/pull/51) ([sorrowless](https://github.com/sorrowless))

## [1.5.1](https://github.com/voxpupuli/puppet-openssl/tree/1.5.1) (2015-11-17)

[Full Changelog](https://github.com/voxpupuli/puppet-openssl/compare/1.5.0...1.5.1)

**Implemented enhancements:**

- packages: switch to stlib ensure\_packages\(\) to play nice with other modules which install ca-certificates [\#52](https://github.com/voxpupuli/puppet-openssl/pull/52) ([josephholsten](https://github.com/josephholsten))
- Manage ca-certificates package on redhat too [\#49](https://github.com/voxpupuli/puppet-openssl/pull/49) ([edestecd](https://github.com/edestecd))

**Closed issues:**

- ca-certificates package is available in redhat also [\#47](https://github.com/voxpupuli/puppet-openssl/issues/47)

## [1.5.0](https://github.com/voxpupuli/puppet-openssl/tree/1.5.0) (2015-09-23)

[Full Changelog](https://github.com/voxpupuli/puppet-openssl/compare/1.4.0...1.5.0)

**Implemented enhancements:**

- Make it easy to customize cnf/crt/csr/key paths [\#46](https://github.com/voxpupuli/puppet-openssl/pull/46) ([robbat2](https://github.com/robbat2))

## [1.4.0](https://github.com/voxpupuli/puppet-openssl/tree/1.4.0) (2015-09-15)

[Full Changelog](https://github.com/voxpupuli/puppet-openssl/compare/1.3.10...1.4.0)

**Merged pull requests:**

- Fix san use in certificate [\#50](https://github.com/voxpupuli/puppet-openssl/pull/50) ([sorrowless](https://github.com/sorrowless))

## [1.3.10](https://github.com/voxpupuli/puppet-openssl/tree/1.3.10) (2015-08-21)

[Full Changelog](https://github.com/voxpupuli/puppet-openssl/compare/1.3.9...1.3.10)

**Closed issues:**

- No way to set desired openssl package version [\#35](https://github.com/voxpupuli/puppet-openssl/issues/35)

**Merged pull requests:**

- Allow to set package version [\#48](https://github.com/voxpupuli/puppet-openssl/pull/48) ([edestecd](https://github.com/edestecd))

## [1.3.9](https://github.com/voxpupuli/puppet-openssl/tree/1.3.9) (2015-06-26)

[Full Changelog](https://github.com/voxpupuli/puppet-openssl/compare/1.3.8...1.3.9)

## [1.3.8](https://github.com/voxpupuli/puppet-openssl/tree/1.3.8) (2015-05-28)

[Full Changelog](https://github.com/voxpupuli/puppet-openssl/compare/1.3.7...1.3.8)

## [1.3.7](https://github.com/voxpupuli/puppet-openssl/tree/1.3.7) (2015-05-26)

[Full Changelog](https://github.com/voxpupuli/puppet-openssl/compare/1.3.6...1.3.7)

## [1.3.6](https://github.com/voxpupuli/puppet-openssl/tree/1.3.6) (2015-05-26)

[Full Changelog](https://github.com/voxpupuli/puppet-openssl/compare/1.3.5...1.3.6)

**Merged pull requests:**

- Add key\_mode/group/owner parameters [\#45](https://github.com/voxpupuli/puppet-openssl/pull/45) ([robbat2](https://github.com/robbat2))

## [1.3.5](https://github.com/voxpupuli/puppet-openssl/tree/1.3.5) (2015-05-25)

[Full Changelog](https://github.com/voxpupuli/puppet-openssl/compare/1.3.4...1.3.5)

## [1.3.4](https://github.com/voxpupuli/puppet-openssl/tree/1.3.4) (2015-05-13)

[Full Changelog](https://github.com/voxpupuli/puppet-openssl/compare/1.3.3...1.3.4)

## [1.3.3](https://github.com/voxpupuli/puppet-openssl/tree/1.3.3) (2015-05-12)

[Full Changelog](https://github.com/voxpupuli/puppet-openssl/compare/1.3.2...1.3.3)

## [1.3.2](https://github.com/voxpupuli/puppet-openssl/tree/1.3.2) (2015-04-27)

[Full Changelog](https://github.com/voxpupuli/puppet-openssl/compare/1.3.1...1.3.2)

## [1.3.1](https://github.com/voxpupuli/puppet-openssl/tree/1.3.1) (2015-04-17)

[Full Changelog](https://github.com/voxpupuli/puppet-openssl/compare/1.3.0...1.3.1)

## [1.3.0](https://github.com/voxpupuli/puppet-openssl/tree/1.3.0) (2015-04-03)

[Full Changelog](https://github.com/voxpupuli/puppet-openssl/compare/1.2.8...1.3.0)

**Closed issues:**

- Google has depreciated sha1 for certs [\#36](https://github.com/voxpupuli/puppet-openssl/issues/36)

**Merged pull requests:**

- templates/cert.cnf.erb: Use sha256 instead of sha1 by default [\#43](https://github.com/voxpupuli/puppet-openssl/pull/43) ([lathiat](https://github.com/lathiat))

## [1.2.8](https://github.com/voxpupuli/puppet-openssl/tree/1.2.8) (2015-03-24)

[Full Changelog](https://github.com/voxpupuli/puppet-openssl/compare/1.2.7...1.2.8)

## [1.2.7](https://github.com/voxpupuli/puppet-openssl/tree/1.2.7) (2015-03-10)

[Full Changelog](https://github.com/voxpupuli/puppet-openssl/compare/1.2.6...1.2.7)

**Merged pull requests:**

- Remove useless ca-certificates file management [\#38](https://github.com/voxpupuli/puppet-openssl/pull/38) ([ckaenzig](https://github.com/ckaenzig))

## [1.2.6](https://github.com/voxpupuli/puppet-openssl/tree/1.2.6) (2015-02-18)

[Full Changelog](https://github.com/voxpupuli/puppet-openssl/compare/1.2.5...1.2.6)

## [1.2.5](https://github.com/voxpupuli/puppet-openssl/tree/1.2.5) (2015-01-19)

[Full Changelog](https://github.com/voxpupuli/puppet-openssl/compare/1.2.4...1.2.5)

## [1.2.4](https://github.com/voxpupuli/puppet-openssl/tree/1.2.4) (2015-01-07)

[Full Changelog](https://github.com/voxpupuli/puppet-openssl/compare/1.2.3...1.2.4)

## [1.2.3](https://github.com/voxpupuli/puppet-openssl/tree/1.2.3) (2015-01-05)

[Full Changelog](https://github.com/voxpupuli/puppet-openssl/compare/1.2.2...1.2.3)

## [1.2.2](https://github.com/voxpupuli/puppet-openssl/tree/1.2.2) (2014-12-18)

[Full Changelog](https://github.com/voxpupuli/puppet-openssl/compare/1.2.1...1.2.2)

## [1.2.1](https://github.com/voxpupuli/puppet-openssl/tree/1.2.1) (2014-12-18)

[Full Changelog](https://github.com/voxpupuli/puppet-openssl/compare/1.2.0...1.2.1)

## [1.2.0](https://github.com/voxpupuli/puppet-openssl/tree/1.2.0) (2014-12-09)

[Full Changelog](https://github.com/voxpupuli/puppet-openssl/compare/1.1.0...1.2.0)

## [1.1.0](https://github.com/voxpupuli/puppet-openssl/tree/1.1.0) (2014-11-25)

[Full Changelog](https://github.com/voxpupuli/puppet-openssl/compare/1.0.1...1.1.0)

**Closed issues:**

- Generating pkcs12 Certificate [\#33](https://github.com/voxpupuli/puppet-openssl/issues/33)

**Merged pull requests:**

- Pkcs12 modifications [\#34](https://github.com/voxpupuli/puppet-openssl/pull/34) ([cjeanneret](https://github.com/cjeanneret))

## [1.0.1](https://github.com/voxpupuli/puppet-openssl/tree/1.0.1) (2014-11-17)

[Full Changelog](https://github.com/voxpupuli/puppet-openssl/compare/1.0.0...1.0.1)

## [1.0.0](https://github.com/voxpupuli/puppet-openssl/tree/1.0.0) (2014-10-20)

[Full Changelog](https://github.com/voxpupuli/puppet-openssl/compare/0.3.2...1.0.0)

**Closed issues:**

- Improve doc to show how to generate password-free certs [\#30](https://github.com/voxpupuli/puppet-openssl/issues/30)

**Merged pull requests:**

-  Improvement in doc to show how to generate password-free certs [\#32](https://github.com/voxpupuli/puppet-openssl/pull/32) ([atxulo](https://github.com/atxulo))

## [0.3.2](https://github.com/voxpupuli/puppet-openssl/tree/0.3.2) (2014-09-23)

[Full Changelog](https://github.com/voxpupuli/puppet-openssl/compare/0.3.1...0.3.2)

## [0.3.1](https://github.com/voxpupuli/puppet-openssl/tree/0.3.1) (2014-07-04)

[Full Changelog](https://github.com/voxpupuli/puppet-openssl/compare/0.3.0...0.3.1)

**Merged pull requests:**

- Puppet 3 fixes, cleanup [\#31](https://github.com/voxpupuli/puppet-openssl/pull/31) ([foonix](https://github.com/foonix))

## [0.3.0](https://github.com/voxpupuli/puppet-openssl/tree/0.3.0) (2014-07-02)

[Full Changelog](https://github.com/voxpupuli/puppet-openssl/compare/0.2.0...0.3.0)

**Closed issues:**

- RANDFILE not correct on ubuntu 12.04.04 [\#29](https://github.com/voxpupuli/puppet-openssl/issues/29)
- Add the ability to specify the version of openssl that you want installed [\#24](https://github.com/voxpupuli/puppet-openssl/issues/24)
- Push new version to the Forge [\#22](https://github.com/voxpupuli/puppet-openssl/issues/22)
- Fix dependency issue with puppetlabs-stdlib \(version number wrong\) [\#17](https://github.com/voxpupuli/puppet-openssl/issues/17)
- creating a cert doesn't include altnames [\#13](https://github.com/voxpupuli/puppet-openssl/issues/13)

## [0.2.0](https://github.com/voxpupuli/puppet-openssl/tree/0.2.0) (2014-03-03)

[Full Changelog](https://github.com/voxpupuli/puppet-openssl/compare/735e515565a28b466165eac8fcc6d4125356b9a0...0.2.0)

**Closed issues:**

- Replace has\_variable? test with simple if @var test in templates/cert.cnf.erb  [\#16](https://github.com/voxpupuli/puppet-openssl/issues/16)
- incorrect check against undef in default template [\#15](https://github.com/voxpupuli/puppet-openssl/issues/15)
- Wrong command called [\#1](https://github.com/voxpupuli/puppet-openssl/issues/1)

**Merged pull requests:**

- Fix bug with x509\_Request not having the cnf template present [\#28](https://github.com/voxpupuli/puppet-openssl/pull/28) ([jrnt30](https://github.com/jrnt30))
- Document 'group' parameter [\#27](https://github.com/voxpupuli/puppet-openssl/pull/27) ([pataquets](https://github.com/pataquets))
- Add 'group' parameter to x509 certificate. [\#26](https://github.com/voxpupuli/puppet-openssl/pull/26) ([pataquets](https://github.com/pataquets))
- Added certificate signing request dependency on configuration template [\#25](https://github.com/voxpupuli/puppet-openssl/pull/25) ([tylerwalts](https://github.com/tylerwalts))
- Fix for issue 16 [\#21](https://github.com/voxpupuli/puppet-openssl/pull/21) ([ghost](https://github.com/ghost))
- Ignore Gemfile.lock [\#20](https://github.com/voxpupuli/puppet-openssl/pull/20) ([ghost](https://github.com/ghost))
- Deprecation warnings when running rake spec [\#19](https://github.com/voxpupuli/puppet-openssl/pull/19) ([ghost](https://github.com/ghost))
- Deprecation warning when running bundle install [\#18](https://github.com/voxpupuli/puppet-openssl/pull/18) ([ghost](https://github.com/ghost))
- Add cnf\_tpl param to openssl::certificate::x509. [\#12](https://github.com/voxpupuli/puppet-openssl/pull/12) ([Sliim](https://github.com/Sliim))
- Fix puppet-lint link in README.md [\#11](https://github.com/voxpupuli/puppet-openssl/pull/11) ([Sliim](https://github.com/Sliim))
- Update Modulefile to work with other modules requiring stdlib [\#10](https://github.com/voxpupuli/puppet-openssl/pull/10) ([LarsFronius](https://github.com/LarsFronius))
- Add x509\_cert and x509\_csr types and providers [\#9](https://github.com/voxpupuli/puppet-openssl/pull/9) ([raphink](https://github.com/raphink))
- Export pkcs12 without password [\#8](https://github.com/voxpupuli/puppet-openssl/pull/8) ([raphink](https://github.com/raphink))
- openssl: added support for various distributions. [\#5](https://github.com/voxpupuli/puppet-openssl/pull/5) ([mfournier](https://github.com/mfournier))
- openssl::export::pkcs12 - new definition. name says it all [\#3](https://github.com/voxpupuli/puppet-openssl/pull/3) ([cjeanneret](https://github.com/cjeanneret))
- openssl::certificate::x509 - corrected call to script [\#2](https://github.com/voxpupuli/puppet-openssl/pull/2) ([cjeanneret](https://github.com/cjeanneret))



\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
