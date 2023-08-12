This example demonstrates how we can use Terraform to manage the creation of
databases, users, and even extensions on a PostgreSQL host.

The example provides a *docker-compose.yaml* file for spinning up an example
database to test with. However, bear in mind that you will need to specify
your computer's IP address, rather than localhost or 127.0.0.1 to connect
to the database if you use this.

Also, it is worth noting that if you use this with an RDS host, you will need
to change `superuser` value to `false` in `main.tf` in the provider clause.

The documentation for the provider being demonstrated can be found 
[here](https://registry.terraform.io/providers/cyrilgdn/postgresql/latest/docs).


## Usage

1. Remove the `.example` extension from the *terraform.tfvars.example* and *.env.example* files
and fill in their values appropriately.
2. Spin up a PostgreSQL host using docker with `docker-compose up -d`
3. Run `terraform init` to intialize Terraform.
4. Run `terraform apply` to have Terraform create a new user and database.
5. Test by connecting to the database with the new user credentials.