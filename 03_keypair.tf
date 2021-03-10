resource "aws_key_pair" "studentNN" {
  key_name = "studentNN"
  public_key = "${file("studentNN.pem.pub")}"
}
