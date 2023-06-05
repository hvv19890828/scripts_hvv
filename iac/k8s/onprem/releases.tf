resource "helm_release" "istio_base" {
  name             = "istio-base"
  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "base"
  version          = "1.17.2"
  namespace        = "istio-system"
  create_namespace = true
  #  values = [templatefile("${path.module}/charts/kong/values/helm-values.yaml", {
  #    key   = value,
  #    key   = value
  #  })]
}

resource "helm_release" "istiod" {
  name       = "istiod"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "istiod"
  version    = "1.17.2"
  namespace  = "istio-system"

  #  values = [templatefile("${path.module}/charts/kong/values/helm-values.yaml", {
  #    key   = value,
  #    key   = value
  #  })]

  depends_on = [
    helm_release.istio_base
  ]
}

resource "helm_release" "metrics_server" {
  name             = "metrics-server"
  repository       = "https://kubernetes-sigs.github.io/metrics-server/"
  chart            = "metrics-server"
  version          = "3.10.0"
  namespace        = "metrics-server"
  create_namespace = true
  values = [templatefile("${path.module}/charts/metrics-server/values/helm-values.yaml", {
    #    key   = value,
    #    key   = value
  })]
}

resource "helm_release" "csi_driver_smb" {
  name       = "csi-driver-smb"
  repository = "https://raw.githubusercontent.com/kubernetes-csi/csi-driver-smb/master/charts"
  chart      = "csi-driver-smb"
  version    = "v1.11.0"
  namespace  = "kube-system"
  values = [templatefile("${path.module}/charts/csi-driver-smb/values/helm-values.yaml", {
    #    key   = value,
    #    key   = value
  })]
}

resource "helm_release" "sealed_secrets" {
  name       = "sealed-secrets"
  repository = "https://bitnami-labs.github.io/sealed-secrets"
  chart      = "sealed-secrets"
  version    = "2.9.0"
  namespace  = "kube-system"
  #values = [templatefile("${path.module}/charts/sealed-secrets/values/helm-values.yaml", {
  #    key   = value,
  #    key   = value
  #})]
}
