resource "aws_instance" "sliver-server" {
  ami                    = var.ami-aws-linux
  instance_type          = "t2.medium"
  key_name               = "windows-server-2022-AWS"
  vpc_security_group_ids = [aws_security_group.sliver-server_sg.id]
  subnet_id              = var.subnet_id
  private_ip             = var.private_ip_sliver-server

  tags = {
    Name = "sliver-server"
  }

    iam_instance_profile = aws_iam_instance_profile.ec2_profile.id
}

resource "aws_instance" "sliver-builder" {
  ami                    = var.ami-windows-server-2022
  instance_type          = "t2.large"
  key_name               = "windows-server-2022-AWS"
  vpc_security_group_ids = [aws_security_group.windows-sliver-builder_sg.id]
  subnet_id              = var.subnet_id
  get_password_data      = "true"

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.id

  root_block_device {
    volume_size           = var.root_volume_size
    delete_on_termination = var.delete_on_termination
  }

  user_data = data.template_file.windows-userdata.rendered
  tags = {
    Name = "sliver-builder"
  }

}