output "staging_namespace" {
  description = "KijaniKiosk staging Kubernetes namespace"
  value       = kubernetes_namespace.kijani_staging.metadata[0].name
}
