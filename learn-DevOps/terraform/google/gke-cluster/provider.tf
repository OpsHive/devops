provider "google" {
  credentials = "${file("./creds/service-account.json")}"
  project     = "qbitflames"
  region      = "us-central1"
 }
