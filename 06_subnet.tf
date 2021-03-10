data "aws_subnet" "workshop_subnet_primary" {
  cidr_block = "10.1.101.0/24"
}

data "aws_subnet" "workshop_subnet_secondary" {
  cidr_block = "10.1.102.0/24"
}
