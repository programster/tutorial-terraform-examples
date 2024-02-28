terraform {
    required_providers {
        rabbitmq = {
            source = "cyrilgdn/rabbitmq"
            version = "1.8.0"
        }
    }
}


# Create the MySQL provider with the connection details.
provider "rabbitmq" {
    endpoint = var.rabbitmq_host
    username = var.rabbitmq_master_username
    password = var.rabbitmq_master_password
}


# Create a virtual host for our exchanges and queues.
resource "rabbitmq_vhost" "my_vhost" {
    name = var.new_vhost_name
}


# Create an operator policy to have all messages in our virtual host's queues expire/timeout rather than living forever
# https://registry.terraform.io/providers/cyrilgdn/rabbitmq/latest/docs/resources/operator-policy
# https://www.rabbitmq.com/docs/parameters#policies
resource "rabbitmq_operator_policy" "my_operator_policy" {
    name  = "expiration_policy"
    vhost = rabbitmq_vhost.my_vhost.name

    policy {
        pattern  = ".*"
        priority = 0
        apply_to = "queues"

        definition = {
            # Set the message-ttl so that messages will only live for up to this long in the queue
            # If the sender set a TTL on the message before it went into the queue, the lower of the two values
            # will apply to the message.
            # https://stackoverflow.com/questions/60985922/rabbitmq-difference-between-message-ttl-and-expiration
            message-ttl = 3600000

            # Set the expiry (in milliseconds) for the queues so that they will be deleted if unused for this amount
            # of time. A queue is considered unused if there are no consumers and has not been redeclared. R
            # https://www.rabbitmq.com/docs/ttl#queue-ttl
            expires = 1800000
        }
    }
}


# Create our new user.
resource "rabbitmq_user" "my_user" {
    name        = var.new_user
    password    = var.new_users_password
    tags        = var.new_users_tags
}


# Grant our new user full access to everything on the virtual host we created.
resource "rabbitmq_permissions" "my_user_permissions" {
    user  = rabbitmq_user.my_user.name
    vhost = rabbitmq_vhost.my_vhost.name

    permissions {
        configure = ".*"
        write     = ".*"
        read      = ".*"
    }
}


# Create an exchange
resource "rabbitmq_exchange" "my_exchange" {
    name  = "${var.new_exchange_name}"
    vhost = rabbitmq_vhost.my_vhost.name

    settings {

        # Set the type of the exchange. One of "direct", "topic", "fanout", "headers", "default", "dead-letter".
        # https://rabbitmq-website.pages.dev/tutorials/amqp-concepts#exchanges
        # https://www.cloudamqp.com/blog/part4-rabbitmq-for-beginners-exchanges-routing-keys-bindings.html#exchange-types
        type = "fanout"

        # Set whether the exchange survives server restarts. Default is false.
        durable = true

        # Set whether the exchange will self-delete when all queues have finished using it.
        auto_delete = false
    }
}


# Create a queue
# https://registry.terraform.io/providers/cyrilgdn/rabbitmq/latest/docs/resources/queue
# https://hevodata.com/learn/rabbitmq-queue-types/
resource "rabbitmq_queue" "my_queue" {
    name  = var.new_queue_name
    vhost = rabbitmq_vhost.my_vhost.name

    settings {

        # Set whether the queue survives server restarts. Default is false.
        durable = true

        # Whether the queue will self-delete when all consumers have unsubscribed.
        auto_delete = false

        # Additional key/value settings for the queue. All values will be sent to RabbitMQ as a string.
        # If you require non-string values, use "arguments_json" with a JSON string as its value.
        arguments = {

            # Set the queue type. Possible values are "classic" (which is the default), "quorum", and "stream".
            # quorum - https://www.rabbitmq.com/docs/quorum-queues
            # stream - https://rabbitmq-website.pages.dev/docs/streams
            "x-queue-type" : "classic",
        }
    }
}


# Create a binding to bind our queue to the exchange, so that messages that are put into the exchange are automatically
# put into the queue (because the exchange is of type fanout)
resource "rabbitmq_binding" "my_binding" {
    vhost            = rabbitmq_vhost.my_vhost.name
    source           = rabbitmq_exchange.my_exchange.name

    # Set the destination to our queue. However, one could create a binding that bound an exchange to another
    # exchange.
    destination      = rabbitmq_queue.my_queue.name
    destination_type = "queue"

    # Could set a routing key, but does not apply to us as we are using a fanout exchange.
    # https://www.cloudamqp.com/blog/part4-rabbitmq-for-beginners-exchanges-routing-keys-bindings.html
    #routing_key = "#"
}