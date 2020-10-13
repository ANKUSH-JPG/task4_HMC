provider "aws" {
  region   = "ap-south-1"
  profile  = "task"
}

#MYSQL_IMAGE

resource "aws_instance" "mysql" {
  ami           = "ami-0019ac6129392a0f2"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.private.id
  vpc_security_group_ids = [aws_security_group.database.id]
  key_name = "rajaditya"
  

 tags = {
    Name = "mysql-aditya"
  }

}

#WORDPRESS_IMAGE

resource "aws_instance" "wordpress" {
  ami           = "ami-000cbce3e1b899ebd"
  instance_type = "t2.micro"
  associate_public_ip_address = true
  subnet_id = aws_subnet.public.id
  key_name = "rajaditya"
  vpc_security_group_ids = [aws_security_group.webserver.id]

  tags = {
    Name = "wordpress-aditya"
  }
}

#WEBSERVER_SECURITYGROUP

resource "aws_security_group" "webserver" {
  name        = "for_wordpress"
  description = "Allow hhtp"
  vpc_id      = "${aws_vpc.myvpc.id}"

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  } 

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  } 
  

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "securitygroup"
  }
}
#securitygroup_FOR_DATABASE

resource "aws_security_group" "database" {
  name        = "for_MYSQL"
  description = "Allow MYSQL"
  vpc_id      = "${aws_vpc.myvpc.id}"

  ingress {
    description = "MYSQL"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.webserver.id]
   
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "securitygourp"
  }
}

#Creating_VPC

resource "aws_vpc" "myvpc" {
  cidr_block       = "192.168.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames  = true

  tags = {
    Name = "aditya-vpc"
  }
}

#SUBNET_PRIVATE

resource "aws_subnet" "private" {
  vpc_id     = "${aws_vpc.myvpc.id}"
  cidr_block = "192.168.1.0/24"
  availability_zone = "ap-south-1b"

  tags = {
    Name = "private-subnet"
  }
}
#SUBNET_PUBLIC

resource "aws_subnet" "public" {
  vpc_id     = "${aws_vpc.myvpc.id}"
  cidr_block = "192.168.0.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "public-subnet"
  }
}

#INTERNETGATEWAY

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.myvpc.id}"

  tags = {
    Name = "internet-gateway"
  }
}

#ROUTETABLE

resource "aws_route_table" "internetgateway" {
  vpc_id = "${aws_vpc.myvpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

 
  tags = {
    Name = "route-table"
  }
}
resource "aws_route_table_association" "asstopublic" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.internetgateway.id
}

resource "aws_eip" "nat" {
  vpc=true
  
}
resource "aws_nat_gateway" "nat-gw" {
  allocation_id = "${aws_eip.nat.id}"
  subnet_id     = "${aws_subnet.public.id}"
  depends_on = [aws_internet_gateway.gw]

  tags = {
    Name = "net-gateway"
  }
}
resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.myvpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.nat-gw.id}"
  }

 

  tags = {
    Name = "database"
  }
}
resource "aws_route_table_association" "nat" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}
