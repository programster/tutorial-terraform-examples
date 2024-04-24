This example extends the base rundeck example by demonstrating how one can pass Rundeck secrets
to the inline scripts, as well as any custom data that you add to the nodes in the node definitions
file.

## Usage

1. Remove the `.example` extension from the *terraform.tfvars.example* and *.env.example* files
and fill in their values appropriately.
2. Spin up a MySQL host using docker with `docker-compose up -d`
3. Run `tofu init` to initialize OpenTofu.
4. Run `tofu apply` to have OpenTofu create a new Rundeck project with associated private key etc.
5. Fill in the generated `node-definitions/my-project/nodes.yaml` file with a configuration of one
   of your apt-based servers to have rundeck be able to connect to it . This does 
   require that this server can be accessed with the key that you provided in 
   `terraform.tfvars`. Below is an example configuration to give it.
    ```yaml
    node1:
      nodename: node1
      sshport: '22'
      hostname: 192.168.x.y
      description: My ubuntu/debian computer
      tags: apt, ubuntu
      username: myUsernameHere
      myCustomVariable: myCustomVariablesValue
    ```
6. Test by navigating to http://localhost:4440 in your browser and logging in with the default
   username and password which are both set to: `admin`, going into the project, and running the 
   job.
7. You should see both the node's custom data point value, and the secret password that was 
   added to rundeck.