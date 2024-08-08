# helm repo add istio https://istio-release.storage.googleapis.com/charts
# helm repo update
# helm install gateway -n istio-system --create-namespace istio/gateway
resource "helm_release" "gateway" {
  name = "ingressgateway"

  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "gateway"
  namespace        = "istio-system"
  create_namespace = false
  version          = "1.22.3"

  depends_on = [
    helm_release.istio_base,
    helm_release.istiod
  ]
}
