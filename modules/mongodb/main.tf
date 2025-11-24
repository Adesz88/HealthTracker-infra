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
    name = "HealthTracker-network"
    ipv4_address = "172.60.0.2"
  }
}
