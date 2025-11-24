terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.0"
    }
  }
}

resource "docker_container" "jenkins" {
  name = "jenkins"
  image = "jenkins/jenkins:lts"

  ports {
    internal = 8080
    external = 8080
  }

  ports {
    internal = 50000
    external = 50000
  }

  volumes {
    volume_name = "HealthTracker-jenkins"
    container_path = "/var/jenkins_home"
  }

  restart = "unless-stopped"
}
