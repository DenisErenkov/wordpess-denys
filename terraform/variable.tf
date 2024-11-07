variable "name" {
  description = "enter name prodject"
  type        = string
}

variable "db_password" {
  description = "pd_password"
  type = string
}

variable "allowed_ports_ec2" {
  description = "allowed_ports_ec2"
  type        = list(any)
  default = [ "22","80","443" ]
}