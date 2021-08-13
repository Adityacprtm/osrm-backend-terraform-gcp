variable "base_name" {
  description = "Base name of service"
  default     = "osrm-backend"
}

variable "region" {
  description = "Set the region for managed instance and the other environment"
  default     = "asia-southeast2"
}

variable "osrm_startup_script" {
  type    = string
  default = <<EOF
  mv /home/ubuntu/osrm/osrm.service /etc/systemd/system/osrm.service
  chmod 755 /etc/systemd/system/osrm.service
  systemctl start osrm.service
  systemctl enable osrm.service
  systemctl daemon-reload
  systemctl restart datadog-agent
  EOF
}
