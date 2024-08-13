resource "aws_security_group" "windows-sliver-builder_sg" {
  name        = "windows-server_sg"
  description = "Used in the terraform"

  ingress {
    description = "RDP Access"
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = [var.whitelist_cidr_home, var.whitelist_cidr_office]
  }

  ingress {
    description = "WinRM Access"
    from_port   = 5985
    to_port     = 5986
    protocol    = "tcp"
    cidr_blocks = [var.whitelist_cidr_home, var.whitelist_cidr_office]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 31337
    to_port     = 31337
    protocol    = "tcp"
    cidr_blocks = ["172.31.0.0/20"]
  }
}

resource "aws_security_group" "sliver-server_sg" {
  name        = "sliver-server_sg"
  description = "Used in the terraform"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.whitelist_cidr_home, var.whitelist_cidr_office]
  }
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "GRPC-multiplayer"
    from_port   = 31337
    to_port     = 31337
    protocol    = "tcp"
    cidr_blocks = [var.whitelist_cidr_home, var.whitelist_cidr_office, "172.31.0.0/20"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
