This example demonstrates how we can use Terraform/OpenTofu to manage the configuration of
a freshly deployed Rundeck server using the 
[rundeck/rundeck provider](https://registry.terraform.io/providers/rundeck/rundeck/latest/docs).

The example provides a *docker-compose.yaml* file for spinning up an example rundeck server from 
scratch to test with. You can connect to it on `http://localhost:4440`.



## Usage

1. Remove the `.example` extension from the *terraform.tfvars.example* and *.env.example* files
and fill in their values appropriately.
2. Spin up a MySQL host using docker with `docker-compose up -d`
3. Run `tofu init` to initialize OpenTofu.
4. Run `tofu apply` to have OpenTofu create a new Rundeck project with associated private key etc.
5. Fill in the generated `node-definitions/my-project/nodes.yaml` file with a configuration of one
   of your apt-based servers to have rundeck be able to connect to it and update it. This does 
   require that this server has [password-less sudo access](https://blog.programster.org/ubuntu-giving-users-adminastrative-privileges)
   with the key that you provided in 
   `terraform.tfvars`. Below is an example configuration to give it.
    ```yaml
    node1:
      nodename: node1
      sshport: '22'
      hostname: 192.168.x.y
      description: My ubuntu/debian computer
      tags: apt, ubuntu
      username: myUsernameHere
    ```
6. Test by navigating to http://localhost:4440 in your browser and logging in with the default
   username and password which are both set to: `admin`, going into the project, and running the 
   job.