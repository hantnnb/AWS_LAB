variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "ap-southeast-1" # Singapore
}

# Tag to all resources for this project
variable "default_tags" {
  description = "Default tags applied to all resources for this project"
  type        = map(string)
  default = {
    project = "labs-terraform"
  }
}

variable "key_name" {
  type    = string
  default = "han-lab-key"
}
