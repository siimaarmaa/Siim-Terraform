output "ami_id" {
  value = data.aws_ami.devops_ubuntu.image_id
}
output "ip" {
  value = aws_instance.siimaarmaa_machine.public_ip
}
