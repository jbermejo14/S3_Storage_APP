data "aws_ami" "server_ami" {
  most_recent = true
  owners      = ["099720109477"] #099720109477 is the owner of the Linux AMI 2

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}