resource "aws_vpc" "my_vpc" {
  cidr_block           = "10.123.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "dev"
  }
}

resource "aws_subnet" "my_public_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.123.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

  tags = {
    Name = "dev-public"
  }
}

resource "aws_internet_gateway" "my_internet_gateway" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "dev-igw"
  }
}

resource "aws_route_table" "my_public_rt" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "dev-public_rt"
  }
}

resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.my_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.my_internet_gateway.id
}

resource "aws_route_table_association" "my_public_assoc" {
  subnet_id      = aws_subnet.my_public_subnet.id
  route_table_id = aws_route_table.my_public_rt.id
}

resource "aws_security_group" "my_sg" {
  name        = "dev_sg"
  description = "dev security group"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] #change to my IP
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "my_auth" {
  key_name   = "my_key_s3"
  public_key = file("~/.ssh/my_key.pub")
}


resource "aws_instance" "S3_App_Instance" {
    ami           = "ami-08a0d1e16fc3f61ea"
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.my_public_subnet.id
  security_groups = [aws_security_group.my_sg.id]
  key_name               = aws_key_pair.my_auth.id
  user_data       = <<EOF
                    #!/bin/bash
                    sudo yum install git -y
                    sudo yum install python -y
                    sudo yum install pip -y
                    sudo pip install django
                    sudo git clone https://github.com/jbermejo14/S3_Storage_APP.git
                    cd S3_Storage_APP
                    sudo python manage.py runserver 0.0.0.0:8000
                    EOF

  tags = {
    Name = "S3_App_Instance"
  }
}
resource "aws_s3_bucket" "App_bucket" {
  bucket = "jb-storage-app-bucket"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

