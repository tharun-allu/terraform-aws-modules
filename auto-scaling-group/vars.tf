

variable "desired_capacity" {
  default = ""
}

variable "min_size" {}

variable "max_size" {}

variable "max_batch_size" {}

variable "on_demand_percentage_above_base_capacity" {
  default = 0
}

variable "min_instance_in_service" {}

variable "name" {
  default = ""
}

variable "environment" {
  default = ""
}

variable "image_id" {
  default = ""
}


variable "instance_type" {
  default = ""
}
variable "instance_types" {
  default = ""
}

variable "key_name" {
  default = ""
}

variable "aws_region" {
  default = ""
}

variable "security_group_ids" {
  type = "list"
}

variable "subnet_ids" {}

