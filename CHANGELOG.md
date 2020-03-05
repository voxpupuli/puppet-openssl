# Change log

All notable changes to this project will be documented in this file. The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/) and this project adheres to [Semantic Versioning](http://semver.org).

## [1.14.0](https://github.com/Camptocamp/puppet-openssl/tree/1.14.0) (2020-03-05)

[Full Changelog](https://github.com/Camptocamp/puppet-openssl/compare/1.13.0...1.14.0)

### Changed

- in\_pass, out\_pass and chaincert params to Optional\[String\] [\#111](https://github.com/camptocamp/puppet-openssl/pull/111) ([raphink](https://github.com/raphink))

### Added

- Update stdlib dependency [\#109](https://github.com/camptocamp/puppet-openssl/pull/109) ([treydock](https://github.com/treydock))

## [1.13.0](https://github.com/Camptocamp/puppet-openssl/tree/1.13.0) (2020-01-07)

[Full Changelog](https://github.com/Camptocamp/puppet-openssl/compare/1.12.0...1.13.0)

### Added

- Rubocop [\#108](https://github.com/camptocamp/puppet-openssl/pull/108) ([raphink](https://github.com/raphink))
- Port specs to rspec 3 [\#107](https://github.com/camptocamp/puppet-openssl/pull/107) ([raphink](https://github.com/raphink))
- Port cert\_date\_valid function to Puppet 4.x API [\#106](https://github.com/camptocamp/puppet-openssl/pull/106) ([raphink](https://github.com/raphink))
- Convert to PDK [\#105](https://github.com/camptocamp/puppet-openssl/pull/105) ([raphink](https://github.com/raphink))
- Manifests cleanup [\#104](https://github.com/camptocamp/puppet-openssl/pull/104) ([raphink](https://github.com/raphink))

## [1.12.0](https://github.com/Camptocamp/puppet-openssl/tree/1.12.0) (2019-04-17)

[Full Changelog](https://github.com/Camptocamp/puppet-openssl/compare/1.11.0...1.12.0)

### Added

- Add ability to generate Elliptic Curve key pairs [\#99](https://github.com/camptocamp/puppet-openssl/pull/99) ([fabbks](https://github.com/fabbks))

## [1.11.0](https://github.com/Camptocamp/puppet-openssl/tree/1.11.0) (2019-03-01)

[Full Changelog](https://github.com/Camptocamp/puppet-openssl/compare/1.10.0...1.11.0)

### Added

- Ability to generate x509 certificates with extKeyUsage [\#96](https://github.com/camptocamp/puppet-openssl/pull/96) ([madchap](https://github.com/madchap))
- Add the x509\_extensions directive to support SAN in certificate [\#89](https://github.com/camptocamp/puppet-openssl/pull/89) ([johnbillion](https://github.com/johnbillion))
- Changes to support unencrypted CSRs [\#84](https://github.com/camptocamp/puppet-openssl/pull/84) ([WetHippie](https://github.com/WetHippie))

### Fixed

- Fix spec tests [\#97](https://github.com/camptocamp/puppet-openssl/pull/97) ([coreone](https://github.com/coreone))

## [1.10.0](https://github.com/Camptocamp/puppet-openssl/tree/1.10.0) (2017-04-18)

[Full Changelog](https://github.com/Camptocamp/puppet-openssl/compare/1.9.0...1.10.0)

### Changed

- Make the $fastmode parameter for openssl::dhparam default to false. [\#86](https://github.com/camptocamp/puppet-openssl/pull/86) ([rpasing](https://github.com/rpasing))
- Fastmode, Default Keysize increased, path defaults to name  [\#80](https://github.com/camptocamp/puppet-openssl/pull/80) ([c33s](https://github.com/c33s))

### Added

- Data types [\#87](https://github.com/camptocamp/puppet-openssl/pull/87) ([raphink](https://github.com/raphink))
- Add definitions to export PEM cert/key from PKCS12 container [\#85](https://github.com/camptocamp/puppet-openssl/pull/85) ([michalmiddleton](https://github.com/michalmiddleton))

## [1.9.0](https://github.com/Camptocamp/puppet-openssl/tree/1.9.0) (2017-01-10)

[Full Changelog](https://github.com/Camptocamp/puppet-openssl/compare/1.8.2...1.9.0)

### Added

- handle refresh \(RE: \#71\) [\#75](https://github.com/camptocamp/puppet-openssl/pull/75) ([gaima8](https://github.com/gaima8))
- Check if there are matches before returning [\#74](https://github.com/camptocamp/puppet-openssl/pull/74) ([raphink](https://github.com/raphink))

### Fixed

- Error: Unknown authentication type 'dsa' when setting authentication [\#72](https://github.com/camptocamp/puppet-openssl/pull/72) ([christophelec](https://github.com/christophelec))

## [1.8.2](https://github.com/Camptocamp/puppet-openssl/tree/1.8.2) (2016-08-19)

[Full Changelog](https://github.com/Camptocamp/puppet-openssl/compare/1.8.1...1.8.2)

## [1.8.1](https://github.com/Camptocamp/puppet-openssl/tree/1.8.1) (2016-08-19)

[Full Changelog](https://github.com/Camptocamp/puppet-openssl/compare/1.8.0...1.8.1)

### Fixed

- Use Puppet::Util::Inifile instead of Inifile [\#73](https://github.com/camptocamp/puppet-openssl/pull/73) ([raphink](https://github.com/raphink))

## [1.8.0](https://github.com/Camptocamp/puppet-openssl/tree/1.8.0) (2016-08-18)

[Full Changelog](https://github.com/Camptocamp/puppet-openssl/compare/1.7.2...1.8.0)

### Fixed

- Add argument key\_size to openssl::certificate::x509 [\#55](https://github.com/camptocamp/puppet-openssl/pull/55) ([kronos-pbrideau](https://github.com/kronos-pbrideau))

## [1.7.2](https://github.com/Camptocamp/puppet-openssl/tree/1.7.2) (2016-06-29)

[Full Changelog](https://github.com/Camptocamp/puppet-openssl/compare/1.7.1...1.7.2)

### Fixed

- Fix validation of the size parameter [\#70](https://github.com/camptocamp/puppet-openssl/pull/70) ([mmalchuk](https://github.com/mmalchuk))

## [1.7.1](https://github.com/Camptocamp/puppet-openssl/tree/1.7.1) (2016-03-30)

[Full Changelog](https://github.com/Camptocamp/puppet-openssl/compare/1.7.0...1.7.1)

### Fixed

- fixes \#62 - error resolving openssl\_version on RHEL 6 [\#66](https://github.com/camptocamp/puppet-openssl/pull/66) ([mike-es](https://github.com/mike-es))
- altnames can represent ip addresses [\#61](https://github.com/camptocamp/puppet-openssl/pull/61) ([garrettrowell](https://github.com/garrettrowell))

## [1.7.0](https://github.com/Camptocamp/puppet-openssl/tree/1.7.0) (2016-03-18)

[Full Changelog](https://github.com/Camptocamp/puppet-openssl/compare/1.6.1...1.7.0)

### Fixed

- Fixes \#57 [\#60](https://github.com/camptocamp/puppet-openssl/pull/60) ([jyaworski](https://github.com/jyaworski))

## [1.6.1](https://github.com/Camptocamp/puppet-openssl/tree/1.6.1) (2016-02-22)

[Full Changelog](https://github.com/Camptocamp/puppet-openssl/compare/1.6.0...1.6.1)

### Fixed

- Fix failure to load inifile causing Puppet agent to fail. [\#56](https://github.com/camptocamp/puppet-openssl/pull/56) ([olavmrk](https://github.com/olavmrk))

## [1.6.0](https://github.com/Camptocamp/puppet-openssl/tree/1.6.0) (2016-02-18)

[Full Changelog](https://github.com/Camptocamp/puppet-openssl/compare/1.5.1...1.6.0)

### Added

- dhparam: add [\#53](https://github.com/camptocamp/puppet-openssl/pull/53) ([josephholsten](https://github.com/josephholsten))
- Change cert existance logic [\#51](https://github.com/camptocamp/puppet-openssl/pull/51) ([sorrowless](https://github.com/sorrowless))

## [1.5.1](https://github.com/Camptocamp/puppet-openssl/tree/1.5.1) (2015-11-17)

[Full Changelog](https://github.com/Camptocamp/puppet-openssl/compare/1.5.0...1.5.1)

### Added

- packages: switch to stlib ensure\_packages\(\) to play nice with other modules which install ca-certificates [\#52](https://github.com/camptocamp/puppet-openssl/pull/52) ([josephholsten](https://github.com/josephholsten))
- Manage ca-certificates package on redhat too [\#49](https://github.com/camptocamp/puppet-openssl/pull/49) ([edestecd](https://github.com/edestecd))

## [1.5.0](https://github.com/Camptocamp/puppet-openssl/tree/1.5.0) (2015-09-23)

[Full Changelog](https://github.com/Camptocamp/puppet-openssl/compare/1.4.0...1.5.0)

### Added

- Make it easy to customize cnf/crt/csr/key paths [\#46](https://github.com/camptocamp/puppet-openssl/pull/46) ([robbat2](https://github.com/robbat2))

## [1.4.0](https://github.com/Camptocamp/puppet-openssl/tree/1.4.0) (2015-09-15)

[Full Changelog](https://github.com/Camptocamp/puppet-openssl/compare/1.3.10...1.4.0)

### Fixed

- Fix san use in certificate [\#50](https://github.com/camptocamp/puppet-openssl/pull/50) ([sorrowless](https://github.com/sorrowless))

## [1.3.10](https://github.com/Camptocamp/puppet-openssl/tree/1.3.10) (2015-08-21)

[Full Changelog](https://github.com/Camptocamp/puppet-openssl/compare/1.3.9...1.3.10)

### UNCATEGORIZED PRS; GO LABEL THEM

- Allow to set package version [\#48](https://github.com/camptocamp/puppet-openssl/pull/48) ([edestecd](https://github.com/edestecd))

## [1.3.9](https://github.com/Camptocamp/puppet-openssl/tree/1.3.9) (2015-06-26)

[Full Changelog](https://github.com/Camptocamp/puppet-openssl/compare/1.3.8...1.3.9)

## [1.3.8](https://github.com/Camptocamp/puppet-openssl/tree/1.3.8) (2015-05-28)

[Full Changelog](https://github.com/Camptocamp/puppet-openssl/compare/1.3.7...1.3.8)

## [1.3.7](https://github.com/Camptocamp/puppet-openssl/tree/1.3.7) (2015-05-26)

[Full Changelog](https://github.com/Camptocamp/puppet-openssl/compare/1.3.6...1.3.7)

## [1.3.6](https://github.com/Camptocamp/puppet-openssl/tree/1.3.6) (2015-05-26)

[Full Changelog](https://github.com/Camptocamp/puppet-openssl/compare/1.3.5...1.3.6)

### UNCATEGORIZED PRS; GO LABEL THEM

- Add key\_mode/group/owner parameters [\#45](https://github.com/camptocamp/puppet-openssl/pull/45) ([robbat2](https://github.com/robbat2))

## [1.3.5](https://github.com/Camptocamp/puppet-openssl/tree/1.3.5) (2015-05-25)

[Full Changelog](https://github.com/Camptocamp/puppet-openssl/compare/1.3.4...1.3.5)

## [1.3.4](https://github.com/Camptocamp/puppet-openssl/tree/1.3.4) (2015-05-13)

[Full Changelog](https://github.com/Camptocamp/puppet-openssl/compare/1.3.3...1.3.4)

## [1.3.3](https://github.com/Camptocamp/puppet-openssl/tree/1.3.3) (2015-05-12)

[Full Changelog](https://github.com/Camptocamp/puppet-openssl/compare/1.3.2...1.3.3)

## [1.3.2](https://github.com/Camptocamp/puppet-openssl/tree/1.3.2) (2015-04-27)

[Full Changelog](https://github.com/Camptocamp/puppet-openssl/compare/1.3.1...1.3.2)

## [1.3.1](https://github.com/Camptocamp/puppet-openssl/tree/1.3.1) (2015-04-17)

[Full Changelog](https://github.com/Camptocamp/puppet-openssl/compare/1.3.0...1.3.1)

## [1.3.0](https://github.com/Camptocamp/puppet-openssl/tree/1.3.0) (2015-04-03)

[Full Changelog](https://github.com/Camptocamp/puppet-openssl/compare/1.2.8...1.3.0)

### UNCATEGORIZED PRS; GO LABEL THEM

- templates/cert.cnf.erb: Use sha256 instead of sha1 by default [\#43](https://github.com/camptocamp/puppet-openssl/pull/43) ([lathiat](https://github.com/lathiat))

## [1.2.8](https://github.com/Camptocamp/puppet-openssl/tree/1.2.8) (2015-03-24)

[Full Changelog](https://github.com/Camptocamp/puppet-openssl/compare/1.2.7...1.2.8)

## [1.2.7](https://github.com/Camptocamp/puppet-openssl/tree/1.2.7) (2015-03-10)

[Full Changelog](https://github.com/Camptocamp/puppet-openssl/compare/1.2.6...1.2.7)

### UNCATEGORIZED PRS; GO LABEL THEM

- Remove useless ca-certificates file management [\#38](https://github.com/camptocamp/puppet-openssl/pull/38) ([ckaenzig](https://github.com/ckaenzig))

## [1.2.6](https://github.com/Camptocamp/puppet-openssl/tree/1.2.6) (2015-02-18)

[Full Changelog](https://github.com/Camptocamp/puppet-openssl/compare/1.2.5...1.2.6)

## [1.2.5](https://github.com/Camptocamp/puppet-openssl/tree/1.2.5) (2015-01-19)

[Full Changelog](https://github.com/Camptocamp/puppet-openssl/compare/1.2.4...1.2.5)

## [1.2.4](https://github.com/Camptocamp/puppet-openssl/tree/1.2.4) (2015-01-07)

[Full Changelog](https://github.com/Camptocamp/puppet-openssl/compare/1.2.3...1.2.4)

## [1.2.3](https://github.com/Camptocamp/puppet-openssl/tree/1.2.3) (2015-01-05)

[Full Changelog](https://github.com/Camptocamp/puppet-openssl/compare/1.2.2...1.2.3)

## [1.2.2](https://github.com/Camptocamp/puppet-openssl/tree/1.2.2) (2014-12-18)

[Full Changelog](https://github.com/Camptocamp/puppet-openssl/compare/1.2.1...1.2.2)

## [1.2.1](https://github.com/Camptocamp/puppet-openssl/tree/1.2.1) (2014-12-18)

[Full Changelog](https://github.com/Camptocamp/puppet-openssl/compare/1.2.0...1.2.1)

## [1.2.0](https://github.com/Camptocamp/puppet-openssl/tree/1.2.0) (2014-12-09)

[Full Changelog](https://github.com/Camptocamp/puppet-openssl/compare/1.1.0...1.2.0)

## [1.1.0](https://github.com/Camptocamp/puppet-openssl/tree/1.1.0) (2014-11-25)

[Full Changelog](https://github.com/Camptocamp/puppet-openssl/compare/1.0.1...1.1.0)

## [1.0.1](https://github.com/Camptocamp/puppet-openssl/tree/1.0.1) (2014-11-17)

[Full Changelog](https://github.com/Camptocamp/puppet-openssl/compare/1.0.0...1.0.1)

## [1.0.0](https://github.com/Camptocamp/puppet-openssl/tree/1.0.0) (2014-10-20)

[Full Changelog](https://github.com/Camptocamp/puppet-openssl/compare/0.3.2...1.0.0)

### UNCATEGORIZED PRS; GO LABEL THEM

-  Improvement in doc to show how to generate password-free certs [\#32](https://github.com/camptocamp/puppet-openssl/pull/32) ([enekogb](https://github.com/enekogb))

## [0.3.2](https://github.com/Camptocamp/puppet-openssl/tree/0.3.2) (2014-09-23)

[Full Changelog](https://github.com/Camptocamp/puppet-openssl/compare/0.3.1...0.3.2)

## [0.3.1](https://github.com/Camptocamp/puppet-openssl/tree/0.3.1) (2014-07-04)

[Full Changelog](https://github.com/Camptocamp/puppet-openssl/compare/0.3.0...0.3.1)

### UNCATEGORIZED PRS; GO LABEL THEM

- Puppet 3 fixes, cleanup [\#31](https://github.com/camptocamp/puppet-openssl/pull/31) ([foonix](https://github.com/foonix))

## [0.3.0](https://github.com/Camptocamp/puppet-openssl/tree/0.3.0) (2014-07-02)

[Full Changelog](https://github.com/Camptocamp/puppet-openssl/compare/0.2.0...0.3.0)

## [0.2.0](https://github.com/Camptocamp/puppet-openssl/tree/0.2.0) (2014-03-03)

[Full Changelog](https://github.com/Camptocamp/puppet-openssl/compare/735e515565a28b466165eac8fcc6d4125356b9a0...0.2.0)

### UNCATEGORIZED PRS; GO LABEL THEM

- Pkcs12 modifications [\#34](https://github.com/camptocamp/puppet-openssl/pull/34) ([cjeanneret](https://github.com/cjeanneret))
- Fix bug with x509\_Request not having the cnf template present [\#28](https://github.com/camptocamp/puppet-openssl/pull/28) ([jrnt30](https://github.com/jrnt30))
- Document 'group' parameter [\#27](https://github.com/camptocamp/puppet-openssl/pull/27) ([pataquets](https://github.com/pataquets))
- Add 'group' parameter to x509 certificate. [\#26](https://github.com/camptocamp/puppet-openssl/pull/26) ([pataquets](https://github.com/pataquets))
- Added certificate signing request dependency on configuration template [\#25](https://github.com/camptocamp/puppet-openssl/pull/25) ([tylerwalts](https://github.com/tylerwalts))
- Fix for issue 16 [\#21](https://github.com/camptocamp/puppet-openssl/pull/21) ([ghost](https://github.com/ghost))
- Ignore Gemfile.lock [\#20](https://github.com/camptocamp/puppet-openssl/pull/20) ([ghost](https://github.com/ghost))
- Deprecation warnings when running rake spec [\#19](https://github.com/camptocamp/puppet-openssl/pull/19) ([ghost](https://github.com/ghost))
- Deprecation warning when running bundle install [\#18](https://github.com/camptocamp/puppet-openssl/pull/18) ([ghost](https://github.com/ghost))
- Add cnf\_tpl param to openssl::certificate::x509. [\#12](https://github.com/camptocamp/puppet-openssl/pull/12) ([Sliim](https://github.com/Sliim))
- Fix puppet-lint link in README.md [\#11](https://github.com/camptocamp/puppet-openssl/pull/11) ([Sliim](https://github.com/Sliim))
- Update Modulefile to work with other modules requiring stdlib [\#10](https://github.com/camptocamp/puppet-openssl/pull/10) ([LarsFronius](https://github.com/LarsFronius))
- Add x509\_cert and x509\_csr types and providers [\#9](https://github.com/camptocamp/puppet-openssl/pull/9) ([raphink](https://github.com/raphink))
- Export pkcs12 without password [\#8](https://github.com/camptocamp/puppet-openssl/pull/8) ([raphink](https://github.com/raphink))
- openssl: added support for various distributions. [\#5](https://github.com/camptocamp/puppet-openssl/pull/5) ([mfournier](https://github.com/mfournier))
- openssl::export::pkcs12 - new definition. name says it all [\#3](https://github.com/camptocamp/puppet-openssl/pull/3) ([cjeanneret](https://github.com/cjeanneret))
- openssl::certificate::x509 - corrected call to script [\#2](https://github.com/camptocamp/puppet-openssl/pull/2) ([cjeanneret](https://github.com/cjeanneret))



\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
