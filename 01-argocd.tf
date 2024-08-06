
resource "helm_release" "argocd" {
 depends_on = [civo_kubernetes_cluster.kubefirst]
 name       = "argocd"
 repository = "https://argoproj.github.io/argo-helm"
 chart      = "argo-cd"
 version    = "4.5.2"

 namespace = "argocd"

 create_namespace = true

 set {
   name  = "server.service.type"
   value = "LoadBalancer"
  }

 set {
   name  = "server.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-type"
   value = "nlb"
 }
}

provider "kubernetes" {
  config_path    = "./kubeconfig"
  #config_context = "my-context"
}


data "kubernetes_service" "argocd_server" {
 metadata {
   name      = "argocd-server"
   namespace = helm_release.argocd.namespace
 }
}

output "argocd_server_load_balancer_ip" {
  value = data.kubernetes_service.argocd_server.status[0].load_balancer[0].ingress[0].ip
}

output "argocd_server_load_balancer" {
  value = data.kubernetes_service.argocd_server.status[0].load_balancer[0].ingress[0].hostname
}

output "argocd_initial_admin_username" {
  value = "admin"
}

output "argocd_initial_admin_secret" {
  value = "kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath=\"{.data.password}\" | base64 -d"
}