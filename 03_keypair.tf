resource "aws_key_pair" "studentSiim" {
  key_name = "studentSiim"
  public_key = "${file("studentNN.pem.pub")}"
}
