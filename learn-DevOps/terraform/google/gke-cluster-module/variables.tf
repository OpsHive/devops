variable "project" {
  default = "qbitflames"
}

variable "region" {
  default = "us-east1"
}

variable "zone" {
  default = "us-east1-d"
}

variable "cluster" {
  default = "qbit-dev"
}

variable "credentials" {
  default = "~/dev/fiver/chandra/changdra-react-app/terraform/gke-cluster-module/creds/service-account.json"
}

variable "kubernetes_min_ver" {
  default = "latest"
}

variable "kubernetes_max_ver" {
  default = "latest"
}
