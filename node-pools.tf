/*Before we can create node groups for Kubernetes, if we want to follow best practices,
 we need to create a dedicated service account. In this tutorial, 
 we will create two node groups.*/

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account
resource "google_service_account" "kubernetes" {
  account_id = "kubernetes"
}

/*Ce pool contient un nœud non préemptible (c'est-à-dire non interrompu).
Il est configuré pour l'auto-réparation et les mises à jour automatiques.
Utilise le type de machine e2-small et le label role = "general".*/

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_node_pool
resource "google_container_node_pool" "general" {
  name       = "general"
  cluster    = google_container_cluster.primary.id
  node_count = 1

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  node_config {
    preemptible  = false
    machine_type = "e2-small"

    labels = {
      role = "general"
    }

    service_account = google_service_account.kubernetes.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

resource "google_container_node_pool" "spot" {
  name    = "spot"
  cluster = google_container_cluster.primary.id

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  autoscaling {
    min_node_count = 0
    max_node_count = 10
  }

  node_config {
    preemptible  = true
    machine_type = "e2-small"

    labels = {
      team = "devops"
    }

    taint {
      key    = "instance_type"
      value  = "spot"
      effect = "NO_SCHEDULE"
    }

    service_account = google_service_account.kubernetes.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}
/*Ce code Terraform configure un compte de service et deux pools de nœuds pour un cluster Kubernetes GKE :

Compte de service :

Un compte de service kubernetes est créé pour gérer les ressources des nœuds Kubernetes.
Pool de nœuds "general" :

Ce pool contient un nœud non préemptible (c'est-à-dire non interrompu).
Il est configuré pour l'auto-réparation et les mises à jour automatiques.
Utilise le type de machine e2-small et le label role = "general".
Pool de nœuds "spot" :

Ce pool utilise des nœuds préemptibles, donc moins chers mais susceptibles d'être interrompus.
Il peut s’ajuster automatiquement entre 0 et 10 nœuds selon la demande.
Utilise le type de machine e2-small, le label team = "devops", et une taint instance_type = "spot" pour restreindre certains pods.
Les deux pools utilisent le même compte de service et ont les permissions nécessaires pour accéder aux ressources Google Cloud.*/