terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.0"
    }
  }
}

resource "docker_image" "jenkins" {
  name = "jenkins-docker:latest"
  build {
    context    = "."
    dockerfile = "Dockerfile-jenkins"
    tag        = ["jenkins-docker:latest"]
    no_cache   = true
  }
}

resource "docker_container" "jenkins" {
  name = "jenkins"
  image = "jenkins-docker:latest"

  ports {
    internal = 8080
    external = 8080
  }

  ports {
    internal = 50000
    external = 50000
  }

  networks_advanced {
    name = "health-tracker-network"
    aliases = ["jenkins"]
    ipv4_address = "172.60.0.6"
  }

  volumes {
    volume_name = "health-tracker-jenkins"
    container_path = "/var/jenkins_home"
  }

  volumes {
    host_path      = "/var/run/docker.sock"
    container_path = "/var/run/docker.sock"
  }

  restart = "unless-stopped"
}
