header {
  image = "https://raw.githubusercontent.com/mineiros-io/brand/3bffd30e8bdbbde32c143e2650b2faa55f1df3ea/mineiros-primary-logo.svg"
  url   = "https://mineiros.io/?ref=terraform-aws-lambda-function"

  badge "build" {
    image = "https://github.com/mineiros-io/terraform-aws-lambda-function/workflows/CI/CD%20Pipeline/badge.svg"
    url   = "https://github.com/mineiros-io/terraform-aws-lambda-function/actions"
    text  = "Build Status"
  }

  badge "semver" {
    image = "https://img.shields.io/github/v/tag/mineiros-io/terraform-aws-lambda-function.svg?label=latest&sort=semver"
    url   = "https://github.com/mineiros-io/terraform-aws-lambda-function/releases"
    text  = "GitHub tag (latest SemVer)"
  }

  badge "terraform" {
    image = "https://img.shields.io/badge/terraform-1.x%20|%200.15%20|%200.14%20|%200.13%20|%200.12.20+-623CE4.svg?logo=terraform"
    url   = "https://github.com/hashicorp/terraform/releases"
    text  = "Terraform Version"
  }

  badge "tf-aws-provider" {
    image = "https://img.shields.io/badge/AWS-3-F8991D.svg?logo=terraform"
    url   = "https://github.com/terraform-providers/terraform-provider-aws/releases"
    text  = "AWS Provider Version"
  }

  badge "slack" {
    image = "https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack"
    url   = "https://mineiros.io/slack"
    text  = "Join Slack"
  }
}

