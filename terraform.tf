terraform {
  backend "s3" {
    bucket = "xa-online-2021-march"
    key    = "studentSiim"
    region = "eu-west-1"
  }
}
