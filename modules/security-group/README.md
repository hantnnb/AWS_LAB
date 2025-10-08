This module creates the base SG for a specified VPC, without any inline ingress/egress rules

Inline rules are avoid because: 
* They cause drift when mixed with separate rule resources 
* They don't support tagging or multiple CIDRs cleanly 

### Locals: preprocess and flatten rules
* `var.ingress` and `var.egress` are lists of maps pass to the module
* Each rule may include multiple CIDRs, but AWS's `aws_vpc_security_group_ingress_rule` only accepts 1 CIDR/rule
* The for-loop inside locals duplicates each rule once/CIDR block, so Terraform later creates 1 resource/CIDR


### Ingress & Egress rule: 1 resource/rule
* Each expanded ingress rule (from locals) becomes a separate AWS rule resource
* `for_each` builds a map of index → rule data, so Terraform can track each rule individually
* `try()` avoids errors if description is missing
* Result: Terraform will create 1 AWS SG ingress rule/CIDR, attached to the same SG ID
* Same logic for outbound traffic

### Related Sources:
* [Resource: aws_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group)
