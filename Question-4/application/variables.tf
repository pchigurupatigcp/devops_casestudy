variable "instance_type" {
  description = "default instance type"
  default     = "t2.micro"
}

variable "associate_public_ip_address" {
  description = "associate public ip"
  default     = true
}

variable "instances_number" {
  description = "nmber of instances"
  type        = number
  default     = 1
}