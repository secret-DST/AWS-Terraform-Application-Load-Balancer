terraform {
  backend "s3" {
    bucket       = "bucket-demo-backend-via-tf-1"
    key          = "dev/tfbackend.tfstate"
    region       = "eu-west-2"
    use_lockfile = true
    encrypt      = true
  }
}

