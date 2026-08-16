terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.30"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_namespace" "kijani_staging" {
  metadata {
    name = "kijani-staging"

    labels = {
      environment = "staging"
      application = "kijanakiosk"
      managed-by  = "terraform"
    }
  }
}
