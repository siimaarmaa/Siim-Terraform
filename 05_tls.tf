resource "tls_private_key" "tls_key1" {
  algorithm   = "RSA"
}

resource "aws_key_pair" "generated_key1" {
  key_name   = "generated_key1"
  public_key = tls_private_key.tls_key1.public_key_openssh
}
