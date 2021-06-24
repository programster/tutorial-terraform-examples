This example creates an elastic container registry (ECR) and an IAM user with a set of programmatic 
credentials that can be used to pull images from that registry. These credentials will be output.
The credentials could be substituted into a cloud-init configuration template to provide the 
deployed EC2 server with AWS CLI access to the ECR.

In order to view the sensitive outputs, you will need to run the following command afterwards.

```bash
terraform show -json | jq  '.values.outputs'
```
