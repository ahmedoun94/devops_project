#https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster
resource "google_container_cluster" "primary" {
  name                     = "primary"
  location                 = "us-central1-a"
  remove_default_node_pool = true
  initial_node_count       = 1
  network                  = google_compute_network.main.self_link
  subnetwork               = google_compute_subnetwork.private.self_link 
  #logging_service          = "logging.googleapi.com/kubernetes"
  #monitoring_service       = "logging.googleapi.com/kubernetes"  #if you plan to deploy prometheus, you may want to disable it.  
  networking_mode           = "VPC_NATIVE"  
 

  node_locations = ["us-central1-b"]

  
  addons_config {
    http_load_balancing {
      disabled = true
    }

  horizontal_pod_autoscaling {
    disabled = false
    }
  }


  release_channel{
    channel =  "REGULAR"
  }

  workload_identity_config {
    workload_pool = "engaged-parsec-440314-j0.svc.id.goog" #need to replace devops-v4 with your project ID
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = "k8s-pod-range"
    services_secondary_range_name = "k8s-service-range"
  }

  private_cluster_config {
    enable_private_nodes    = true 
    enable_private_endpoint = false 
    master_ipv4_cidr_block  = "172.16.0.0/28" 
  }
 
}
