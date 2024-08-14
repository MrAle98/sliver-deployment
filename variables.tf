variable "ami-windows-server-2022" {
  type    = string
  default = "ami-05804339cc1cf98c0"
}

variable "ami-aws-linux" {
  type    = string
  default = "ami-0b7fd829e7758b06d"
}

variable "private_key" {
  type    = string
  default = "windows-server-2022-AWS.pem"
}

variable "whitelist_cidr_home" {
  type = string
  default = "2.37.204.174/32"
}

#subnet 172.31.0.0/20
variable "subnet_id" {
  type    = string
  default = "subnet-0e66160a715744509"
}
variable "private_ip_sliver-server" {
  type    = string
  default = "172.31.0.5"
}

variable "whitelist_cidr_office" {
  type = string
  default = "212.31.229.126/32"
}

variable "root_volume_size" {
  description = "Size of the root volume in GB"
  type        = number
  default     = 80
}

variable "delete_on_termination" {
  description = "Volume get destroyed on instance termination"
  type        = bool
  default     = true
}

variable "instance_username" {
  type    = string
  default = "winadmin1"
}

variable "instance_password" {
  type = string
  default = "Topwsksav431!!"
}
