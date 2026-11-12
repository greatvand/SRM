resource "aws_vpc" "main" {
  cidr_block = "10.1.0.0/16"
    tags = {
        Name = "main-vpc"
    }
}

resource "aws_subnet" "main" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.1.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "main-subnet"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0" #all/any IP address on the internet
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "main-route-table"
  }
}

resource "aws_route_table_association" "main" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.main.id
}

resource "aws_security_group" "ssh" {
  name        = "allow-ssh"
  description = "Allow inbound SSH"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # allow SSH from any IP address
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # allow all outbound traffic
  }
}

resource aws_key_pair "main" {
  key_name   = "Demo1"
  public_key = file("Demo1.pem.pub")  
}

resource "aws_instance" "main" {
  ami           = "ami-0d97d7f07b25dd693" # Ubuntu Server 26.04 LTS (HVM), SSD Volume Type
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.main.id
  key_name      = aws_key_pair.main.key_name

  vpc_security_group_ids = [aws_security_group.ssh.id]

  tags = {
    Name = "main-instance"
  }
}