#https://registry.terraform.io/providers/hashicorp/google/2.20.3/docs/resources/google_project_services
resource "google_project_service" "compute" {
  service="compute.googleapis.com"   
}

resource "google_project_service" "container" {
  service="container.googleapis.com"   
}

#https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network
resource "google_compute_network" "main" {
  name                    = "main"
  routing_mode            = "GLOBAL"
  auto_create_subnetworks = false #(if true, delete the default route to the internet)
  mtu                     = 1460
  
  depends_on = [ 
    google_project_service.compute,
    google_project_service.container
   ]
  
  
}

