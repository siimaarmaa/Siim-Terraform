terraform {
  backend "s3" {
    bucket = "xa-online-2021-march"
    key    = "studentNN"
    region = "eu-west-1"
  }
}
