terraform {
  backend "s3" {
    bucket = "xa-online-2021-march"
    key    = "siimaarmaa"
    region = "eu-west-1"
  }
}
