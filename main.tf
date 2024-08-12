resource "aws_s3_bucket" "bucket1" {
	bucket = "neeha-first-bucket-1208"
}

resource "aws_s3_bucket" "bucket2" {
    
}


provider "aws" {
    region = "eu-west-1"
}

terraform {
  backend "s3" {
    bucket         = "neeha-s3bucket-date"
    key            = "globalstate/s3/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "neeha-date-dblocks"
    encrypt        = true
  }
}
