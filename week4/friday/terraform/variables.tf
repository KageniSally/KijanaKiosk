variable "environment" {
  type        = string
  description = "Target deployment lifecycle tier descriptor."
  default     = "staging"
}

variable "server_matrix" {
  type        = map(map(string))
  description = "Configuration data matrix mapping infrastructure targets."
  default = {
    api      = { service_name = "kk-api", port = "2222" }
    payments = { service_name = "kk-payments", port = "3333" }
    logs     = { service_name = "kk-logs", port = "4444" }
  }
}
