output "sliver-server_ip" {
  value = aws_instance.sliver-server.public_ip
}

output "windows-sliver-builder_ip" {
  value = aws_instance.sliver-builder.public_ip
}

output "Administrator_Password" {
  value = aws_instance.sliver-builder.password_data
}