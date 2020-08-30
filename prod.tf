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

//resource "aws_instance" "prod_web" {
//  count = 2
//
//  ami = "ami-038630edbff4d358e"
//  instance_type = "t2.nano"
//
//  vpc_security_group_ids = [
//    aws_security_group.prod_web.id
//  ]
//
//  tags = {
//    "Terraform": "true"
//  }
//}

// use aws_eip_association do decouple eip and instance creation
//resource "aws_eip_association" "prod_web" {
//  instance_id = aws_instance.prod_web.0.id
//  allocation_id = aws_eip.prod_web.id
//}
//
//resource "aws_eip" "prod_web" {
//  tags = {
//    "Terraform": "true"
//  }
//}

resource "aws_elb" "prod_web" {
  name = "prod-web"
  subnets = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id]
  security_groups = [aws_security_group.prod_web.id]

  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }
  tags = {
    "Terraform": "true"
  }
}

resource "aws_launch_template" "prod_web" {
  name_prefix = "prod-web"
  image_id = var.web_image_id
  instance_type = var.web_instance_type
  vpc_security_group_ids = [aws_security_group.prod_web.id]
  tags = {
    "Terraform": "true"
  }
}

resource "aws_autoscaling_group" "prod_web" {
//  availability_zones = ["ap-southeast-2a", "ap-southeast-2b"]
  vpc_zone_identifier = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id]
  max_size = var.web_max_size
  min_size = var.web_min_size
  desired_capacity = var.web_desired_capacity

  launch_template {
    id = aws_launch_template.prod_web.id
    version = "$Latest"
  }
  tag {
    key = "Terraform"
    value = "true"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_attachment" "prod_web" {
  autoscaling_group_name = aws_autoscaling_group.prod_web.id
  elb = aws_elb.prod_web.id
}