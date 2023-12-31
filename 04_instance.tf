resource "aws_instance" "siimaarmaa_machine" {
  ami = "ami-0b9b99ebee79d6799"
  instance_type = "t2.medium"
  tags = {
    Name = "siimaarmaa_machine"
  }
  root_block_device {
    volume_size = "10"
  }
  key_name = "siimaarmaa"
  subnet_id = "subnet-0b23f9ab4b717f747"
  vpc_security_group_ids = [ "sg-0fd07fe7732248ac6" ]
}
