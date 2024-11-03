/*The next step is to create a private subnet to place Kubernetes nodes. When you use the GKE cluster, the Kubernetes control plane is managed by Google, 
and you only need to worry about the placement of Kubernetes workers*/

#https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork
resource "google_compute_subnetwork" "private" {
  name          = "private"
  ip_cidr_range = "10.0.0.0/18" #This will give you 16 000 ip addresses to play with
  region        = "us-central1"
  network       = google_compute_network.main.id
  private_ip_google_access = true


/*K8s nodes will use IPs from the main CIDR range, but the K8s pods will use IPs from the
secondary range. In case you need to open a firewall to access other VMs in your VPC from 
K8s you would need to use this secondary ip range as a source and optionally service
account of the K8s nodes. Each secondary IP range has a name associated with it which we will
use in the GKE configuration. */
  secondary_ip_range {
    range_name    = "k8s-pod-range"
    ip_cidr_range = "10.48.0.0/14"
  }

/* The second secondary range will be used to assign IP addresses 
for ClusterIPs in K8s. When you create a regular service in K8s, an IP address will be taken 
from that range  */
    secondary_ip_range {
    range_name    = "k8s-service-range"
    ip_cidr_range = "10.52.0.0/20"
  }
}
