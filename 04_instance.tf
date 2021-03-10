resource "aws_instance" "studentSiim_machine" {
  ami = "ami-0b9b99ebee79d6799"
  instance_type = "t2.medium"
  tags = {
    Name = "siimu masin"
  }
  root_block_device {
    volume_size = "10"
  }
  key_name = "studentSiim"
  subnet_id = "subnet-0b23f9ab4b717f747"
  vpc_security_group_ids = [ "sg-0fd07fe7732248ac6" ]
}
