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
output "elastic_ip" {
    value = aws_eip.my_elastic_ip.public_ip
}