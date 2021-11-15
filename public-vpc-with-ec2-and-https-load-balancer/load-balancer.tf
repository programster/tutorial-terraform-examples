# This configuration file takes our system further by deploying an autoscaling group to make sure
# that multiple instances of our webserver are always running, and exposing them through a load 
# balancer. One can use the load balancer as the endpoint for SSL connections as well.
# Note, this does not directly use the aws instance defined in server.tf, but creates new instances
# itself. This is to demonstrate two different possible ways to deploy EC2 servers.



# Create a security group for the load balancer to use
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
resource "aws_security_group" "my_load_balancer_security_group" {
    name = "myLoadBalancer"
    vpc_id = aws_vpc.my_vpc.id
    
    # Allow inbound http
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    # allow inbound https
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    # Allow all outbound requests
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}


# Create a target group for the load balancert to target
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group
resource "aws_lb_target_group" "my_load_balancer_target_group" {
    name = "myLoadBalancerTargetGroup"
    port = 80
    protocol = "HTTP"
    vpc_id = aws_vpc.my_vpc.id
    
    health_check {
        path = "/"
        protocol = "HTTP"
        matcher = "200"

        # How long to wait between checks
        interval = 15

        # How long to wait for a response to come back when checking status
        # before considering it a failure/unhealthy check.
        timeout = 3

        # These specify the number of checks to pass/fail to be considered
        # health/unhealthy
        healthy_threshold = 2
        unhealthy_threshold = 2
     }
}


# Register the EC2 server's elastic IP as part of the target group
resource "aws_lb_target_group_attachment" "my_target_group_attachment" {
    target_group_arn = aws_lb_target_group.my_load_balancer_target_group.arn
    target_id = aws_instance.my_ec2_server.id
    port = 80
}


# Create the load balancer
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb
resource "aws_lb" "my_load_balancer" {
    name = "myHttpLoadBalancer"
    load_balancer_type = "application"
    subnets = [aws_subnet.my_vpc_subnet.id, aws_subnet.my_vpc_subnet2.id]
    security_groups = [aws_security_group.my_load_balancer_security_group.id]
}


# Create a listener on port 80 to redirect the user onto port 443/https
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener
resource "aws_lb_listener" "my_load_balancer_http_listener" {
  load_balancer_arn = aws_lb.my_load_balancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}


# Create a listener on the load balancer so that it listens for HTTPS requests.
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener
resource "aws_lb_listener" "my_load_balancer_https_listener" {
    load_balancer_arn = aws_lb.my_load_balancer.arn
    port = 443
    protocol = "HTTPS"
    ssl_policy = "ELBSecurityPolicy-2016-08"
    certificate_arn = var.certificate_arn
    
    # By default, return a simple 404 page
    default_action {
        type = "fixed-response"
        
        fixed_response {
            content_type = "text/plain"
            message_body = "404: page not found"
            status_code = 404
        }
    }
}


# Add a rule to the listener, configureing it to forward all (*) requests to the target group
# we created earlier and registered our server's elastic IP.
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule
resource "aws_lb_listener_rule" "my_load_balancer_listener_rule" {
    listener_arn = aws_lb_listener.my_load_balancer_https_listener.arn
    priority = 100
    
    condition {
        path_pattern {
            values = ["*"]
        } 
    }
    
    action {
        type = "forward"
        target_group_arn = aws_lb_target_group.my_load_balancer_target_group.arn
    }
}
