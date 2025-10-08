variable "name" {
  type = string
}

variable "ami" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "security_group_ids" {
  type = list(string)
}

variable "associate_public_ip_address" {
  type    = bool
  default = true
}

variable "key_name" {
  type = string
}

variable "user_data" {
  type    = string
  default = null
}

variable "tags" {
  type    = map(string)
  default = {}
}

