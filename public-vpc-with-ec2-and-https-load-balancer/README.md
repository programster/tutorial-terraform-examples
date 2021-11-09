This example is pretty much exactly the same as 
"ec2-with-elastic-ip-and-https-load-balancer" except that instead of using the 
default VPC, we are creating a new one.

1. Deploys a VPC
1. deploys a single EC2 server within the VPC
1. Sets up routing tables to forward port 2222 on the public gateway to EC2 SSH port 22
1. Deploys a load balancer that listens for HTTPS connections and uses the provided certificate ARN (variable)
    - Load balancer terminates the SSL connection and forwards on the plain HTTP request to the EC2 server in the private NAT.

This example is good for when one is deploying a service, but needs to allow a 
third party to easily update/manage the SSL certificates (swap them out on the 
load balancer through the AWS console). We set up port forwarding so that
we can still access the EC2 via SSH. This setup requires only one public 
elastic IP, no matter how many EC2 servers one has.

## References
* [medium.com - Terraform — AWS VPC with Private, Public Subnets with NAT](https://medium.com/appgambit/terraform-aws-vpc-with-private-public-subnets-with-nat-4094ad2ab331)
* [Terraform Docs - VPC](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc)
* [Terraform Docs - Elastic IP](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip)