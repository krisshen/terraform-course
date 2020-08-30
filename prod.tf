provider "aws" {
  profile = "default"
  region = "ap-southeast-2"
}

resource "aws_s3_bucket" "prod_tf_course" {
  bucket = "tf-course-20200830"
  acl    = "private"
}

resource "aws_default_vpc" "default" {}