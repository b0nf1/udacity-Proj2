terraform {
    backend "s3" {
        bucket = "arbj-tf"
        key = "home/bonfi/ud-tf/.terraform/terraform.tfstate"
        region = "us-east-1"
    }
}
