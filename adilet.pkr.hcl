variable "aws_access_key" {
  type    = string
  default = env("AWS_ACCESS_KEY_ID")
}

variable "aws_secret_key" {
  type    = string
  default = env("AWS_SECRET_ACCESS_KEY")
}

variable "aws_region" {
  type    = string
  default = env("AWS_REGION")
}

variable "source_ami_filter" {
  type    = string
  default = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

source "amazon-ebs" "example" {
  access_key    = var.aws_access_key
  secret_key    = var.aws_secret_key
  region        = var.aws_region
  instance_type = var.instance_type
  ssh_username  = "ubuntu"
  ami_name      = "my-ami-${formatdate("2006-01-02", timestamp())}"

  source_ami_filter {
    filters = {
      name               = var.source_ami_filter
      "virtualization-type" = "hvm"
    }
    owners = ["099720109477"]
    most_recent = true
  }

  provisioner "shell" {
    inline = [
      "sudo yum install httpd -y",
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd"
    ]
  }
}
