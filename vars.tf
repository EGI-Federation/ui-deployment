# variables definition, to be used with terraform

variable "internal_net_id" {
  type        = string
  description = "The id of the internal network"
}

variable "public_ip_pool" {
  type        = string
  description = "The name of the public IP address pool"
}

variable "image_id" {
  type        = string
  description = "VM image id"
}

variable "flavor_id" {
  type        = string
  description = "VM flavor id"
}

variable "security_groups" {
  type        = list(string)
  description = "List of security groups"
}
