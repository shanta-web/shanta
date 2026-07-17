variable "region"{
    description = "The region where the resources will be created"
    default     = "ap-south-1"
}

variable "instance_type" {
    description = "The instance type for the EC2 instance"
    default     = "t3.small"
}

variable "ami_id" {
    description = "The AMI ID for the EC2 instance"
    default     = "ami-01a00762f46d584a1" # Example AMI ID, replace with a valid one for your region
}

variable "vpc_cidr" {
    description = "The CIDR block for the VPC"
    default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
    description = "The CIDR block for the public subnet"
    default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
    description = "The CIDR block for the private subnet"
    default     = "10.0.2.0/24"
}

variable "availability_zone" {
    description = "The availability zone for the resources"
    default     = "ap-south-1a"
}

variable "availability_zone_2" {
    description = "The second availability zone for the resources"
    default     = "ap-south-1b"
}
