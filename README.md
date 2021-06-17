# Tutorial - Terraform Code Build
An example of deploying an EC2 webserver to AWS through terraform. This demonstrates:

* Ability to break up configuration over multiple files
* Ability to deploy EC2 on its own
* Ability to deploy multiple EC2s as part of an autoscaling group and load balancer.
* How to make use of variables.
* The use of a cloud-init configuration to setup EC2 once its deployed (pulling and deploying a Docker image for a webserver).
* Ability to perform variable substitution into the cloud init script.