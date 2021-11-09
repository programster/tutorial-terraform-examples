// Create our VPC that all the EC2 servers will be within.
resource "aws_vpc" "my_vpc" {
    cidr_block           = "10.0.0.0/16"
    enable_dns_hostnames = true
    enable_dns_support   = true
    instance_tenancy     = "default"

    tags = {
        Name = var.vpc_name
    }
}


// Create a subnet or instances within the VPC
resource "aws_subnet" "my_vpc_subnet" {
    vpc_id      = aws_vpc.my_vpc.id
    cidr_block  = "10.0.0.0/24" // Must be a subnet of the cidr_block specified in "my_vpc"
    depends_on  = [aws_internet_gateway.my_internet_gateway]

    // tell AWS to NOT assign public IPs to instances deployed within this subnet. 
    // https://bit.ly/2YxggRu
    map_public_ip_on_launch = false 
}


// Create an internet gateway that is connected to the VPC
resource "aws_internet_gateway" "my_vpc_internet_gateway" {
    vpc_id = aws_vpc.my_vpc.id

    tags = {
        Name = "My internet gateway"
    }
}


// Create an elastic IP for the gateway to use
resource "aws_eip" "my_nat_elastic_ip" {
    vpc        = true
    depends_on = [aws_internet_gateway.my_vpc_internet_gateway]
}


// Create a gateway into the VPC's subnet that will hold our EC2 servers
resource "aws_nat_gateway" "my_vpc_nat_gateway" {
    allocation_id = aws_eip.my_nat_elastic_ip.id
    subnet_id     = aws_subnet.my_vpc_subnet.id

    tags = {
        Name = "My VPC NAT gateway"
    }

    # To ensure proper ordering, it is recommended to add an explicit dependency
    # on the Internet Gateway for the VPC.
    depends_on = [aws_internet_gateway.my_vpc_internet_gateway]
}



/* Routing table for private subnet */
resource "aws_route_table" "my_routing_table" {
    vpc_id = aws_vpc.my_vpc.id

    tags = {
        Name = "MyVpcRoutingTable"
    }
}


// assosciate the routing table to the VPC subnet.
resource "aws_route_table_association" "my_vpc_routing_table_assosciation" {
    subnet_id      = aws_subnet.my_vpc_subnet
    route_table_id = my_routing_table.id
}


// Create a route
resource "aws_route" "public_nat_gateway" {
    route_table_id         = aws_route_table.my_routing_table.id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id         = aws_nat_gateway.my_nat_gateway.id
}


# Create an elastic IP and assign it to the gateway.
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip
resource "aws_eip" "my_elastic_ip" {
    instance = aws_instance.my_ec2_server.id
    vpc      = true
}


// Create VPC's Default Security Group
resource "aws_security_group" "default" {
    name        = "myVpcDefaultSecurityGroup"
    description = "Default security group to allow inbound/outbound from the VPC"
    vpc_id      = aws_vpc.my_vpc.id
    depends_on  = [aws_vpc.my_vpc]
    
    ingress {
        from_port = "0"
        to_port   = "0"
        protocol  = "-1"
        self      = true
    }
    
    egress {
        from_port = "0"
        to_port   = "0"
        protocol  = "-1"
        self      = "true"
    }

    tags = {
        Name = "My VPC default security group"
    }
}
