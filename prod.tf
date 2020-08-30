provider "aws" {
  profile = "default"
  region = "ap-southeast-2"
}

resource "aws_s3_bucket" "prod_tf_course" {
  bucket = "tf-course-20200830"
  acl = "private"
}

resource "aws_default_vpc" "default" {}

resource "aws_security_group" "prod_web" {
  name = "prod_web"
  // optional
  description = "Allow standard http and https ports inbound and everything outbound"

  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"] // allows everything in
  }
  ingress {
    from_port = 443
    protocol = "tcp"
    to_port = 443
    cidr_blocks = ["0.0.0.0/0"] // allows everything in
  }
  egress {
    from_port = 0
    protocol = "-1" // all
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Terraform": "true" // from AWS console can filter "Terraform" to see which resources are managed bt TF
  }
}

resource "aws_instance" "prod_web" {
  count = 2

  ami = "ami-038630edbff4d358e"
  instance_type = "t2.nano"

  vpc_security_group_ids = [
    aws_security_group.prod_web.id
  ]

  tags = {
    "Terraform": "true"
  }
}

// use aws_eip_association do decouple eip and instance creation
resource "aws_eip_association" "prod_web" {
  instance_id = aws_instance.prod_web.0.id
  allocation_id = aws_eip.prod_web.id
}

resource "aws_eip" "prod_web" {
  tags = {
    "Terraform": "true"
  }
}