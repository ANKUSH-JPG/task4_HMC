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
