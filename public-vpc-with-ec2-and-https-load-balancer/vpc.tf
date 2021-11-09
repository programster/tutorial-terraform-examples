// Create our VPC that all the EC2 servers will be within.
resource "aws_vpc" "my_vpc" {
    cidr_block       = "10.0.0.0/16"
    enable_dns_hostnames = true
    enable_dns_support   = true
    instance_tenancy = "default"

    tags = {
        Name = var.vpc_name
    }
}

// Create an internet gateway that is connected to the VPC 
resource "aws_internet_gateway" "my_vpc_internet_gateway" {
    vpc_id = "${aws_vpc.my_vpc.id}"

    tags = {
        Name = "${var.vpc_name}-internet-gateway"
    }
}

// Create a subnet or instances within the VPC
resource "aws_subnet" "my_vpc_subnet" {
    vpc_id                  = aws_vpc.my_vpc.id
    cidr_block              = "10.0.0.0/24" // Must be a subnet of the cidr_block specified in "my_vpc"
    depends_on = [aws_internet_gateway.gw]

    // tell AWS to assign public IPs to instances deployed within this subnet. 
    // https://bit.ly/2YxggRu
    map_public_ip_on_launch = true 
}


/* Routing table for private subnet */
resource "aws_route_table" "my_routing_table" {
    vpc_id = "${aws_vpc.my_vpc.id}"

    tags = {
        Name        = "${var.environment}-private-route-table"
        Environment = "${var.environment}"
    }
}


// Create a route
resource "aws_route" "private_nat_gateway" {
    route_table_id         = "${aws_route_table.my_routing_table.id}"
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id         = "${aws_nat_gateway.my_nat_gateway.id}"
}


// assosciate the routing table to the VPC subnet.
resource "aws_route_table_association" "my_vpc_routing_table_assosciation" {
  count          = "${length(var.private_subnets_cidr)}"
  subnet_id      = "${element(aws_subnet.private_subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.private.id}"
}


# Create an elastic IP and assign it to the gateway.
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip
resource "aws_eip" "my_elastic_ip" {
    instance = aws_instance.my_ec2_server.id
    vpc      = true
}
