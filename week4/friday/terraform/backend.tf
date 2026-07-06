terraform {
  backend "s3" {
    bucket         = "kijanikiosk-tfstate"
    key            = "week4/friday/terraform.tfstate"
    region         = "us-east-1"

    encrypt        = true

    dynamodb_table = "terraform-state-lock"

    use_lockfile = true
  }
}
