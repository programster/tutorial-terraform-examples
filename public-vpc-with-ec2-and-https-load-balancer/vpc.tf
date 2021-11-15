// Create our VPC that all the EC2 servers will be within.
resource "aws_vpc" "my_vpc" {
    cidr_block              = "10.0.0.0/16"
    enable_dns_hostnames    = true
    enable_dns_support      = true
    instance_tenancy        = "default"

    tags = {
        Name = var.vpc_name
    }
}


// Create an internet gateway that is connected to the VPC 
resource "aws_internet_gateway" "my_vpc_internet_gateway" {
    vpc_id = aws_vpc.my_vpc.id

    tags = {
        Name = "${var.vpc_name}-internet-gateway"
    }
}


// Create a subnet for the VPC that EC2 instances will deploy within
resource "aws_subnet" "my_vpc_subnet" {
    vpc_id      = aws_vpc.my_vpc.id
    cidr_block  = "10.0.0.0/24" // Must be a subnet of the cidr_block specified in "my_vpc"
    availability_zone_id = var.subnet_1_availability_zone_id

    # Ensure the internet gateway is already up.
    depends_on  = [aws_internet_gateway.my_vpc_internet_gateway]

    // tell AWS to assign public IPs to instances deployed within this subnet. 
    // https://bit.ly/2YxggRu
    map_public_ip_on_launch = true 
}

// Create another subnet for the VPC that EC2 instances can deploy within.
// We must have more than one, so that we can span multiple availability zones
// in order for the load balancer to be happy and deploy
resource "aws_subnet" "my_vpc_subnet2" {
    vpc_id = aws_vpc.my_vpc.id
    cidr_block = "10.0.1.0/24" // Must be a subnet of the cidr_block specified in "my_vpc"
    availability_zone_id = var.subnet_2_availability_zone_id

    # Ensure the internet gateway is already up.
    depends_on = [aws_internet_gateway.my_vpc_internet_gateway]

    // tell AWS to assign public IPs to instances deployed within this subnet. 
    // https://bit.ly/2YxggRu
    map_public_ip_on_launch = true 
}



