resource "aws_key_pair" "siimaarmaaV2" {
  key_name = "siimaarmaa"
  public_key = "${file("siimaarmaa.pem.pub")}"
}
