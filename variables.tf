variable "mysql_root_password" {
  description = "MySQL root password"
  type        = string
  sensitive   = true
}

variable "zabbix_mysql_password" {
  description = "Zabbix MySQL user password"
  type        = string
  sensitive   = true
}

variable "graylog_password_secret" {
  description = "Graylog password secret"
  type        = string
  sensitive   = true
}

variable "graylog_root_password_sha2" {
  description = "Graylog root password SHA-256 hash"
  type        = string
  sensitive   = true
}