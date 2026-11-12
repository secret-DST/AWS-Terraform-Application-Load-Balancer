terraform {
  backend "s3" {
    bucket       = "bucket-demo-backend-via-tf-1"
    key          = "path/to/backend.tfstate"
    region       = "region of choice"
    use_lockfile = true
    encrypt      = true
  }
}

