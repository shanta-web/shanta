#vpc for ec2 instance
resource "aws_vpc" "main" {
    cidr_block = var.vpc_cidr
}

#public subnet for ec2 instance
resource "aws_subnet" "pub" {
    vpc_id            = aws_vpc.main.id
    cidr_block        = var.public_subnet_cidr
    map_public_ip_on_launch = true
    availability_zone = var.availability_zone
}

#private subnet for ec2 instance
resource "aws_subnet" "private" {
    vpc_id            = aws_vpc.main.id
    cidr_block        = var.private_subnet_cidr
    availability_zone = var.availability_zone_2
}

# Public EC2 instance
resource "aws_instance" "web" {
    ami          =  var.ami_id
    instance_type = var.instance_type
    subnet_id     = aws_subnet.pub.id
    vpc_security_group_ids = [aws_security_group.web_sg.id]
}

# Private EC2 instance  
resource "aws_instance" "private_web" {
    ami          =  var.ami_id
    instance_type = var.instance_type
    subnet_id     = aws_subnet.private.id
    vpc_security_group_ids = [aws_security_group.private_web_sg.id]
    iam_instance_profile = aws_iam_instance_profile.ssm_profile.name
}

#internet gateway for public subnet
resource "aws_internet_gateway" "main" {
    vpc_id = aws_vpc.main.id
}

#public route table for public subnet
resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.main.id
    }
}   

#public route table association for public subnet 
resource "aws_route_table_association" "public" {
    subnet_id      = aws_subnet.pub.id
    route_table_id = aws_route_table.public.id
}

#elastic ip for nat gateway
resource "aws_eip" "nat" {
    domain = "vpc"
}

#nat gateway for private subnet
resource "aws_nat_gateway" "main" {
    allocation_id = aws_eip.nat.id
    subnet_id     = aws_subnet.pub.id
}

#private route table for private subnet
resource "aws_route_table" "private" {
    vpc_id = aws_vpc.main.id

    route{
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.main.id
    }
}

#private route table association for private subnet
resource "aws_route_table_association" "private" {
    subnet_id      = aws_subnet.private.id
    route_table_id = aws_route_table.private.id
}

#security group for public ec2 instance with inbound and outbound rules
resource "aws_security_group" "web_sg" {
    name        = "web_sg"
    description = "Allow HTTP and SSH traffic"
    vpc_id      = aws_vpc.main.id

    ingress {
        description = "Allow HTTP traffic"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "Allow SSH traffic"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        description = "Allow all outbound traffic"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
   } 
}

#security group for private ec2 instance with inbound and outbound rules
resource "aws_security_group" "private_web_sg" {
    name        = "private_web_sg"
    description = "Allow HTTP and SSH traffic from public EC2 instance"
    vpc_id      = aws_vpc.main.id

    ingress {
        description = "Allow SSH traffic from public EC2 instance"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        security_groups = [aws_security_group.web_sg.id]
    }

    egress {
        description = "Allow all outbound traffic"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}