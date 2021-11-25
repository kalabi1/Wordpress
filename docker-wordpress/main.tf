#Create a VPC
resource "aws_vpc" "Cap_VPC" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "Cap_VPC"
  }
}

#Public Subnet 01
resource "aws_subnet" "Cap_Pub_SN_01" {
  vpc_id            = aws_vpc.Cap_VPC.id
  cidr_block        = var.sub_cidr_1
  availability_zone = var.az_1

  tags = {
    Name = "Cap_Pub_SN_01"
  }
}

#Create a Internet Gateway
resource "aws_internet_gateway" "PAP_IGW" {
  vpc_id = aws_vpc.Cap_VPC.id

  tags = {
    Name = "PAP_IGW"
  }
}

#Create a Public Route Table
resource "aws_route_table" "PAP_Pub_RT" {
  vpc_id = aws_vpc.Cap_VPC.id
  route {
    cidr_block = var.all_cidr
    gateway_id = aws_internet_gateway.PAP_IGW.id
  }
  tags = {
    Name = "PAP_Pub_RT"
  }
}

#Associate Pub SN to Pub RT
resource "aws_route_table_association" "PAP_Pub_Ass_1" {
  subnet_id      = aws_subnet.Cap_Pub_SN_01.id
  route_table_id = aws_route_table.PAP_Pub_RT.id
}
# Create a Frontend Security for all Server
resource "aws_security_group" "Cap_SG" {
  name        = "Cap_SG"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.Cap_VPC.id
  ingress {
    description = "SSH from VPC"
    from_port   = var.port_ssh
    to_port     = var.port_ssh
    protocol    = "tcp"
    cidr_blocks = [var.all_cidr]
  }
  ingress {
    description = "HTTP from VPC"
    from_port   = var.port_proxy4
    to_port     = var.port_proxy4
    protocol    = "tcp"
    cidr_blocks = [var.all_cidr]
  }
  ingress {
    description = "HTTP from VPC"
    from_port   = var.port_proxy5
    to_port     = var.port_proxy5
    protocol    = "tcp"
    cidr_blocks = [var.all_cidr]
  }
  ingress {
    description = "HTTP from VPC"
    from_port   = var.port_proxy3
    to_port     = var.port_proxy3
    protocol    = "tcp"
    cidr_blocks = [var.all_cidr]
  }
  ingress {
    description = "HTTP from VPC"
    from_port   = var.port_proxy1
    to_port     = var.port_proxy1
    protocol    = "tcp"
    cidr_blocks = [var.all_cidr]
  }
  ingress {
    description = "HTTP from VPC"
    from_port   = var.port_http
    to_port     = var.port_http
    protocol    = "tcp"
    cidr_blocks = [var.all_cidr]
  }
  ingress {
    description = "Proxy from VPC"
    from_port   = var.port_proxy
    to_port     = var.port_proxy
    protocol    = "tcp"
    cidr_blocks = [var.all_cidr]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.all_cidr]
  }

  tags = {
    Name = "Cap_SG"
  }
}

#Create Key Pair
resource "aws_key_pair" "Pap_Key1" {
  key_name   = "Pap_Key1"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}

#Create a Docker Host Server
resource "aws_instance" "Docker_Host" {
  ami                         = var.ami
  instance_type               = var.type
  availability_zone           = var.az_1
  key_name                    = aws_key_pair.Pap_Key1.key_name
  subnet_id                   = aws_subnet.Cap_Pub_SN_01.id
  vpc_security_group_ids      = ["${aws_security_group.Cap_SG.id}"]
  associate_public_ip_address = true

  #Connection Through SSH
  connection {
    type        = "ssh"
    private_key = file("~/keypairs/Pap_Key")
    user        = "ec2-user"
    host        = self.public_ip
    #timeout     =  3001
  }

  provisioner "file" {
    source      = "~/project/Vscode/docker-wordpress/docker-compose.yml"
    destination = "/home/ec2-user/docker-compose.yml"
  }

  provisioner "remote-exec" {
    inline = [
      "#!/bin/bash",
      "sudo yum update -y",
      "sudo yum upgrade -y",
      "sudo yum install -y yum-utils",
      "sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo",
      "sudo yum install docker-ce -y",
      "sudo systemctl start docker",
      "sudo curl -L \"https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)\" -o /usr/local/bin/docker-compose",
      "sudo chmod +x /usr/local/bin/docker-compose",
      "sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose",
      "docker-compose --version",
      "sudo docker-compose up -d",
      "sudo docker-compose scale wordpress=4 -d",
    ]
  }

  tags = {
    Name = "Docker_Host"
  }
}