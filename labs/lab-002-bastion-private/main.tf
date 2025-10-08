terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.15.0"
    }
  }
}

# AWS
provider "aws" {
  region = var.region

  default_tags {
    tags = var.default_tags
  }
}

# START: Fetching default VPC for this lab ==================================
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default_public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
  # AWS-created default subnets (public)
  filter {
    name   = "default-for-az"
    values = ["true"]
  }
}
# END: Fetching default VPC for this lab ====================================

# START: Security Group (SSH ONLY) ==========================================
module "sg_ssh" {
  source = "../../modules/security-group"
  name   = "allow-ssh"
  vpc_id = data.aws_vpc.default.id

  ingress = [
    {
      description = "Allow SSH"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  # default egress already allows all outbound traffic
  tags = {
    project = "labs-terraform"
    env     = "dev"
  }
}
# END: Security Group (SSH ONLY) ============================================

# START: Creating EC2 instance ==============================================
# Fetching AMI using aws_ssm_parameter
data "aws_ssm_parameter" "al2023_x86_64" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-6.1-x86_64"
}

# Launch EC2 instance
resource "aws_instance" "ec2_public" {
  ami                         = data.aws_ssm_parameter.al2023_x86_64.value
  instance_type               = "t3.micro" # x86_64 OK
  subnet_id                   = element(data.aws_subnets.default_public.ids, 0)
  vpc_security_group_ids      = [module.sg_ssh.id]
  associate_public_ip_address = true
  key_name                    = var.key_name

  tags = {
    Name = "lab-001-ec2-public"
  }
}
# END: Creating EC2 instance ================================================
