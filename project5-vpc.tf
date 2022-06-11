//vpc
resource "aws_vpc" "Proj5-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "Proj5-vpc"
  }
}
//private subnet 1
resource "aws_subnet" "Proj5-subnet-prv1" {
  vpc_id     = aws_vpc.Proj5-vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Proj5-subnet-prv1"
  }
}

//private subnet 2
resource "aws_subnet" "Proj5-subnet-prv2" {
  vpc_id     = aws_vpc.Proj5-vpc.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "Proj5-subnet-prv2"
  }
}

//public subnet 1
resource "aws_subnet" "Proj5-subnet-pub1" {
  vpc_id     = aws_vpc.Proj5-vpc.id
  cidr_block = "10.0.3.0/24"

  tags = {
    Name = "Proj5-subnet-pub1"
  }
}

//public subnet 2
resource "aws_subnet" "Proj5-subnet-pub2" {
  vpc_id     = aws_vpc.Proj5-vpc.id
  cidr_block = "10.0.4.0/24"

  tags = {
    Name = "Proj5-subnet-pub2"
  }
}


//public route table
resource "aws_route_table" "Proj5-rt-pub" {
  vpc_id = aws_vpc.Proj5-vpc.id

  tags = {
    Name = "Proj5-rt-pub"
  }
}

//Public route table association with public subnet 1
resource "aws_route_table_association" "Proj5-PubRT-association1" {
  subnet_id      = aws_subnet.Proj5-subnet-pub1.id
  route_table_id = aws_route_table.Proj5-rt-pub.id
}

//Public route table association with public subnet 2
resource "aws_route_table_association" "Proj5-PubRT-association2" {
  subnet_id      = aws_subnet.Proj5-subnet-pub2.id
  route_table_id = aws_route_table.Proj5-rt-pub.id
}

// internet gateway
resource "aws_internet_gateway" "Proj5-igw" {
  vpc_id = aws_vpc.Proj5-vpc.id

  tags = {
    Name = "Proj5-igw"
  }
}


//internet gateway route
resource "aws_route" "Proj5-internet-route" {
  route_table_id            = aws_route_table.Proj5-rt-pub.id
  gateway_id                = aws_internet_gateway.Proj5-igw.id
  destination_cidr_block    = "0.0.0.0/0"
}


// Provisioning Elastic IP address
resource "aws_eip" "eip4nat" {
  vpc = true
 
tags = {
  Name = "eip4nat"
}
}

// NAT Gateway provisioning
resource "aws_nat_gateway" "Proj5-nat" {
  allocation_id = aws_eip.eip4nat.id
  subnet_id     = aws_subnet.Proj5-subnet-pub1.id

  tags = {
    Name = "Proj5 NAT"
  }

}

//private route table
resource "aws_route_table" "Proj5-rt-prv" {
  vpc_id = aws_vpc.Proj5-vpc.id

 route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.Proj5-nat.id
    }

  tags = {
    Name = "Proj5-rt-prv"
  }
}

//Private route table association with private subnet 1
resource "aws_route_table_association" "Proj5-PrvRT-association1" {
  subnet_id      = aws_subnet.Proj5-subnet-prv1.id
  route_table_id = aws_route_table.Proj5-rt-prv.id
}

//Private route table association with private subnet 2
resource "aws_route_table_association" "Proj5-PrvRT-association2" {
  subnet_id      = aws_subnet.Proj5-subnet-prv2.id
  route_table_id = aws_route_table.Proj5-rt-prv.id
}

