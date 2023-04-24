variable "ami-windows-server-2022" {
  type    = string
  default = "ami-0fdf5a3be18a0a653"
}

variable "ami-aws-linux" {
  type    = string
  default = "ami-069fa606c9a99d947"
}
variable "private_key" {
  type    = string
  default = "windows-server-2022-AWS.pem"
}

variable "whitelist_cidr_home" {
  type    = string
  default = "188.218.131.2/32"
}

variable "whitelist_cidr_laura" {
  type    = string
  default = "5.102.1.122/32"
}

#subnet 172.31.0.0/20
variable "subnet_id" {
  type    = string
  default = "subnet-09ebbb40612837f6c"
}
variable "private_ip_sliver-server" {
  type    = string
  default = "172.31.0.5"
}

variable "whitelist_cidr_office" {
  type    = string
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
  type = string
  default = "winadmin1"
}

variable "instance_password" {
  type = string
  default = {{winadmin1 password}}
}
