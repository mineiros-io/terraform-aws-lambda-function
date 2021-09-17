[<img src="https://raw.githubusercontent.com/mineiros-io/brand/3bffd30e8bdbbde32c143e2650b2faa55f1df3ea/mineiros-primary-logo.svg" width="400"/>][homepage]

[![GitHub tag (latest SemVer)][badge-semver]][releases-github]
[![license][badge-license]][apache20]
[![Terraform Version][badge-terraform]][releases-terraform]
[![Join Slack][badge-slack]][slack]

# Examples for using this Mineiros module

- [examples/python-function] Deploys a simple Python function to AWS Lambda.
- [examples/s3-complete-example] Creates a S3 bucket and uploads a deployment package as an object to it. Deploys a
  Lambda Function that uses the S3 Object as a deployment package. Creates a Lambda alias and permissions for SNS.

<!-- References -->
[examples/python-function]: https://github.com/mineiros-io/terraform-aws-lambda-function/blob/master/examples/python-function
[examples/s3-complete-example]: https://github.com/mineiros-io/terraform-aws-lambda-function/blob/master/examples/s3-complete-example

[homepage]: https://mineiros.io/?ref=terraform-aws-lambda-function

[badge-license]: https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg
[badge-terraform]: https://img.shields.io/badge/terraform-1.x%20|%200.15%20|%200.14%20|%200.13%20|%200.12.20+-623CE4.svg?logo=terraform
[badge-slack]: https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack
[badge-semver]: https://img.shields.io/github/v/tag/mineiros-io/terraform-aws-lambda-function.svg?label=latest&sort=semver

[releases-github]: https://github.com/mineiros-io/terraform-aws-lambda-function/releases
[releases-terraform]: https://github.com/hashicorp/terraform/releases
[apache20]: https://opensource.org/licenses/Apache-2.0
[slack]: https://join.slack.com/t/mineiros-community/shared_invite/zt-ehidestg-aLGoIENLVs6tvwJ11w9WGg
