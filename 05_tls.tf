data "external" "generated_key_pair" {
  program = [ "python", "generate_key.py" ]
}

resource "aws_key_pair" "generated_key2" {
  key_name   = "generated_key2"
  public_key = data.external.generated_key_pair.result.public_key
}
