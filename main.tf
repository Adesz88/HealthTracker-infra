terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.0"
    }
  }
}

resource "docker_network" "infra_network" {
  name = "health-tracker-network"
  driver = "bridge"
  ipam_config {
    subnet = "172.60.0.0/16"
    gateway = "172.60.0.1"
  }
  internal = false
}

module "jenkins" {
  source = "./modules/jenkins"
}

module "proxy" {
  source = "./modules/proxy"

  depends_on = [docker_network.infra_network]
}

module "mongodb" {
  source = "./modules/mongodb"

  depends_on = [docker_network.infra_network]
}

module "zabbix" {
  source = "./modules/zabbix"
  
  network = "health-tracker-network"
  mysql_root_password = var.mysql_root_password
  zabbix_mysql_password = var.zabbix_mysql_password

  depends_on = [docker_network.infra_network]
}

module "graylog" {
  source = "./modules/graylog"
  
  network = "health-tracker-network"
  graylog_password_secret = var.graylog_password_secret
  graylog_root_password_sha2 = var.graylog_root_password_sha2

  depends_on = [docker_network.infra_network]
}
