[<img src="https://raw.githubusercontent.com/mineiros-io/brand/3bffd30e8bdbbde32c143e2650b2faa55f1df3ea/mineiros-primary-logo.svg" width="400"/>][homepage]

[![Build Status][badge-build]][build-status]
[![GitHub tag (latest SemVer)][badge-semver]][releases-github]
[![license][badge-license]][apache20]
[![Terraform Version][badge-terraform]][releases-terraform]
[![Join Slack][badge-slack]][slack]

# terraform-aws-lambda-function

A [Terraform] module for deploying and managing [Serverless Lambda Functions]
on [Amazon Web Services (AWS)][AWS].

***This module supports both, Terraform v0.13 as well as v0.12.20 and above.***

This module is part of our Infrastructure as Code (IaC) framework
that enables our users and customers to easily deploy and manage reusable,
secure, and production-grade cloud infrastructure.

- [Module Features](#module-features)
- [Getting Started](#getting-started)
- [Module Argument Reference](#module-argument-reference)
  - [Top-level Arguments](#top-level-arguments)
    - [Module Configuration](#module-configuration)
    - [Main Resource Configuration](#main-resource-configuration)
    - [Extended Resource Configuration](#extended-resource-configuration)
  - [`some_block` Object Arguments](#some_block-object-arguments)
- [Module Attributes Reference](#module-attributes-reference)
- [External Documentation](#external-documentation)
- [Module Versioning](#module-versioning)
  - [Backwards compatibility in `0.0.z` and `0.y.z` version](#backwards-compatibility-in-00z-and-0yz-version)
- [About Mineiros](#about-mineiros)
- [Reporting Issues](#reporting-issues)
- [Contributing](#contributing)
- [Makefile Targets](#makefile-targets)
- [License](#license)

## Module Features

In contrast to the plain `terraform_resource` resource this module has better features.
While all security features can be disabled as needed best practices
are pre-configured.

These are some of our custom features:

- **Default Security Settings**:
  secure by default by setting security to `true`, additional security can be added by setting some feature to `enabled`

- **Standard Module Features**:
  Cool Feature of the main resource, tags

- **Extended Module Features**:
  Awesome Extended Feature of an additional related resource,
  and another Cool Feature

- **Additional Features**:
  a Cool Feature that is not actually a resource but a cool set up from us

- *Features not yet implemented*:
  Standard Features missing,
  Extended Features planned,
  Additional Features planned

## Getting Started

Most basic usage just setting required arguments:

```hcl
module "terraform-aws-lambda-function" {
  source = "git@github.com:mineiros-io/terraform-aws-lambda-function.git?ref=v0.0.1"
}
```

Advanced usage as found in [examples/example/main.tf] setting all required and optional arguments to their default values.

```hcl
module "terraform-aws-lambda-function" {
  source = "git@github.com:mineiros-io/terraform-aws-lambda-function.git?ref=v0.0.1"

  ...

  module_enabled    = true
  module_depends_on = []
}
```

## Module Argument Reference

See [variables.tf] and [examples/] for details and use-cases.

### Top-level Arguments

#### Module Configuration

- **`module_enabled`**: *(Optional `bool`)*

  Specifies whether resources in the module will be created.
  Default is `true`.

- **`module_depends_on`**: *(Optional `list(any)`)*

  A list of dependencies. Any object can be _assigned_ to this list to define a hidden external dependency.

#### Main Resource Configuration

#### Extended Resource Configuration

### [`some_block`](#main-resource-configuration) Object Arguments

## Module Attributes Reference

The following attributes are exported by the module:

- **`module_enabled`**

  Whether this module is enabled.

- **`output_1`**

  The full `resource` object with all its attributes.

## External Documentation

- AWS Documentation IAM:
  - Roles: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles.html
  - Policies: https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies.html
  - Instance Profile: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_use_switch-role-ec2_instance-profiles.html

- Terraform AWS Provider Documentation:
  - https://www.terraform.io/docs/providers/aws/r/iam_role.html
  - https://www.terraform.io/docs/providers/aws/r/iam_role_policy.html
  - https://www.terraform.io/docs/providers/aws/r/iam_role_policy_attachment.html
  - https://www.terraform.io/docs/providers/aws/r/iam_instance_profile.html

## Module Versioning

This Module follows the principles of [Semantic Versioning (SemVer)].

Given a version number `MAJOR.MINOR.PATCH`, we increment the:

1. `MAJOR` version when we make incompatible changes,
2. `MINOR` version when we add functionality in a backwards compatible manner, and
3. `PATCH` version when we make backwards compatible bug fixes.

### Backwards compatibility in `0.0.z` and `0.y.z` version

- Backwards compatibility in versions `0.0.z` is **not guaranteed** when `z` is increased. (Initial development)
- Backwards compatibility in versions `0.y.z` is **not guaranteed** when `y` is increased. (Pre-release)

## About Mineiros

[Mineiros][homepage] is a remote-first company headquartered in Berlin, Germany
that solves development, automation and security challenges in cloud infrastructure.

Our vision is to massively reduce time and overhead for teams to manage and
deploy production-grade and secure cloud infrastructure.

We offer commercial support for all of our modules and encourage you to reach out
if you have any questions or need help. Feel free to email us at [hello@mineiros.io] or join our
[Community Slack channel][slack].

## Reporting Issues

We use GitHub [Issues] to track community reported issues and missing features.

## Contributing

Contributions are always encouraged and welcome! For the process of accepting changes, we use
[Pull Requests]. If you'd like more information, please see our [Contribution Guidelines].

## Makefile Targets

This repository comes with a handy [Makefile].
Run `make help` to see details on each available target.

## License

This module is licensed under the Apache License Version 2.0, January 2004.
Please see [LICENSE] for full details.

Copyright &copy; 2020 [Mineiros GmbH][homepage]

<!-- References -->

[homepage]: https://mineiros.io/?ref=terraform-aws-lambda-function
[hello@mineiros.io]: mailto:hello@mineiros.io

<!-- markdown-link-check-disable -->
[badge-build]: https://mineiros.semaphoreci.com/badges/terraform-aws-lambda-function/branches/master.svg?style=shields&key=df11a416-f581-4d35-917a-fa3c2de2048e
<!-- markdown-link-check-enable -->
[badge-semver]: https://img.shields.io/github/v/tag/mineiros-io/terraform-aws-lambda-function.svg?label=latest&sort=semver
[badge-license]: https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg
[badge-terraform]: https://img.shields.io/badge/terraform-0.13%20and%200.12.20+-623CE4.svg?logo=terraform
[badge-slack]: https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack

<!-- markdown-link-check-disable -->
[build-status]: https://mineiros.semaphoreci.com/projects/terraform-aws-lambda-function
[releases-github]: https://github.com/mineiros-io/terraform-aws-lambda-function/releases
<!-- markdown-link-check-enable -->
[releases-terraform]: https://github.com/hashicorp/terraform/releases
[apache20]: https://opensource.org/licenses/Apache-2.0
[slack]: https://join.slack.com/t/mineiros-community/shared_invite/zt-ehidestg-aLGoIENLVs6tvwJ11w9WGg

[Terraform]: https://www.terraform.io
[AWS]: https://aws.amazon.com/
[Serverless Lambda Functions]: https://aws.amazon.com/lambda/
[Semantic Versioning (SemVer)]: https://semver.org/

<!-- markdown-link-check-disable -->
[examples/example/main.tf]: https://github.com/mineiros-io/terraform-aws-lambda-function/blob/master/examples/example/main.tf
[variables.tf]: https://github.com/mineiros-io/terraform-aws-lambda-function/blob/master/variables.tf
[examples/]: https://github.com/mineiros-io/terraform-aws-lambda-function/blob/master/examples
[Issues]: https://github.com/mineiros-io/terraform-aws-lambda-function/issues
[LICENSE]: https://github.com/mineiros-io/terraform-aws-lambda-function/blob/master/LICENSE
[Makefile]: https://github.com/mineiros-io/terraform-aws-lambda-function/blob/master/Makefile
[Pull Requests]: https://github.com/mineiros-io/terraform-aws-lambda-function/pulls
[Contribution Guidelines]: https://github.com/mineiros-io/terraform-aws-lambda-function/blob/master/CONTRIBUTING.md
<!-- markdown-link-check-enable -->
