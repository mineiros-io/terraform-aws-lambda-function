[<img src="https://raw.githubusercontent.com/mineiros-io/brand/3bffd30e8bdbbde32c143e2650b2faa55f1df3ea/mineiros-primary-logo.svg" width="400"/>](https://mineiros.io/?ref=terraform-aws-lambda-function)

[![Build Status](https://github.com/mineiros-io/terraform-aws-lambda-function/workflows/CI/CD%20Pipeline/badge.svg)](https://github.com/mineiros-io/terraform-aws-lambda-function/actions)
[![GitHub tag (latest SemVer)](https://img.shields.io/github/v/tag/mineiros-io/terraform-aws-lambda-function.svg?label=latest&sort=semver)](https://github.com/mineiros-io/terraform-aws-lambda-function/releases)
[![Terraform Version](https://img.shields.io/badge/terraform-1.x%20|%200.15%20|%200.14%20|%200.13%20|%200.12.20+-623CE4.svg?logo=terraform)](https://github.com/hashicorp/terraform/releases)
[![AWS Provider Version](https://img.shields.io/badge/AWS-3-F8991D.svg?logo=terraform)](https://github.com/terraform-providers/terraform-provider-aws/releases)
[![Join Slack](https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack)](https://mineiros.io/slack)

# terraform-aws-lambda-function

A [Terraform] module for deploying and managing [Serverless Lambda Functions] on [Amazon Web Services (AWS)][AWS].

***This module supports both, Terraform v1.x, v0.15, v0.14, v0.13 as well as v0.12.20 and above.***

This module is part of our Infrastructure as Code (IaC) framework
that enables our users and customers to easily deploy and manage reusable,
secure, and production-grade cloud infrastructure.


- [Module Features](#module-features)
- [Getting Started](#getting-started)
- [Module Argument Reference](#module-argument-reference)
  - [Top-level Arguments](#top-level-arguments)
    - [Module Configuration](#module-configuration)
    - [Lambda Function Resource Configuration](#lambda-function-resource-configuration)
- [Module Outputs](#module-outputs)
- [External Documentation](#external-documentation)
  - [AWS Lambda Documentation](#aws-lambda-documentation)
  - [Terraform AWS Provider Documentation](#terraform-aws-provider-documentation)
- [Module Versioning](#module-versioning)
  - [Backwards compatibility in `0.0.z` and `0.y.z` version](#backwards-compatibility-in-00z-and-0yz-version)
- [About Mineiros](#about-mineiros)
- [Reporting Issues](#reporting-issues)
- [Makefile Targets](#makefile-targets)
- [License](#license)

## Module Features

In contrast to the plain `terraform_resource` resource this module has better features.
While all security features can be disabled as needed best practices
are pre-configured.

These are some of our custom features:

- **Standard Module Features**:
  Deploy a local deployment package to AWS Lambda
  Deploy a deployment package located in S3 to AWS Lambda

- **Extended Module Features**:
  Aliases, Permissions, VPC Config

- *Features not yet implemented*:
  Event Source Mapping,
  Event Invoke Config
  Layer Versions,
  Provisioned Concurrency Config

## Getting Started

Most basic usage just setting required arguments:

```hcl
module "terraform-aws-lambda-function" {
  source  = "git@github.com:mineiros-io/terraform-aws-lambda-function.git?ref=v0.5.0"

  runtime  = "python3.8"
  handler  = "main"
  role_arn = aws_iam_role.lambda.arn
  filename = "deployment.zip"
}
```

**Note**: This module expects the ARN of an existing IAM Role through the `role_arn` variable.
You can consider or [terraform-aws-iam-role] module for easily setting up IAM Roles.

Advanced examples can be found in [examples/s3-complete-example/main.tf] setting
all required and optional arguments to their default values.

## Module Argument Reference

See [variables.tf] and [examples/] for details and use-cases.

### Top-level Arguments

#### Module Configuration

- [**`module_enabled`**](#var-module_enabled): *(Optional `bool`)*<a name="var-module_enabled"></a>

  Specifies whether resources in the module will be created.

  Default is `true`.

- [**`module_tags`**](#var-module_tags): *(Optional `map(string)`)*<a name="var-module_tags"></a>

  A map of tags that will be applied to all created resources that accept tags.
  Tags defined with 'module_tags' can be overwritten by resource-specific tags.

  Default is `{}`.

- [**`module_depends_on`**](#var-module_depends_on): *(Optional `list(dependencies)`)*<a name="var-module_depends_on"></a>

  A list of dependencies. Any object can be _assigned_ to this list to define a hidden external dependency.

#### Lambda Function Resource Configuration

- [**`function_name`**](#var-function_name): *(**Required** `string`)*<a name="var-function_name"></a>

  A unique name for the Lambda function.

- [**`handler`**](#var-handler): *(Optional `string`)*<a name="var-handler"></a>

  The function entrypoint in the code. This is the name of the method in the code which receives the event and context parameter when this Lambda function is triggered.

- [**`role_arn`**](#var-role_arn): *(**Required** `string`)*<a name="var-role_arn"></a>

  The ARN of the policy that is used to set the permissions boundary for the IAM role for the Lambda function.

- [**`runtime`**](#var-runtime): *(**Required** `string`)*<a name="var-runtime"></a>

  The runtime the Lambda function should run in. A list of all available runtimes can be found here: https://docs.aws.amazon.com/lambda/latest/dg/lambda-runtimes.html

  Default is `"[]"`.

- [**`aliases`**](#var-aliases): *(Optional `map(alias)`)*<a name="var-aliases"></a>

  A map of aliases (keyed by the alias name) that will be created for the Lambda function. If `version` is omitted, the alias will automatically point to `$LATEST`.

  Default is `{}`.

  Example:

  ```hcl
  aliases = {
    latest = {
      description = "The newest deployment."
      additional_version_weights = {
        stable = 0.5
      }
    }
    stable = {
      version     = 2
      description = "The latest stable deployment."
    }
  }
  ```

  Each `alias` object in the map accepts the following attributes:

  - [**`description`**](#attr-aliases-description): *(Optional `string`)*<a name="attr-aliases-description"></a>

    Description of the alias.

  - [**`function_version`**](#attr-aliases-function_version): *(Optional `string`)*<a name="attr-aliases-function_version"></a>

    Lambda function version for which you are creating the alias.
    Pattern: `(\$LATEST|[0-9]+)`.

    Default is `"$LATEST"`.

  - [**`additional_version_weights`**](#attr-aliases-additional_version_weights): *(Optional `map(string)`)*<a name="attr-aliases-additional_version_weights"></a>

    A map that defines the proportion of events that should be sent to different versions of a lambda function.

- [**`description`**](#var-description): *(Optional `string`)*<a name="var-description"></a>

  A description of what the Lambda function does.

- [**`publish`**](#var-publish): *(Optional `bool`)*<a name="var-publish"></a>

  Whether to publish creation/change as new Lambda function.
  This allows you to use aliases to refer to execute different versions of the function in different environments.

  Default is `false`.

- [**`function_tags`**](#var-function_tags): *(Optional `map(string)`)*<a name="var-function_tags"></a>

  A map of tags that will be applied to the function.

  Default is `{}`.

- [**`vpc_subnet_ids`**](#var-vpc_subnet_ids): *(Optional `set(string)`)*<a name="var-vpc_subnet_ids"></a>

  A set of subnet IDs associated with the Lambda function.

  Default is `[]`.

- [**`layer_arns`**](#var-layer_arns): *(Optional `set(string)`)*<a name="var-layer_arns"></a>

  Set of Lambda Layer Version ARNs (maximum of 5) to attach to your Lambda function.
  For details see https://docs.aws.amazon.com/lambda/latest/dg/configuration-layers.html

  Default is `[]`.

- [**`reserved_concurrent_executions`**](#var-reserved_concurrent_executions): *(Optional `number`)*<a name="var-reserved_concurrent_executions"></a>

  The amount of reserved concurrent executions for this Lambda function.
  A value of 0 disables Lambda from being triggered and -1 removes any concurrency limitations.
  For details see https://docs.aws.amazon.com/lambda/latest/dg/invocation-scaling.html

  Default is `-1`.

- [**`s3_bucket`**](#var-s3_bucket): *(Optional `string`)*<a name="var-s3_bucket"></a>

  The S3 bucket location containing the function's deployment package.
  Conflicts with `filename`. This bucket must reside in the same AWS region where you are creating the Lambda function.

- [**`source_code_hash`**](#var-source_code_hash): *(Optional `string`)*<a name="var-source_code_hash"></a>

  Used to trigger updates. Must be set to a base64-encoded SHA256 hash of the package file specified with either `filename` or `s3_key`.

- [**`environment_variables`**](#var-environment_variables): *(Optional `map(string)`)*<a name="var-environment_variables"></a>

  A map of environment variables to pass to the Lambda function.
  AWS will automatically encrypt these with KMS if a key is provided and decrypt them when running the function.

  Default is `{}`.

- [**`kms_key_arn`**](#var-kms_key_arn): *(Optional `string`)*<a name="var-kms_key_arn"></a>

  The ARN for the KMS encryption key that is used to encrypt environment variables. If none is provided when environment variables are in use, AWS Lambda uses a default service key.

- [**`filename`**](#var-filename): *(Optional `string`)*<a name="var-filename"></a>

  The path to the local .zip file that contains the Lambda function source code.

- [**`timeout`**](#var-timeout): *(Optional `number`)*<a name="var-timeout"></a>

  The amount of time the Lambda function has to run in seconds. For details see https://docs.aws.amazon.com/lambda/latest/dg/gettingstarted-limits.html

  Default is `3`.

- [**`dead_letter_config_target_arn`**](#var-dead_letter_config_target_arn): *(Optional `string`)*<a name="var-dead_letter_config_target_arn"></a>

  The ARN of an SNS topic or SQS queue to notify when an invocation fails.
  If this option is used, the function's IAM role must be granted suitable access to write to the target object, which means allowing either the 'sns:Publish' or 'sqs:SendMessage' action on this ARN, depending on which service is targeted.

- [**`s3_key`**](#var-s3_key): *(Optional `string`)*<a name="var-s3_key"></a>

  The S3 key of an object containing the function's deployment package.
  Conflicts with `filename`.

- [**`s3_object_version`**](#var-s3_object_version): *(Optional `string`)*<a name="var-s3_object_version"></a>

  The object version containing the function's deployment package.
  Conflicts with `filename`.

- [**`vpc_security_group_ids`**](#var-vpc_security_group_ids): *(Optional `set(string)`)*<a name="var-vpc_security_group_ids"></a>

  A set of security group IDs associated with the Lambda function.

  Default is `[]`.

- [**`memory_size`**](#var-memory_size): *(Optional `number`)*<a name="var-memory_size"></a>

  Amount of memory in MB the Lambda function can use at runtime.
  For details see https://docs.aws.amazon.com/lambda/latest/dg/gettingstarted-limits.html

  Default is `128`.

- [**`permissions`**](#var-permissions): *(Optional `list(permission)`)*<a name="var-permissions"></a>

  A list of permission objects of external resources (like a CloudWatch Event Rule, SNS, or S3) that should have permission to access the Lambda function.

  Default is `[]`.

  Example:

  ```hcl
  permissions = [
    {
      statement_id = "AllowExecutionFromSNS"
      principal    = "sns.amazonaws.com"
      source_arn   = aws_sns_topic.lambda.arn
    }
  ]
  ```

  Each `permission` object in the list accepts the following attributes:

  - [**`statement_id`**](#attr-permissions-statement_id): *(**Required** `string`)*<a name="attr-permissions-statement_id"></a>

    A unique statement identifier.

  - [**`action`**](#attr-permissions-action): *(**Required** `string`)*<a name="attr-permissions-action"></a>

    The AWS Lambda action you want to allow in this statement. (e.g. `lambda:InvokeFunction`)

  - [**`principal`**](#attr-permissions-principal): *(**Required** `string`)*<a name="attr-permissions-principal"></a>

    The principal who is getting this permission. e.g. `s3.amazonaws.com`, an AWS account ID, or any valid AWS service principal such as `events.amazonaws.com` or `sns.amazonaws.com`.

  - [**`event_source_token`**](#attr-permissions-event_source_token): *(Optional `string`)*<a name="attr-permissions-event_source_token"></a>

    The Event Source Token to validate. Used with Alexa Skills.

  - [**`qualifier`**](#attr-permissions-qualifier): *(Optional `string`)*<a name="attr-permissions-qualifier"></a>

    Query parameter to specify function version or alias name.
    The permission will then apply to the specific qualified ARN. e.g. `arn:aws:lambda:aws-region:acct-id:function:function-name:2`.

  - [**`source_account`**](#attr-permissions-source_account): *(Optional `string`)*<a name="attr-permissions-source_account"></a>

    This parameter is used for S3 and SES.
    The AWS account ID (without a hyphen) of the source owner.

  - [**`source_arn`**](#attr-permissions-source_arn): *(Optional `string`)*<a name="attr-permissions-source_arn"></a>

    When the principal is an AWS service, the ARN of the specific resource within that service to grant permission to. Without this, any resource from principal will be granted permission – even if that resource is from another account.
    For S3, this should be the ARN of the S3 Bucket.
    For CloudWatch Events, this should be the ARN of the CloudWatch Events Rule.
    For API Gateway, this should be the ARN of the API, as described in
    https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html.

- [**`tracing_mode`**](#var-tracing_mode): *(Optional `string`)*<a name="var-tracing_mode"></a>

  Can be either `PassThrough` or `Active`. If set to `PassThrough`, Lambda will only trace the request from an upstream service if it contains a tracing header with `sampled=1`. If set to `Active`, Lambda will respect any tracing header it receives from an upstream service. If no tracing header is received,
  Lambda will call X-Ray for a tracing decision.

## Module Outputs

The following attributes are exported by the module:

- [**`function`**](#output-function): *(`object(function)`)*<a name="output-function"></a>

  All outputs of the `aws_lambda_function` resource."

- [**`aliases`**](#output-aliases): *(`map(alias)`)*<a name="output-aliases"></a>

  A map of all created `aws_lambda_alias` resources keyed by name.

- [**`permissions`**](#output-permissions): *(`list(permission)`)*<a name="output-permissions"></a>

  A map of all created `aws_lambda_permission` resources keyed by
  `statement_id`.

- [**`module_enabled`**](#output-module_enabled): *(`bool`)*<a name="output-module_enabled"></a>

  Whether this module is enabled.

- [**`module_inputs`**](#output-module_inputs): *(`map(module_inputs)`)*<a name="output-module_inputs"></a>

  A map of all module arguments. Omitted optional arguments will be
  represented with their actual defaults.

- [**`module_tags`**](#output-module_tags): *(`map(string)`)*<a name="output-module_tags"></a>

  The map of tags that are being applied to all created resources that
  accept tags.

## External Documentation

### AWS Lambda Documentation

- General Documentation: https://docs.aws.amazon.com/lambda/latest/dg/welcome.html
- Functions: https://docs.aws.amazon.com/lambda/latest/dg/lambda-functions.html
- Aliases: https://docs.aws.amazon.com/lambda/latest/dg/configuration-aliases.html

### Terraform AWS Provider Documentation

- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_alias
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission

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

## Makefile Targets

This repository comes with a handy [Makefile].
Run `make help` to see details on each available target.

## License

[![license][badge-license]][apache20]

This module is licensed under the Apache License Version 2.0, January 2004.
Please see [LICENSE] for full details.
      
Copyright &copy; 2020-2022 [Mineiros GmbH][homepage]


<!-- References -->

[homepage]: https://mineiros.io/?ref=terraform-aws-lambda-function
[hello@mineiros.io]: mailto:hello@mineiros.io
[badge-build]: https://github.com/mineiros-io/terraform-aws-lambda-function/workflows/CI/CD%20Pipeline/badge.svg
[badge-semver]: https://img.shields.io/github/v/tag/mineiros-io/terraform-aws-lambda-function.svg?label=latest&sort=semver
[badge-license]: https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg
[badge-terraform]: https://img.shields.io/badge/terraform-1.x%20|%200.15%20|%200.14%20|%200.13%20|%200.12.20+-623CE4.svg?logo=terraform
[badge-slack]: https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack
[build-status]: https://github.com/mineiros-io/terraform-aws-lambda-function/actions
[releases-github]: https://github.com/mineiros-io/terraform-aws-lambda-function/releases
[releases-terraform]: https://github.com/hashicorp/terraform/releases
[apache20]: https://opensource.org/licenses/Apache-2.0
[slack]: https://join.slack.com/t/mineiros-community/shared_invite/zt-ehidestg-aLGoIENLVs6tvwJ11w9WGg
[Terraform]: https://www.terraform.io
[AWS]: https://aws.amazon.com/
[Serverless Lambda Functions]: https://aws.amazon.com/lambda/
[Semantic Versioning (SemVer)]: https://semver.org/
[terraform-aws-iam-role]: https://github.com/mineiros-io/terraform-aws-iam-role
[examples/s3-complete-example/main.tf]: https://github.com/mineiros-io/terraform-aws-lambda-function/blob/master/examples/s3-complete-example/main.tf
[variables.tf]: https://github.com/mineiros-io/terraform-aws-lambda-function/blob/master/variables.tf
[examples/]: https://github.com/mineiros-io/terraform-aws-lambda-function/blob/master/examples
[Issues]: https://github.com/mineiros-io/terraform-aws-lambda-function/issues
[LICENSE]: https://github.com/mineiros-io/terraform-aws-lambda-function/blob/master/LICENSE
[Makefile]: https://github.com/mineiros-io/terraform-aws-lambda-function/blob/master/Makefile
[Pull Requests]: https://github.com/mineiros-io/terraform-aws-lambda-function/pulls
[Contribution Guidelines]: https://github.com/mineiros-io/terraform-aws-lambda-function/blob/master/CONTRIBUTING.md
