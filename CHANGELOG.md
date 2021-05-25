# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.4.0]

### Added

- Add support for Terraform `v0.15`

## [0.3.0]

### Added

- Add support for Terraform `v0.14`

## [0.2.0]

### Added

- Add support for terraform 0.13

## [0.1.0] - 2020-08-03

### Changed

- Add support for terraform aws provider 3.x
- Update test to test against 3.0 aws provider
- Update test dependencies to use 3.x capable module versions

### Fixed

- Fix idempotency in minimal test

## [0.0.1] - 2020-07-14

### Added

- Implement support for `aws_lambda_function` resource
- Implement support for `aws_lambda_alias` resource
- Implement support for `aws_lambda_permission` resource
- Document the usage of the module in README.md
- Document the usage of examples
- Add unit tests for basic use cases

<!-- markdown-link-check-disable -->

[unreleased]: https://github.com/mineiros-io/terraform-aws-lambda-function/compare/v0.4.0...HEAD
[0.4.0]: https://github.com/mineiros-io/terraform-aws-lambda-function/compare/v0.3.0...v0.4.0

<!-- markdown-link-check-disabled -->

[0.3.0]: https://github.com/mineiros-io/terraform-aws-lambda-function/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/mineiros-io/terraform-aws-lambda-function/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/mineiros-io/terraform-aws-lambda-function/compare/v0.0.1...v0.1.0
[0.0.1]: https://github.com/mineiros-io/terraform-aws-lambda-function/releases/tag/v0.0.1
