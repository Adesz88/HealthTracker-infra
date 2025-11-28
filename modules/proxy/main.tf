terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.0"
    }
  }
}

resource "docker_image" "proxy" {
  name = "health-tracker-proxy:latest"
  build {
    context    = "."
    dockerfile = "Dockerfile-proxy"
    tag        = ["health-tracker-proxy:latest"]
    no_cache   = true
  }
}

resource "docker_container" "proxy" {
  name = "health-tracker-proxy"
  image = docker_image.proxy.image_id

  ports {
    internal = 80
    external = 80
  }

  networks_advanced {
    name = "health-tracker-network"
    ipv4_address = "172.60.0.2"
  }

  restart = "unless-stopped"
}
