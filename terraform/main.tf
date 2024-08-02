/**
 * Terraform configuration file for creating a VPC, subnet, internet gateway, route table,
 * security group, EC2 instances, and Elastic IPs in AWS.
 */

terraform {
    required_providers {
      aws = {
        source = "hashicorp/aws"
        version = "~> 4.0"
      }
    }
}

// Configure the AWS Provider
provider "aws" {
    region = "us-east-1"
}

// Create the VPC, subnet, internet gateway, and route table
resource "aws_vpc" "Jenkins_Meter_VPC" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "Jenkins_Meter_Subnet" {
  vpc_id     = aws_vpc.Jenkins_Meter_VPC.id
  cidr_block = "10.0.0.0/24"
}

resource "aws_internet_gateway" "Jenkins_Meter_internet_gateway" {
  vpc_id = aws_vpc.Jenkins_Meter_VPC.id
}

resource "aws_route_table" "Jenkins_Meter_route_table" {
  vpc_id = aws_vpc.Jenkins_Meter_VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Jenkins_Meter_internet_gateway.id
  }
}

resource "aws_route_table_association" "Jenkins_Meter_route_table_association" {
  subnet_id      = aws_subnet.Jenkins_Meter_Subnet.id
  route_table_id = aws_route_table.Jenkins_Meter_route_table.id
}

// Create the security group
resource "aws_security_group" "Jenkins_Meter_security_group" {
  name        = "Jenkins_Meter_security_group"
  description = "Allow all traffic"
  vpc_id      = aws_vpc.Jenkins_Meter_VPC.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

// Create the Jenkins Meter EC2 instance
resource "aws_instance" "Jenkins_Meter_Server" {
  ami           = "ami-0a33e4385182de263"
  instance_type = "t3.large"
  key_name      = "Jenkins_Server"

  subnet_id     = aws_subnet.Jenkins_Meter_Subnet.id
  vpc_security_group_ids = [aws_security_group.Jenkins_Meter_security_group.id]

  ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = 30
  }

  tags = {
    Name = "Jenkins_Meter_Server"
  }
}

// Create the Elastic IP for Jenkins Meter EC2 instance
resource "aws_eip" "JMeter_Server_eip" {
  vpc = true
}

// Associate the Elastic IP with the Jenkins Meter EC2 instance
resource "aws_eip_association" "Jenkins_Meter_Server_eip_association" {
  instance_id   = aws_instance.Jenkins_Meter_Server.id
  allocation_id = aws_eip.JMeter_Server_eip.id
}

// Create a null resource to trigger the creation of the Jenkins Meter EC2 instance and Elastic IP association
resource "null_resource" "Jenkins_Meter_Server_trigger" {
  depends_on = [aws_instance.Jenkins_Meter_Server]
}

// Create the Easy Travel EC2 instance
resource "aws_instance" "Easy_Travel_Instance" {
  ami           = "ami-0ac2886caf2877ccd"
  instance_type = "t3.medium"
  key_name = "Jenkins_Server"

  subnet_id     = aws_subnet.Jenkins_Meter_Subnet.id
  vpc_security_group_ids = [aws_security_group.Jenkins_Meter_security_group.id]

  ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = 30
  }

  tags = {
    Name = "Easy_Travel_instance"
  }
}

// Create the Elastic IP for Easy Travel EC2 instance
resource "aws_eip" "Easy_Travel_eip" {
  vpc = true
}

// Associate the Elastic IP with the Easy Travel EC2 instance
resource "aws_eip_association" "Easy_Travel_eip_association" {
  instance_id   = aws_instance.Easy_Travel_Instance.id
  allocation_id = aws_eip.Easy_Travel_eip.id
}

// Create a null resource to trigger the creation of the Easy Travel EC2 instance and Elastic IP association
resource "null_resource" "Easy_Travel_trigger" {
  depends_on = [aws_instance.Easy_Travel_Instance]
}

// Outputs
output "easy_travel_elastic_ip" {
  description = "The Elastic IP address of the Easy Travel EC2 instance"
  value       = aws_eip.Easy_Travel_eip.public_ip
}

output "jenkins_server_elastic_ip" {
  description = "The Elastic IP address of the Jenkins Meter EC2 instance"
  value       = aws_eip.JMeter_Server_eip.public_ip
}