section {
  title   = "terraform-aws-lambda-function"
  toc     = true
  content = <<-END
    A [Terraform] module for deploying and managing [Serverless Lambda Functions] on [Amazon Web Services (AWS)][AWS].

    ***This module supports both, Terraform v1.x, v0.15, v0.14, v0.13 as well as v0.12.20 and above.***

    This module is part of our Infrastructure as Code (IaC) framework
    that enables our users and customers to easily deploy and manage reusable,
    secure, and production-grade cloud infrastructure.
  END

  section {
    title   = "Module Features"
    content = <<-END
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
    END
  }

  section {
    title   = "Getting Started"
    content = <<-END
      Most basic usage just setting required arguments:

      ```hcl
      module "terraform-aws-lambda-function" {
        source  = "mineiros-io/lambda-function/aws"
        version = "~> 0.5.0"

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
    END
  }

  section {
    title   = "Module Argument Reference"
    content = <<-END
      See [variables.tf] and [examples/] for details and use-cases.
    END

    section {
      title = "Top-level Arguments"

      section {
        title = "Module Configuration"

        variable "module_enabled" {
          type        = bool
          default     = true
          description = <<-END
            Specifies whether resources in the module will be created.
          END
        }

        variable "module_tags" {
          type        = map(string)
          default     = {}
          description = <<-END
            A map of tags that will be applied to all created resources that accept tags.
            Tags defined with 'module_tags' can be overwritten by resource-specific tags.
          END
        }

        variable "module_depends_on" {
          type        = any
          readme_type = "list(dependencies)"
          description = <<-END
            A list of dependencies. Any object can be _assigned_ to this list to define a hidden external dependency.
          END
        }
      }

      section {
        title = "Lambda Function Resource Configuration"

        variable "function_name" {
          required    = true
          type        = string
          description = <<-END
            A unique name for the Lambda function.
          END
        }

        variable "handler" {
          type        = string
          description = <<-END
            The function entrypoint in the code. This is the name of the method in the code which receives the event and context parameter when this Lambda function is triggered.
          END
        }

        variable "role_arn" {
          required    = true
          type        = string
          description = <<-END
            The ARN of the policy that is used to set the permissions boundary for the IAM role for the Lambda function.
          END
        }

        variable "runtime" {
          required    = true
          type        = string
          default     = "[]"
          description = <<-END
            The runtime the Lambda function should run in. A list of all available runtimes can be found here: https://docs.aws.amazon.com/lambda/latest/dg/lambda-runtimes.html
          END
        }

        variable "aliases" {
          type           = any
          default        = {}
          readme_type    = "map(name => alias))"
          description    = <<-END
            A map of aliases (keyed by the alias name) that will be created for the Lambda function. If `version` is omitted, the alias will automatically point to `$LATEST`.
          END
          readme_example = <<-END
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
          END

          attribute "description" {
            type        = string
            description = <<-END
              Description of the alias.
            END
          }

          attribute "function_version" {
            type        = string
            default     = "$LATEST"
            description = <<-END
              Lambda function version for which you are creating the alias.
              Pattern: `(\$LATEST|[0-9]+)`.
            END
          }

          attribute "additional_version_weights" {
            type        = map(string)
            description = <<-END
              A map that defines the proportion of events that should be sent to different versions of a lambda function.
            END
          }
        }

        variable "description" {
          type        = string
          description = <<-END
            A description of what the Lambda function does.
          END
        }

        variable "publish" {
          type        = bool
          default     = false
          description = <<-END
            Whether to publish creation/change as new Lambda function.
            This allows you to use aliases to refer to execute different versions of the function in different environments.
          END
        }

        variable "function_tags" {
          type        = map(string)
          default     = {}
          description = <<-END
            A map of tags that will be applied to the function.
          END
        }

        variable "vpc_subnet_ids" {
          type        = set(string)
          default     = []
          description = <<-END
            A set of subnet IDs associated with the Lambda function.
          END
        }

        variable "layer_arns" {
          type        = set(string)
          default     = []
          description = <<-END
            Set of Lambda Layer Version ARNs (maximum of 5) to attach to your Lambda function.
            For details see https://docs.aws.amazon.com/lambda/latest/dg/configuration-layers.html
          END
        }

        variable "reserved_concurrent_executions" {
          type        = number
          default     = -1
          description = <<-END
            The amount of reserved concurrent executions for this Lambda function.
            A value of 0 disables Lambda from being triggered and -1 removes any concurrency limitations.
            For details see https://docs.aws.amazon.com/lambda/latest/dg/invocation-scaling.html
          END
        }

        variable "s3_bucket" {
          type        = string
          description = <<-END
            The S3 bucket location containing the function's deployment package.
            Conflicts with `filename`. This bucket must reside in the same AWS region where you are creating the Lambda function.
          END
        }

        variable "source_code_hash" {
          type        = string
          description = <<-END
            Used to trigger updates. Must be set to a base64-encoded SHA256 hash of the package file specified with either `filename` or `s3_key`.
          END
        }

        variable "environment_variables" {
          type        = map(string)
          default     = {}
          description = <<-END
            A map of environment variables to pass to the Lambda function.
            AWS will automatically encrypt these with KMS if a key is provided and decrypt them when running the function.
          END
        }

        variable "kms_key_arn" {
          type        = string
          description = <<-END
            The ARN for the KMS encryption key that is used to encrypt environment variables. If none is provided when environment variables are in use, AWS Lambda uses a default service key.
          END
        }

        variable "filename" {
          type        = string
          description = <<-END
            The path to the local .zip file that contains the Lambda function source code.
          END
        }

        variable "timeout" {
          type        = number
          default     = 3
          description = <<-END
            The amount of time the Lambda function has to run in seconds. For details see https://docs.aws.amazon.com/lambda/latest/dg/gettingstarted-limits.html
          END
        }

        variable "dead_letter_config_target_arn" {
          type        = string
          description = <<-END
            The ARN of an SNS topic or SQS queue to notify when an invocation fails.
            If this option is used, the function's IAM role must be granted suitable access to write to the target object, which means allowing either the 'sns:Publish' or 'sqs:SendMessage' action on this ARN, depending on which service is targeted.
          END
        }

        variable "s3_key" {
          type        = string
          description = <<-END
            The S3 key of an object containing the function's deployment package.
            Conflicts with `filename`.
          END
        }

        variable "s3_object_version" {
          type        = string
          description = <<-END
            The object version containing the function's deployment package.
            Conflicts with `filename`.
          END
        }

        variable "vpc_security_group_ids" {
          type        = set(string)
          default     = []
          description = <<-END
            A set of security group IDs associated with the Lambda function.
          END
        }

        variable "memory_size" {
          type        = number
          default     = 128
          description = <<-END
            Amount of memory in MB the Lambda function can use at runtime.
            For details see https://docs.aws.amazon.com/lambda/latest/dg/gettingstarted-limits.html
          END
        }

        variable "permissions" {
          type           = any
          readme_type    = "list(permission))"
          default        = []
          description    = <<-END
            A list of permission objects of external resources (like a CloudWatch Event Rule, SNS, or S3) that should have permission to access the Lambda function.
          END
          readme_example = <<-END
            permissions = [
              {
                statement_id = "AllowExecutionFromSNS"
                principal    = "sns.amazonaws.com"
                source_arn   = aws_sns_topic.lambda.arn
              }
            ]
          END

          attribute "statement_id" {
            required    = true
            type        = string
            description = <<-END
              A unique statement identifier.
            END
          }

          attribute "action" {
            required    = true
            type        = string
            description = <<-END
              The AWS Lambda action you want to allow in this statement. (e.g. `lambda:InvokeFunction`)
            END
          }

          attribute "principal" {
            required    = true
            type        = string
            description = <<-END
              The principal who is getting this permission. e.g. `s3.amazonaws.com`, an AWS account ID, or any valid AWS service principal such as `events.amazonaws.com` or `sns.amazonaws.com`.
            END
          }

          attribute "event_source_token" {
            type        = string
            description = <<-END
              The Event Source Token to validate. Used with Alexa Skills.
            END
          }

          attribute "qualifier" {
            type        = string
            description = <<-END
              Query parameter to specify function version or alias name.
              The permission will then apply to the specific qualified ARN. e.g. `arn:aws:lambda:aws-region:acct-id:function:function-name:2`.
            END
          }

          attribute "source_account" {
            type        = string
            description = <<-END
              This parameter is used for S3 and SES.
              The AWS account ID (without a hyphen) of the source owner.
            END
          }

          attribute "source_arn" {
            type        = string
            description = <<-END
              When the principal is an AWS service, the ARN of the specific resource within that service to grant permission to. Without this, any resource from principal will be granted permission – even if that resource is from another account.
              For S3, this should be the ARN of the S3 Bucket.
              For CloudWatch Events, this should be the ARN of the CloudWatch Events Rule.
              For API Gateway, this should be the ARN of the API, as described in
              https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html.
            END
          }
        }

        variable "tracing_mode" {
          type        = string
          description = <<-END
            Can be either `PassThrough` or `Active`. If set to `PassThrough`, Lambda will only trace the request from an upstream service if it contains a tracing header with `sampled=1`. If set to `Active`, Lambda will respect any tracing header it receives from an upstream service. If no tracing header is received,
            Lambda will call X-Ray for a tracing decision.
          END
        }
      }
    }
  }

  section {
    title   = "Module Outputs"
    content = <<-END
      The following attributes are exported by the module:

      - **`function`**

        All outputs of the `aws_lambda_function` resource."

      - **`aliases`**

        A map of all created `aws_lambda_alias` resources keyed by name.

      - **`permissions`**

        A map of all created `aws_lambda_permission` resources keyed by `statement_id`.

      - **`module_enabled`**

        Whether this module is enabled.

      - **`module_inputs`**

        A map of all module arguments. Omitted optional arguments will be represented with their actual defaults.

      - **`module_tags`**
      
        A map of tags that will be applied to all created resources that accept tags.
        Tags defined with `module_tags` can be overwritten by resource-specific tags.
    END
  }

  section {
    title = "External Documentation"

    section {
      title   = "AWS Lambda Documentation"
      content = <<-END
        - General Documentation: https://docs.aws.amazon.com/lambda/latest/dg/welcome.html
        - Functions: https://docs.aws.amazon.com/lambda/latest/dg/lambda-functions.html
        - Aliases: https://docs.aws.amazon.com/lambda/latest/dg/configuration-aliases.html
      END
    }

    section {
      title   = "Terraform AWS Provider Documentation"
      content = <<-END
        - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function
        - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_alias
        - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission
      END
    }
  }

  section {
    title   = "Module Versioning"
    content = <<-END
      This Module follows the principles of [Semantic Versioning (SemVer)].

      Given a version number `MAJOR.MINOR.PATCH`, we increment the:

      1. `MAJOR` version when we make incompatible changes,
      2. `MINOR` version when we add functionality in a backwards compatible manner, and
      3. `PATCH` version when we make backwards compatible bug fixes.
    END

    section {
      title   = "Backwards compatibility in `0.0.z` and `0.y.z` version"
      content = <<-END
        - Backwards compatibility in versions `0.0.z` is **not guaranteed** when `z` is increased. (Initial development)
        - Backwards compatibility in versions `0.y.z` is **not guaranteed** when `y` is increased. (Pre-release)
      END
    }
  }

  section {
    title   = "About Mineiros"
    content = <<-END
      [Mineiros][homepage] is a remote-first company headquartered in Berlin, Germany
      that solves development, automation and security challenges in cloud infrastructure.

      Our vision is to massively reduce time and overhead for teams to manage and
      deploy production-grade and secure cloud infrastructure.

      We offer commercial support for all of our modules and encourage you to reach out
      if you have any questions or need help. Feel free to email us at [hello@mineiros.io] or join our
      [Community Slack channel][slack].
    END
  }

  section {
    title   = "Reporting Issues"
    content = <<-END
      We use GitHub [Issues] to track community reported issues and missing features.
    END
  }

  section {
    title   = "Makefile Targets"
    content = <<-END
      This repository comes with a handy [Makefile].
      Run `make help` to see details on each available target.
    END
  }

  section {
    title   = "License"
    content = <<-END
      [![license][badge-license]][apache20]

      This module is licensed under the Apache License Version 2.0, January 2004.
      Please see [LICENSE] for full details.
      
      Copyright &copy; 2020-2022 [Mineiros GmbH][homepage]
    END
  }
}

references {
  ref "homepage" {
    value = "https://mineiros.io/?ref=terraform-aws-lambda-function"
  }
  ref "hello@mineiros.io" {
    value = "mailto:hello@mineiros.io"
  }
  ref "badge-build" {
    value = "https://github.com/mineiros-io/terraform-aws-lambda-function/workflows/CI/CD%20Pipeline/badge.svg"
  }
  ref "badge-semver" {
    value = "https://img.shields.io/github/v/tag/mineiros-io/terraform-aws-lambda-function.svg?label=latest&sort=semver"
  }
  ref "badge-license" {
    value = "https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg"
  }
  ref "badge-terraform" {
    value = "https://img.shields.io/badge/terraform-1.x%20|%200.15%20|%200.14%20|%200.13%20|%200.12.20+-623CE4.svg?logo=terraform"
  }
  ref "badge-slack" {
    value = "https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack"
  }
  ref "build-status" {
    value = "https://github.com/mineiros-io/terraform-aws-lambda-function/actions"
  }
  ref "releases-github" {
    value = "https://github.com/mineiros-io/terraform-aws-lambda-function/releases"
  }
  ref "releases-terraform" {
    value = "https://github.com/hashicorp/terraform/releases"
  }
  ref "apache20" {
    value = "https://opensource.org/licenses/Apache-2.0"
  }
  ref "slack" {
    value = "https://join.slack.com/t/mineiros-community/shared_invite/zt-ehidestg-aLGoIENLVs6tvwJ11w9WGg"
  }
  ref "Terraform" {
    value = "https://www.terraform.io"
  }
  ref "AWS" {
    value = "https://aws.amazon.com/"
  }
  ref "Serverless Lambda Functions" {
    value = "https://aws.amazon.com/lambda/"
  }
  ref "Semantic Versioning (SemVer)" {
    value = "https://semver.org/"
  }
  ref "terraform-aws-iam-role" {
    value = "https://github.com/mineiros-io/terraform-aws-iam-role"
  }
  ref "examples/s3-complete-example/main.tf" {
    value = "https://github.com/mineiros-io/terraform-aws-lambda-function/blob/master/examples/s3-complete-example/main.tf"
  }
  ref "variables.tf" {
    value = "https://github.com/mineiros-io/terraform-aws-lambda-function/blob/master/variables.tf"
  }
  ref "examples/" {
    value = "https://github.com/mineiros-io/terraform-aws-lambda-function/blob/master/examples"
  }
  ref "Issues" {
    value = "https://github.com/mineiros-io/terraform-aws-lambda-function/issues"
  }
  ref "LICENSE" {
    value = "https://github.com/mineiros-io/terraform-aws-lambda-function/blob/master/LICENSE"
  }
  ref "Makefile" {
    value = "https://github.com/mineiros-io/terraform-aws-lambda-function/blob/master/Makefile"
  }
  ref "Pull Requests" {
    value = "https://github.com/mineiros-io/terraform-aws-lambda-function/pulls"
  }
  ref "Contribution Guidelines" {
    value = "https://github.com/mineiros-io/terraform-aws-lambda-function/blob/master/CONTRIBUTING.md"
  }
}
