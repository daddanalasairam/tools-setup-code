terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket"
    key            = "vault-secrets/terraform.tfstate"
    region         = "us-east-1"
  }
}

provider "vault" {
  address = "https://vault-internal.sairamdevops.online:8200"
  token = var.vault_token
  skip_tls_verify = true
}

variable "vault_token" {}

resource "vault_mount" "roboshop-dev" {
  path = "roboshop-dev"
  type = "kv"
  options = { version = "2" }
  description = "RoboShop Dev Secrets"
}

resource "vault_generic_secret" "frontend" {
  path = "${vault_mount.roboshop-dev.path}/frontend"

  data_json = <<EOT
{
  "catalogue_url":   "http://catalogue-dev.sairamdevops.online:8080/",
  "cart_url":   "http://cart-dev.sairamdevops.online:8080/",
  "user_url":   "http://user-dev.sairamdevops.online:8080/",
  "shipping_url":   "http://shipping-dev.sairamdevops.online:8080/",
  "payment_url":   "http://payment-dev.sairamdevops.online:8080/"
}
EOT
}

resource "vault_generic_secret" "catalogue" {
  path = "${vault_mount.roboshop-dev.path}/catalogue"

  data_json = <<EOT
{
  "MONGO: "true",
   "MONGO_URL" : "mongodb://mongodb-dev.sairamdevops.online:27017/catalogue""
}
EOT
}

resource "vault_generic_secret" "user" {
  path = "${vault_mount.roboshop-dev.path}/user"

  data_json = <<EOT
{
  "MONGO" : "true",
  "REDIS_URL" : 'redis://<redis-dev.sairamdevops.online>:6379',
  "MONGO_URL" : "mongodb://<mongodb-dev.sairamdevops.online>:27017/users"
}
EOT
}

resource "vault_generic_secret" "cart" {
  path = "${vault_mount.roboshop-dev.path}/cart"

  data_json = <<EOT
{
  "REDIS_HOST" : '<redis-dev.sairamdevops.online>',
  "CATALOGUE_HOST" : "<catalogue-dev.sairamdevops.online>"
}
EOT
}

resource "vault_generic_secret" "shipping" {
  path = "${vault_mount.roboshop-dev.path}/shipping"

  data_json = <<EOT
{
  "CART_ENDPOINT" : "cart-dev.sairamdevops.online:8080",
  "DB_HOST" : 'mysql-dev.sairamdevops.online',
 "mysql_root_password" : "Roboshop@1"
}
EOT
}

resource "vault_generic_secret" "payment" {
  path = "${vault_mount.roboshop-dev.path}/payment"

  data_json = <<EOT
{
  "CART_HOST" : "cart-dev.sairamdevops.online",
  "CART_PORT" : '8080',
  "USER_HOST" : "user-dev.sairamdevops.online"
  "USER_PORT" : "8080",
  "AMQP_HOST" : 'rabbitmq-dev.sairamdevops.online',
  "AMQP_USER" : "roboshop",
  "AMQP_PASS" : "roboshop123"
}
EOT
}

resource "vault_generic_secret" "mysql" {
  path = "${vault_mount.roboshop-dev.path}/mysql"

  data_json = <<EOT
{
  "mysql_root_password" : "Roboshop@1"
EOT
}

resource "vault_generic_secret" "rabbitmq" {
  path = "${vault_mount.roboshop-dev.path}/rabbitmq"

  data_json = <<EOT
{
  "user" : "roboshop",
  "password" : "roboshop123"
}
EOT
}