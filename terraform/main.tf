terraform {
    required_providers {
      aws = {
        source = "hashicorp/aws"
        version = "~> 4.0"
      }
    }
}


# Configure the AWS Provider
provider "aws" {
    region = "us-east-1"
}



# Criação da VPC, subnet, gateway de internet e tabela de rotas
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

# Criação do security group
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


resource "aws_instance" "Jenkins_Meter_Server" {
  ami           = "ami-04a81a99f5ec58529"
  instance_type = "t2.medium"
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

# Criação Elastic IP
resource "aws_eip" "JMeter_Server_eip" {
  vpc = true
}

# Associação do Elastic IP à instância EC2
resource "aws_eip_association" "Jenkins_Meter_Server_eip_association" {
  instance_id   = aws_instance.Jenkins_Meter_Server.id
  allocation_id = aws_eip.JMeter_Server_eip.id
}

# Recurso nulo apenas para acionar a criação da instância EC2 e associação do Elastic IP
resource "null_resource" "Jenkins_Meter_Server_trigger" {
  depends_on = [aws_instance.Jenkins_Meter_Server]
}
