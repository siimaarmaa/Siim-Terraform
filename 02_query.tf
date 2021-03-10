data "aws_ami" "devops_ubuntu" {
  most_recent = true
  filter {
    name = "name"
    values = [ "devops-ubuntu-18-04-x64*" ]
  }
  owners = [ "self" ]
}
data "aws_subnet" "devops_subnet" {
  cidr_block = "10.1.101.0/24"
}
data "aws_security_group" "workshop_security_group" {
   name = "workshop_security"
}
