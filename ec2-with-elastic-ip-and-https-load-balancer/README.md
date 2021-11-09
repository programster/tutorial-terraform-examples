This example:

1. deploys a single EC2 server
1. Assigns an elastic IP address to that EC2 server.
1. Deploys a load balancer that listens for HTTPS connections and uses the 
provided certificate ARN (variable)
1. Terminates the SSL connection and forwards on the plain HTTP request to the 
EC2 server.

This example is good for when one is deploying a service, but needs to allow a 
third party to easily update/manage the SSL certificates (swap them out on the 
load balancer through the AWS console). Also by using a single EC2 server with 
an Elastic IP, this may work well with a CI/CD pipeline that expects to deploy 
to a single fixed IP.
