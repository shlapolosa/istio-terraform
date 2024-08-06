terraform {
  
  required_providers {
    argocd = {
      source  = "jojand/argocd"
      version = "2.3.2"
    }
    civo = {
      source = "civo/civo"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.23.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "3.19.0"
    }
  }
}
provider "civo" {
  region = "nyc1"
}

locals {
  cluster_name         = "workload1"
  kube_config_filename = "./kubeconfig"
}

resource "civo_network" "kubefirst" {
  label = local.cluster_name
}

resource "civo_firewall" "kubefirst" {
  depends_on = [civo_network.kubefirst]
  name                 = local.cluster_name
  network_id           = civo_network.kubefirst.id
  create_default_rules = true
}

resource "civo_kubernetes_cluster" "kubefirst" {
  depends_on = [civo_firewall.kubefirst]
  name         = local.cluster_name
  network_id   = civo_network.kubefirst.id
  firewall_id  = civo_firewall.kubefirst.id
  cluster_type = "talos"
  pools {
    label      = local.cluster_name
    size       = "g4s.kube.large"
    node_count = tonumber("3") # tonumber() is used for a string token value
  }
}

resource "local_file" "kubeconfig" {
  depends_on = [civo_kubernetes_cluster.kubefirst]
  content  = civo_kubernetes_cluster.kubefirst.kubeconfig
  filename = local.kube_config_filename
}
