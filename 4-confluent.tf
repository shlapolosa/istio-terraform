# helm repo add confluentinc https://packages.confluent.io/helm  in confluent                                 
# helm repo update -n confluent
# helm upgrade --install confluent-operator confluentinc/confluent-for-kubernetes -n confluent

# resource "helm_release" "confluentinc" {
#   depends_on = [civo_kubernetes_cluster.kubefirst]
#   name = "confluent-operator"

#   repository       = "https://packages.confluent.io/helm"
#   chart            = "confluent-for-kubernetes"
#   namespace        = "confluent"
#   create_namespace = true
#   version          = "0.824.84"

# }

# provider "argocd" {
#   server_addr = "argocd-server:80"
#   username    = "admin"
#   password    = "5eOb2bsHYti5P-j8"
# }
# resource "argocd_application" "kafka" {
#   metadata {
#     name      = "confluent-kafka"
#     namespace = "confluent"
#   }

#   spec {
#     project = "confluent"

#     source {
#       repo_url        = "https://github.com/socrates-kubefirst/argo-gitops.git"
#       path            = "kafka"
#       target_revision = "HEAD"
#     }

#     destination {
#       name      = "in-cluster"
#       namespace = "confluent"
#     }
#     sync_policy {
#       automated = {
#         prune       = true
#         self_heal   = true
#       }
#   }
#   }
# }