# task4_HMC

# TASK:
1. Write an Infrastructure as code using terraform, which automatically create a VPC.
2. In that VPC we have to create 2 subnets:
1. public subnet [ Accessible for Public World! ]
2. private subnet [ Restricted for Public World! ]
3. Create a public facing internet gateway for connect our VPC/Network to the internet world and attach this gateway to our VPC.
4. Create a routing table for Internet gateway so that instance can connect to outside world, update and associate it with public subnet.
5. Create a NAT gateway for connect our VPC/Network to the internet world and attach this gateway to our VPC in the public network
6. Update the routing table of the private subnet, so that to access the internet it uses the nat gateway created in the public subnet
7. Launch an ec2 instance which has Wordpress setup already having the security group allowing port 80 sothat our client can connect to our wordpress site. Also attach the key to instance for further login into it.
8. Launch an ec2 instance which has MYSQL setup already with security group allowing port 3306 in private subnet so that our wordpress vm can connect with the same. Also attach the key with the same.

# CLI COMMANDS:
1 ) Firstly Initialize Terraform by

          terraform init 

![1](https://user-images.githubusercontent.com/51692515/95899564-654dcc00-0dae-11eb-84e4-f11fae6c198d.png)

2) Now, run terraform Code by,

         terraform apply
         
![2](https://user-images.githubusercontent.com/51692515/95899567-667ef900-0dae-11eb-9a85-f5dbd6f2e64f.png)

Now , here Wordpress instance creating

![3](https://user-images.githubusercontent.com/51692515/95899569-67178f80-0dae-11eb-9783-ed23ea5cd25b.png)

Now, here Routing Table is created

![4](https://user-images.githubusercontent.com/51692515/95899570-67b02600-0dae-11eb-86b4-449199ae79b9.png)

Now, here Security Group is created

![5](https://user-images.githubusercontent.com/51692515/95899572-6848bc80-0dae-11eb-9c8d-28f809384665.png)

![6](https://user-images.githubusercontent.com/51692515/95899576-6979e980-0dae-11eb-891b-57f0d3b6e386.png)

here Subnet is created,

![7](https://user-images.githubusercontent.com/51692515/95899578-6a128000-0dae-11eb-8b4d-2d2a90bf4a48.png)

here ,vpc Created,

![8](https://user-images.githubusercontent.com/51692515/95899582-6aab1680-0dae-11eb-8246-a278d679e1ed.png)

here successfully Created ,

![9](https://user-images.githubusercontent.com/51692515/95899583-6aab1680-0dae-11eb-9fd8-80083f21263c.png)

# CODE:
Step 1 : Create code using terraform for Infrastructure.

Step 2: Create profile .

        provider "aws" {
	  region   = "ap-south-1"
	  profile  = "task"
	}
          
Step 2: Create Instances with Wordpress and Provide Key.
	
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
          
Step 3: Create Second Instance with MySql And Provide Key.
	
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
          
Step 4: Create Security Groups for Wordpress With Port 80.

	
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
          
Step 5: Create Security Groups For Database .

	
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
          
Step 6: Create VPC.
	
	resource "aws_vpc" "myvpc" {
	  cidr_block       = "192.168.0.0/16"
	  instance_tenancy = "default"
	  enable_dns_hostnames  = true
	
	  tags = {
	    Name = "aditya-vpc"
	  
        }
	}
          
    
Step 7: Create Routing Table and NAT gateway.
	
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
	resource "aws_route_table_association" "nat" 
  
Step 8 : Create Subnet Public.
	
	resource "aws_subnet" "public" {
	  vpc_id     = "${aws_vpc.myvpc.id}"
	  cidr_block = "192.168.0.0/24"
	  availability_zone = "ap-south-1a"
	
	  tags = {
	    Name = "public-subnet"
	  }
	}
          
Step 9: Create Subnet Private.
	
	resource "aws_subnet" "private" {
	  vpc_id     = "${aws_vpc.myvpc.id}"
	  cidr_block = "192.168.1.0/24"
	  availability_zone = "ap-south-1b"
	
	  tags = {
	    Name = "private-subnet"
	  }
	}
          
Step 10: Create INTERNET GATEWAY.
	
	resource "aws_internet_gateway" "gw" {
	  vpc_id = "${aws_vpc.myvpc.id}"
	
	  tags = {
	    Name = "internet-gateway"
	  }
	}
          
          
# GUI OUTPUT(CONSOLE OUTPUT):

![10](https://user-images.githubusercontent.com/51692515/95900406-7cd98480-0daf-11eb-82e0-ee7637186a77.png)

![11](https://user-images.githubusercontent.com/51692515/95900410-7e0ab180-0daf-11eb-908c-03d27757561e.png)

![12](https://user-images.githubusercontent.com/51692515/95900412-7ea34800-0daf-11eb-97e5-e4f9fc1dc53d.png)

![13](https://user-images.githubusercontent.com/51692515/95900415-7f3bde80-0daf-11eb-9070-775a54458f45.png)

![14](https://user-images.githubusercontent.com/51692515/95900417-7f3bde80-0daf-11eb-9f7f-3a45ae7658ac.png)

![15](https://user-images.githubusercontent.com/51692515/95900418-7fd47500-0daf-11eb-867c-eeb61a47d150.png)

![16](https://user-images.githubusercontent.com/51692515/95900421-806d0b80-0daf-11eb-9f10-fc8b04b33cfc.png)

![17](https://user-images.githubusercontent.com/51692515/95900424-8105a200-0daf-11eb-9261-3b2582917d1e.png)

![18](https://user-images.githubusercontent.com/51692515/95900425-8105a200-0daf-11eb-9c76-95adae8481d8.png)

![19](https://user-images.githubusercontent.com/51692515/95900428-819e3880-0daf-11eb-8285-dd9f7422b9f1.png)

![20](https://user-images.githubusercontent.com/51692515/95900429-8236cf00-0daf-11eb-90c8-d62c3fc351e7.png)

