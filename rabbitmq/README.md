This example demonstrates how we can use Terraform/OpenTofu to manage the configuration of a 
RabbitMQ server by setting up a virtual host, a user (with permissions), an exchange, and a queue.
The queue is bound to the exchange, so that all messages that go into the exchange are put into the
queue.

The example provides a *docker-compose.yaml* file for spinning up an example RabbitMQ server to 
test with. However, bear in mind that you will need to specify your computer's IP address, rather 
than localhost or 127.0.0.1 to connect to the database if you use this.


The documentation for the provider being demonstrated can be found 
[here](https://registry.terraform.io/providers/cyrilgdn/rabbitmq/latest/docs).


## Usage

1. Remove the `.example` extension from the *terraform.tfvars.example* and *.env.example* files
and fill in their values appropriately.
2. Spin up a RabbitMQ host using docker with `docker-compose up -d`
3. Run `tofu init` to initialize OpenTofu.
4. Run `tofu apply` to have OpenTofu create a new user and database.
5. Test by connecting to the database with the new user credentials.