resource "aws_key_pair" "siimaarmaaV2" {
  key_name = "siimaarmaaV2"
  public_key = "${file("siimaarmaa.pem.pub")}"
}
