###ISTIO###
resource "helm_release" "istio_base" {
  name             = "istio-base"
  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "base"
  version          = "1.17.2"
  namespace        = "istio-system"
  create_namespace = true
  values = [templatefile("${path.module}/charts/istio-base/values/helm-values.yaml", {
    #  key   = value,
    #  key   = value
  })]
}

resource "helm_release" "istiod" {
  name       = "istiod"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "istiod"
  version    = "1.17.2"
  namespace  = "istio-system"

  values = [templatefile("${path.module}/charts/istiod/values/helm-values.yaml", {
    #  key   = value,
    #  key   = value
  })]

  depends_on = [
    helm_release.istio_base
  ]
}

resource "helm_release" "istio_ingress_gateway" {
  name             = "istio-ingress-gateway"
  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "gateway"
  version          = "1.17.2"
  namespace        = "istio-ingress"
  create_namespace = true

  values = [templatefile("${path.module}/charts/istio-ingress-gateway/values/helm-values.yaml", {
    # key   = value,
    # key   = value
  })]

  depends_on = [
    helm_release.istiod,
    helm_release.metallb
  ]
}
###########


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

resource "helm_release" "cert_manager" {
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  version          = "v1.12.2"
  namespace        = "cert-manager"
  create_namespace = true
  values = [templatefile("${path.module}/charts/cert-manager/values/helm-values.yaml", {
    #    key   = value,
    #    key   = value
  })]
}

resource "helm_release" "metallb" {
  name             = "metallb"
  repository       = "https://metallb.github.io/metallb"
  chart            = "metallb"
  version          = "0.13.10"
  namespace        = "metallb-system"
  create_namespace = true
  values = [templatefile("${path.module}/charts/metallb/values/helm-values.yaml", {
    #    key   = value,
    #    key   = value
  })]
}

resource "helm_release" "preferences" {
  name  = "preferences"
  chart = "${path.module}/charts/preferences"
  values = [templatefile("${path.module}/charts/preferences/values/helm-values.yaml", {
    #    key   = value,
    #    key   = value
  })]
  depends_on = [
    helm_release.istio_ingress_gateway,
    helm_release.cert_manager,
    helm_release.sealed_secrets,
    helm_release.csi_driver_smb,
    helm_release.metallb
  ]
}
