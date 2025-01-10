#https://registry.terraform.io/providers/hashicorp/google/latest/docs
provider "google" {
  project     = "engaged-parsec-440314-j0"
  region      = "us-central1"
}




#https://developer.hashicorp.com/terraform/language/backend/gcs
terraform {
  backend "gcs" {
    bucket  = "bucket1-ao"
    prefix  = "terraform/state"
  }
}




