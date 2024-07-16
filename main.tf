provider "google" {
  project = "windy-gearbox-429117-n2"
  region  = "us-central1"
  zone    = "us-central1-a"
}

resource "google_app_engine_application" "app" {
  project     = "windy-gearbox-429117-n2"
  location_id = "us-central"
}

resource "google_firestore_database" "database" {
  project     = "windy-gearbox-429117-n2"
  name        = "hello-world"
  location_id = "nam5"
  type        = "FIRESTORE_NATIVE"
}