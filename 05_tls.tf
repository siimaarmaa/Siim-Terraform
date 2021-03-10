data "external" "generated_key_pair" {
  program = [ "python", "generate_key.py" ]
}

resource "aws_key_pair" "key2_siimaarmaa" {
  key_name   = "key2_siimaarmaa"
  public_key = data.external.generated_key_pair.result.public_key
}
