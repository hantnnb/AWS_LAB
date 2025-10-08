# Security group shell
resource "aws_security_group" "this" {
  name        = var.name
  description = var.description
  vpc_id      = var.vpc_id
  tags        = var.tags
}

# ====================================================================
# Terraform’s resource aws_vpc_security_group_ingress_rule expects one
# CIDR per rule, not a list => Use locals to expand that list of CIDRs
# into 1 rule per CIDR, each becomes 1 element in a for_each map
# ====================================================================
# Preprocess complex variables (lists of CIDRs) into  1 resource/CIDR
locals {
  ingress_expanded = flatten([
    for rule in var.ingress : [
      for cidr in rule.cidr_blocks : merge(rule, { cidr_block = cidr })
    ]
  ])

  egress_expanded = flatten([
    for rule in var.egress : [
      for cidr in rule.cidr_blocks : merge(rule, { cidr_block = cidr })
    ]
  ])
}

# 1 resource per ingress rule
resource "aws_vpc_security_group_ingress_rule" "this" {
  for_each          = { for i, r in local.ingress_expanded : i => r }
  security_group_id = aws_security_group.this.id

  description = try(each.value.description, null)
  ip_protocol = each.value.protocol
  from_port   = each.value.from_port
  to_port     = each.value.to_port
  cidr_ipv4   = each.value.cidr_block
}

# 1 resource per egress rule
resource "aws_vpc_security_group_egress_rule" "this" {
  for_each          = { for i, r in local.egress_expanded : i => r }
  security_group_id = aws_security_group.this.id

  description = try(each.value.description, null)
  ip_protocol = each.value.protocol
  from_port   = each.value.from_port
  to_port     = each.value.to_port
  cidr_ipv4   = each.value.cidr_block
}

