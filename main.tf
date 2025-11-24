terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.0"
    }
  }
}

resource "docker_network" "infra_network" {
  name = "HealthTracker-network"
  driver = "bridge"
  ipam_config {
    subnet = "172.60.0.0/16"  # Customize subnet as needed
    gateway = "172.60.0.1"
  }
  internal = false
}

module "jenkins" {
  source = "./modules/jenkins"
}

module "mongodb" {
  source = "./modules/mongodb"

  depends_on = [docker_network.infra_network]
}
