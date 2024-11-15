# Before creating VPC in a new GCP project, you need to enable compute API. To create a GKE cluster, you also need to enable container google API.
#https://registry.terraform.io/providers/hashicorp/google/2.20.3/docs/resources/google_project_services
resource "google_project_services" "compute" {
  services="compute.googleapi.com"   
}

resource "google_project_services" "container" {
  services="compute.googleapi.com"   
}

##################################################
#https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network
resource "google_compute_network" "main" {
  name                    = "main"
  routing_mode            = "GLOBAL"
  auto_create_subnetworks = false #(if true, delete the default route to the internet)
  mtu                     = 1460
  
  #We need to explicitly specifiy ressources that need to be created before creating VPC. We need compute and optionally can specify container api
  depends_on = [ 
    google_project_services.compute,
    google_project_services.container
   ]
  
  
}

