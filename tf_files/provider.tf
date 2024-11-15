/*First of all, we need to declare a terraform provider. 
You can think of it as a library with methods to create and manage infrastructure in a specific environment. In this case, it is a Google Cloud Platform.*/

#https://registry.terraform.io/providers/hashicorp/google/latest/docs
provider "google" {
  project     = "my-project-id"
  region      = "us-central1"
}




/*When you create resources in GCP such as VPC, Terraform needs a way to keep track of them. If you simply apply terraform right now, it will keep all the state locally 
on your computer. It's very hard to collaborate with other team members and easy to accidentally destroy all your infrastructure. You can declare Terraform backend 
to use remote storage instead. Since we're creating infrastructure in GCP, the logical approach would be to use Google Storage Bucket to store Terraform state. 
You need to provide a bucket name and a prefix.*/

#https://developer.hashicorp.com/terraform/language/backend/gcs
terraform {
  backend "gcs" {
    bucket  = "tf-state-prod"
    prefix  = "terraform/state"
  }
}
