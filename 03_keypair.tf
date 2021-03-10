resource "aws_key_pair" "siimaarmaa" {
  key_name = "siimaarmaa"
  public_key = "${file("siimaarmaa.pem.pub")}"
}
