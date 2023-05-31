# Define the AWS provider
provider "aws" {
  region = "us-west-1"

  default_tags { # Tagging vars
    tags = {
      project    = "fargate-demo"
      created-by = "terraform"
      owner      = "lautaro-baltar"
    }
  }
}