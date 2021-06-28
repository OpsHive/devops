## Terraforms
installation:
Download the terraform binary for your platform
```
https://www.terraform.io/downloads.html

```
for linux navigate to Download folder and give excuteable permissions


```
# permissions
sudo chmod +x ./terraform_0.15.5_linux_amd64.zip

#unzip downloaded file
unzip ./terraform_0.15.5_linux_amd64.zip

# copy terraform binary on shell

cp ./terraform /usr/local/bin

```
you can build your gcp resource with iac tool terraforms 

create gke cluster with terraforms
create providers.tf for google
nano providers.tf
```
provider "google" {
  # version     = "2.7.0"
  credentials = file(var.credentials)
  project     = var.project
  region      = var.region
}


```
nano main.tf

```

resource "google_container_cluster" "primary" {
  name               = var.cluster
  location           = var.zone
  initial_node_count = 3

  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }



  timeouts {
    create = "30m"
    update = "40m"
  }
}

```
nano variables.tf

```
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

```
nano output.tf

```
output "cluster" {
  value = google_container_cluster.primary.name
}

output "host" {
  value     = google_container_cluster.primary.endpoint
  sensitive = true
}

output "cluster_ca_certificate" {
  value     = base64decode(google_container_cluster.primary.master_auth.0.cluster_ca_certificate)
  sensitive = true
}

output "username" {
  value     = google_container_cluster.primary.master_auth.0.username
  sensitive = true
}

output "password" {
  value     = google_container_cluster.primary.master_auth.0.password
  sensitive = true
}
```

after creating these file you just need to create service account and give them permissions of editor and download service-account.json key file and give path in variables.tf affter that you can create resources 

```
terraform init
terraform plan
terraform apply
terraform destroy

```