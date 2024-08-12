terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "5.62.0"
    }
  }
}

provider "aws" {
    region = "ap-south-1"
    secret_key = ""
    access_key = "" 
}