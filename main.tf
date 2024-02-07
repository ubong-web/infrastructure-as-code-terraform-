terraform {
  required_providers {
    aws ={
        version = "~> 4.16"
        source = "hashicorp/aws"
    }
  }
  

}


# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}
