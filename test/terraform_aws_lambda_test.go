package test

import (
	"fmt"
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestLambdaFunction(t *testing.T) {
	t.Parallel()

	lambdaFunctionName := strings.ToLower(fmt.Sprintf("lambda-test-%s", random.UniqueId()))

	terraformOptions := &terraform.Options{
		// The path to where the Terraform code is located
		TerraformDir: "./lambda-python-test",
		Vars: map[string]interface{}{
			"name": lambdaFunctionName,
		},
		Upgrade: true,
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)
}
