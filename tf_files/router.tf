
#https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router


resource "google_compute_router" "router" {
  name    = "router"
  region  = "us-central1" /* Same region where we created the subnet*/
  network = google_compute_network.main.id
}