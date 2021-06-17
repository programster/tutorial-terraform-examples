# Tutorial - Terraform Code Build
An example of deploying an EC2 webserver to AWS through terraform. This demonstrates:

* Ability to break up configuration over multiple files
* Ability to deploy EC2 on its own
* Ability to deploy multiple EC2s as part of an autoscaling group and load balancer.
* How to make use of variables.
* The use of a cloud-init configuration to setup EC2 once its deployed (pulling and deploying a Docker image for a webserver).
* Ability to perform variable substitution into the cloud init script.


## Instructions
1. Checkout the code

2. Copy the `terraform.tfvars.example` file to `terraform.tfvars` and plug in your public SSH key.

3. Create an IAM user that has full access to the EC2 service, and run the following command to provide terraform with the credentials to use:

```bash
export AWS_ACCESS_KEY_ID=xxx
export AWS_SECRET_ACCESS_KEY=xxx
```

4. Run `terraform init` from inside the `/terraform` directory

5. Run `terraform plan` to have Terraform check everything is good and tell you what it intends to do.

6. Run `terraform apply` to have Terraform perform the deployment (you will have to confirm by typing `yes`).

7. Wait for Terraform to deploy, and look at the results in the web console.

8. Check that you can hit the deployed EC2 server using the web_port specified (defualt of 8080).

9. Run `terraform destroy` to spin everything down again.


## Misc
Initially, I used t2.micro instances for this, but they deploy so slowly that it makes it appear that
this doesn't work. Changing to a t3a.micro instance makes a HUGE difference, and still only
costs pennies if you destroy everything (``terraform destroy`) within minutes.