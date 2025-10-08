variable "name" {
  type = string
}

variable "description" {
  type    = string
  default = "Security Group"
}

variable "vpc_id" {
  type = string
}

variable "ingress" {
  description = "List of ingress rules (from_port, to_port, protocol, cidr_blocks)"
  type = list(object({
    description = optional(string)
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = []
}

variable "egress" {
  description = "List of egress rules"
  type = list(object({
    description = optional(string)
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    { from_port = 0, to_port = 0, protocol = "-1", cidr_blocks = ["0.0.0.0/0"] }
  ]
}

variable "tags" {
  type    = map(string)
  default = {}
}
