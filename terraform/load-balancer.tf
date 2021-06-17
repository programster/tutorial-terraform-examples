# This configuration file takes our system further by deploying an autoscaling group to make sure
# that multiple instances of our webserver are always running, and exposing them through a load 
# balancer. One can use the load balancer as the endpoint for SSL connections as well.
# Note, this does not directly use the aws instance defined in server.tf, but creates new instances
# itself. This is to demonstrate two different possible ways to deploy EC2 servers.


# Create the launch configuration, which specifies how the auto scaling group will deploy EC2 
# instances.
resource "aws_launch_configuration" "my_launch_configuration" {
    image_id        = var.ami
    instance_type   = "t2.micro"
    security_groups = [aws_security_group.my_hello_world_security_group.id]
    user_data       = data.template_file.user_data.rendered

    # When swapping out instances, launch new ones before destroying old ones so there is no
    # downtime. You may need to plan for this if you have database migrations though.
    lifecycle {
        create_before_destroy = true
    }
}


# Get the ID of the subnet for the default VPC
data "aws_subnet_ids" "my_default_subnets" {
    vpc_id = data.aws_vpc.default.id
}


resource "aws_autoscaling_group" "my_auto_scaling_group" {
    launch_configuration = aws_launch_configuration.my_launch_configuration.name
    vpc_zone_identifier = data.aws_subnet_ids.my_default_subnets.ids
    
    # Specify the minimum and maximum number of EC2 instances to maintain.
    min_size = 2
    max_size = 2
    
    tag {
        key = "Name"
        value = "MyAutoscalingGroup"
        propagate_at_launch = true
    }
}