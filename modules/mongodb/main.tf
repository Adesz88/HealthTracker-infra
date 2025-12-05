terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.0"
    }
  }
}

resource "docker_container" "mongodb" {
  name = "health-tracker-mongodb"
  image = "mongo:latest"

  ports {
    internal = 27017
    external = 6000
  }

  networks_advanced {
    name = "health-tracker-network"
    ipv4_address = "172.60.0.3"
  }

  restart = "unless-stopped"
}

resource "docker_container" "db-init" {
  name = "health-tracker-db-init"
  image = "ghcr.io/adesz88/health-tracker-db-init:latest"

  networks_advanced {
    name = "health-tracker-network"
    ipv4_address = "172.60.0.7"
  }

  restart = "no"
  depends_on = [docker_container.mongodb]
}
