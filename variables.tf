variable "regio"{
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