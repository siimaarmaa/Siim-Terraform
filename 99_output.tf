output "ami_id" {
  value = data.aws_ami.devops_ubuntu.image_id
}
output "ip" {
  value = aws_instance.studentNN_machine.public_ip
}
