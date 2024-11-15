

#https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router_nat
resource "google_compute_router_nat" "nat" {
  name                               = "nat"
  router                             = google_compute_router.router.name
  region                             = "us-central1"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS" #Only the ones we defined (seuls certains sous-réseaux (LIST_OF_SUBNETWORKS) auront accès au NAT.)
  nat_ip_allocate_option             = "MANUAL_ONLY" #Le NAT utilise une IP externe allouée manuellement.

#Configuration des Sous-Réseaux
/*Ce bloc sélectionne un sous-réseau (google_compute_subnetwork.subnet) pour le NAT.
ALL_IP_RANGES signifie que toutes les IP de ce sous-réseau peuvent accéder au NAT.*/
  subnetwork {
    name                    = google_compute_subnetwork.subnet.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }

/*Le NAT utilise une IP externe spécifique (google_compute_address.nat),
ce qui est pratique pour une IP stable et contrôlée.*/
  nat_ips = [google_compute_address.nat.self_link]
}



/*Création de l'IP Externe
Cette ressource crée une adresse IP externe pour le NAT.
Le depends_on assure que l'API Compute Engine est activée avant de créer l'IP.*/

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_address
resource "google_compute_address" "nat" {
  name         = "nat"
  address_type = "EXTERNAL"
  network_tier = "PREMIUM"

  depends_on = [google_project_service.compute]
}


/*En résumé, ce code permet aux ressources privées d'un sous-réseau d'accéder à Internet en 
utilisant une adresse IP NAT partagée, tout en gardant leurs adresses privées sécurisées.*/