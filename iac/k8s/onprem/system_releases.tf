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

resource "helm_release" "hvv_istio_ingress_gateway" {
  name              = "hvv-istio-ingress-gateway"
  chart             = "${path.module}/charts/hvv-istio-ingress-gateway"
  namespace         = "istio-ingress"
  create_namespace  = true
  dependency_update = true
  values = [templatefile("${path.module}/charts/hvv-istio-ingress-gateway/values/helm-values.yaml", {
    # key   = value,
    # key   = value
  })]

  depends_on = [
    helm_release.istiod,
    helm_release.hvv_metallb
  ]
}
###########


resource "helm_release" "hvv_csi_driver_smb" {
  name              = "hvv-csi-driver-smb"
  chart             = "${path.module}/charts/hvv-csi-driver-smb"
  namespace         = "kube-system"
  dependency_update = true
  values = [templatefile("${path.module}/charts/hvv-csi-driver-smb/values/helm-values.yaml", {
    #    key   = value,
    #    key   = value
  })]
  depends_on = [
    helm_release.sealed_secrets
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

### CERT-MANAGER ###
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

resource "helm_release" "cert_manager_preferences" {
  name  = "cert-manager-preferences"
  chart = "${path.module}/charts/cert-manager-preferences"
  values = [templatefile("${path.module}/charts/cert-manager-preferences/values/helm-values.yaml", {
    #    key   = value,
    #    key   = value
  })]
  depends_on = [
    helm_release.cert_manager
  ]
}
####################

resource "helm_release" "hvv_metallb" {
  name              = "hvv-metallb"
  chart             = "${path.module}/charts/hvv-metallb"
  namespace         = "metallb-system"
  create_namespace  = true
  dependency_update = true
  values = [templatefile("${path.module}/charts/hvv-metallb/values/helm-values.yaml", {
    #    key   = value,
    #    key   = value
  })]
}
