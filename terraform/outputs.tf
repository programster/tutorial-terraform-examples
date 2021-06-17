# Outputs
# Define all the outputs of information the user needs to know. E.g. the URI of the generated load 
# balancer etc.


# Output the URL of the load balancer we created.
# https://registry.terraform.io/modules/terraform-aws-modules/alb/aws/latest?tab=outputs
output "load_balancer_url" {
    value = aws_lb.my_load_balancer.dns_name
}


# output the IP of the singly deployed server. 
# E.G. the one not managed by an autoscaling group and behind an elastic load balancer)
output "simple_server_ip" {
    value = aws_instance.my_ec2_server.public_ip
}


# output the web port, so you don't forget which port you need to connect to the endpoint and IP on.
output "web_port" {
    value = var.web_port
}