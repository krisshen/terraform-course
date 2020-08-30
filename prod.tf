variable "whitelist" {
  type = list(string)
}
variable "web_image_id" {
  type = string
}
variable "web_instance_type" {
  type = string
}
variable "web_max_size" {
  type = number
}
variable "web_min_size" {
  type = number
}
variable "web_desired_capacity" {
  type = number
}
//whitelist = ["0.0.0.0/0"]
//web_image_id = "ami-038630edbff4d358e"
//web_instance_type = "t2.micro"
//web_max_size = 2
//web_min_size = 2
//web_desired_capacity = 2

provider "aws" {
  profile = "default"
  region = "ap-southeast-2"
}

//resource "aws_s3_bucket" "prod_tf_course" {
//  bucket = "tf-course-20200830"
//  acl = "private"
//  tags = {
//    "Terraform": "true"
//  }
//}

resource "aws_default_vpc" "default" {}

resource "aws_default_subnet" "default_az1" {
  availability_zone = "ap-southeast-2a"
  tags = {
    "Terraform": "true"
  }
}

resource "aws_default_subnet" "default_az2" {
  availability_zone = "ap-southeast-2b"
  tags = {
    "Terraform": "true"
  }
}

resource "aws_security_group" "prod_web" {
  name = "prod_web"
  // optional
  description = "Allow standard http and https ports inbound and everything outbound"

  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    cidr_blocks = var.whitelist // allows everything in
  }
  ingress {
    from_port = 443
    protocol = "tcp"
    to_port = 443
    cidr_blocks = var.whitelist // allows everything in
  }
  egress {
    from_port = 0
    protocol = "-1" // all
    to_port = 0
    cidr_blocks = var.whitelist
  }

  tags = {
    "Terraform": "true" // from AWS console can filter "Terraform" to see which resources are managed bt TF
  }
}

module "web_app" {
  source = "./modules/web_app"

  security_groups = [aws_security_group.prod_web.id]
  subnets = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id]
  web_desired_capacity = var.web_desired_capacity
  web_image_id = var.web_image_id
  web_instance_type = var.web_instance_type
  web_max_size = var.web_max_size
  web_min_size = var.web_min_size
  web_app = "prod"
}