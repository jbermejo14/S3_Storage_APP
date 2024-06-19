resource "aws_vpc" "S3_app_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "dev-app-S3"
  }
}

resource "aws_subnet" "App_public_subnet-1a" {
  vpc_id                  = aws_vpc.S3_app_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

  tags = {
    Name = "app-public-1a"
  }
}


resource "aws_internet_gateway" "S3_APP_Internet_GW" {
  vpc_id = aws_vpc.S3_app_vpc.id

  tags = {
    Name = "S3-dev-igw"
  }
}

resource "aws_route_table" "S3_APP_Route_Table" {
  vpc_id = aws_vpc.S3_app_vpc.id

  tags = {
    Name = "S3-dev-public_rt"
  }
}

resource "aws_route" "S3_APP_default_route" {
  route_table_id         = aws_route_table.S3_APP_Route_Table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.S3_APP_Internet_GW.id
}

resource "aws_route_table_association" "my_public_assoc" {
  subnet_id      = aws_subnet.App_public_subnet-1a.id
  route_table_id = aws_route_table.S3_APP_Route_Table.id
}

resource "aws_security_group" "S3_APP_SG" {
  name        = "S3_APP_SG_DEV"
  description = "SG for S3_App"
  vpc_id      = aws_vpc.S3_app_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] #change to my IP
  }

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] #change to my IP
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] #change to my IP
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "S3_App_Instance" {
    ami           = "ami-08a0d1e16fc3f61ea"
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.App_public_subnet-1a.id
  security_groups = [aws_security_group.S3_APP_SG.id]
  user_data       = <<EOF
                    #!/bin/bash
                    sudo yum install git -y
                    sudo yum install python -y
                    sudo git clone https://github.com/jbermejo14/S3_Storage_APP.git
                    jbermejo14
                    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
                    cd S3_Storage_APP
                    sudo python manage.py runserver
                    EOF

  tags = {
    Name = "S3_App_Instance"
  }
  key_name = "ASC-keypair"
}
resource "aws_s3_bucket" "App_bucket" {
  bucket = "jb-storage-app-bucket"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

