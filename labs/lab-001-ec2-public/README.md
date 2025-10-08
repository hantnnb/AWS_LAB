`aws_ssm_parameter` is recommended in this lab because:
* `aws_ssm_parameter` queries the AWS Systems Manager Parameter Store for a public parameter maintained by AWS
* These parameters always point to the latest official AMI IDs (for that region, architecture, kernel, etc.)
* It’s the official and reliable method for all public AWS AMIs (Amazon Linux, Windows, ECS-optimized, etc.)

### Related Sources:
[Data Source: aws_ami](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami)
[Data Source: aws_ssm_parameter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter#example-usage)
