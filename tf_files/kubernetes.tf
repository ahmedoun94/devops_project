#https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster
resource "google_container_cluster" "primary" {
  name                     = "primary"
  location                 = "us-central1-a"
  remove_default_node_pool = true
  initial_node_count       = 1
  network                  = google_compute_network.main.self_link
  subnetwork               = google_compute_subnetwork.private.self_link 
  #logging_service          = "logging.googleapi.com/kubernetes"
  #monitoring_service       = "logging.googleapi.com/kubernetes"  if you plan to deploy prometheus, you may want to disable it.  
  networking_mode           = "VPC_NATIVE"  #VPC_NATIVE enables IP aliasing
  
  /*If you create a zonal cluster, we want to add at least one availability zone.
  We already have us-central1-a let's add b zone*/

  node_locations = ["us-central1-b"]

  /*Here you can enable or disable addons. For example, you can deploy istio service mesh or
  disable http_load_balancing if you are planning to use nginx ingress or plain load 
  balancers to expose your services from kubernetes. I will deploy nginx ingress controller
  so i disable this addon.*/
  
  addons_config {
    http_load_balancing {
      disabled = true
    }

  horizontal_pod_autoscaling {
    disabled = false #keep this addon enabled
    }
  }

/*Manage k8s cluster upgrades. We never be able to completely disable upgrades for the k8s
control plane, owever you can disable it for nodes. */
  release_channel{
    channel =  "REGULAR" /*Multiple per month upgrade cadence; 
    Production users who need features not yet offered in the Stable channel.*/
  }

  workload_identity_config {
    workload_pool = "devops-v4.svc.id.goog" #need to replace devops-v4 with your project ID
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = "k8s-pod-range"
    services_secondary_range_name = "k8s-service-range"
  }

  private_cluster_config {
    enable_private_nodes    = true # This will only use private IP addresses from 
    enable_private_endpoint = false /*If you have a VPN setup or you use bastion host to connect
    to the k8s cluster we set this option to true otherwise keep it false to be able to access GKE from your computer*/
    master_ipv4_cidr_block  = "172.16.0.0/28" /*CIDR range for the control plane since it's managed by google, they will 
    create a control plane in their network and establis a peering connection to your vpc*/

  }
    /*Optionally you can specify the CIDR ranges which can access the kubernetes cluster.
    the typical use case is to enable Jenkins to access your GKE*/
  #   Jenkins use case
  #   master_authorized_networks_config {
  #     cidr_blocks {
  #       cidr_block   = "10.0.0.0/18"
  #       display_name = "private-subnet-w-jenkins"
  #     }
  #   }
}
