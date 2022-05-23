# Create our VPC that all the RDS will reside within.
resource "aws_vpc" "my_vpc" {
    cidr_block              = "10.0.0.0/16"
    enable_dns_hostnames    = true
    enable_dns_support      = true
    instance_tenancy        = "default"

    tags = {
        Name = var.vpc_name
    }
}


# Create an internet gateway that is connected to the VPC 
resource "aws_internet_gateway" "my_vpc_internet_gateway" {
    vpc_id = aws_vpc.my_vpc.id

    tags = {
        Name = "${var.vpc_name}-internet-gateway"
    }
}


# Create a subnet for the VPC that EC2/RDS instances will deploy within
resource "aws_subnet" "my_vpc_subnet" {
    vpc_id      = aws_vpc.my_vpc.id

    # This must be a subnet of the cidr_block specified in "my_vpc"
    cidr_block  = "10.0.0.0/24" 
    
    availability_zone_id = "${var.availability_zone_prefix}-az1"

    # Ensure the internet gateway is already up.
    depends_on  = [aws_internet_gateway.my_vpc_internet_gateway]

    # Tell AWS to assign public IPs to instances deployed within this subnet. 
    # https://bit.ly/2YxggRu
    map_public_ip_on_launch = true 
}


# Create another subnet for the VPC that EC2/RDS instances can deploy within.
# We must have more than one  in order to have multiple availability zones
resource "aws_subnet" "my_vpc_subnet2" {
    vpc_id = aws_vpc.my_vpc.id
    
    # This must be a subnet of the cidr_block specified in "my_vpc"
    cidr_block = "10.0.1.0/24" 
    
    availability_zone_id = "${var.availability_zone_prefix}-az2"

    # Ensure the internet gateway is already up.
    depends_on = [aws_internet_gateway.my_vpc_internet_gateway]

    # Tell AWS to assign public IPs to instances deployed within this subnet. 
    # https://bit.ly/2YxggRu
    map_public_ip_on_launch = true 
}

# Create another subnet for the VPC that EC2/RDS instances can deploy within.
# We must have more than one  in order to have multiple availability zones
resource "aws_subnet" "my_vpc_subnet3" {
    vpc_id = aws_vpc.my_vpc.id
    
    # This must be a subnet of the cidr_block specified in "my_vpc"
    cidr_block = "10.0.2.0/24" 
    
    availability_zone_id = "${var.availability_zone_prefix}-az3"

    # Ensure the internet gateway is already up.
    depends_on = [aws_internet_gateway.my_vpc_internet_gateway]

    # Tell AWS to assign public IPs to instances deployed within this subnet. 
    # https://bit.ly/2YxggRu
    map_public_ip_on_launch = true 
}


// Set the default routing table for the VPC to route through the internet.
resource "aws_default_route_table" "my_routing_table" {
    default_route_table_id = aws_vpc.my_vpc.default_route_table_id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.my_vpc_internet_gateway.id
    }
    
    tags = {
        Name = "myRoutingTable"
    }
}


resource "aws_security_group" "my_vpc_security_group" {
    name        = "allow_internet_to_postgresql"
    description = "Allows internet access to RDS instance on 5432"
    vpc_id      = aws_vpc.my_vpc.id

    ingress {
        description      = "Public access to PostgreSQL"
        from_port        = 5432
        to_port          = 5432
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }

    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }

    tags = {
        Name = "allow_postgresql"
    }
}
