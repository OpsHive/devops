resource "google_container_cluster" "gke-cluster" {
  name               = "qbit-dev"
  network            = "default"
  location               = "asia-south1"
  initial_node_count = 1


}
