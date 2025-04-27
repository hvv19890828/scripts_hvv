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

resource "kubernetes_namespace" "istio_ingress" {
  metadata {
    labels = {
      sys-component = "istio"
    }
    name = "istio-ingress"
  }
}

resource "helm_release" "hvv_istio_ingress_gateway" {
  name              = "hvv-istio-ingress-gateway"
  chart             = "${path.module}/charts/hvv-istio-ingress-gateway"
  namespace         = kubernetes_namespace.istio_ingress.metadata.0.name
  dependency_update = true
  values = [templatefile("${path.module}/charts/hvv-istio-ingress-gateway/values/helm-values.yaml", {
    # key   = value,
    # key   = value
  })]

  depends_on = [
    helm_release.istiod,
    helm_release.hvv_metallb,
    helm_release.cert_manager_preferences
  ]
}
###########

#resource "helm_release" "hvv_csi_driver_smb" {
#  name              = "hvv-csi-driver-smb"
#  chart             = "${path.module}/charts/hvv-csi-driver-smb"
#  namespace         = "kube-system"
#  dependency_update = true
#  values = [templatefile("${path.module}/charts/hvv-csi-driver-smb/values/helm-values.yaml", {
#    #    key   = value,
#    #    key   = value
#  })]
#  depends_on = [
#    helm_release.sealed_secrets
#  ]
#}

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

resource "helm_release" "hvv-vault" {
  name  = "hvv-vault"
  chart = "${path.module}/charts/hvv-vault"
  values = [templatefile("${path.module}/charts/hvv-vault/values/helm-values.yaml", {
    #    key   = value,
    #    key   = value
  })]
  depends_on = [
    helm_release.sealed_secrets
  ]
}

resource "helm_release" "minio" {
  name             = "minio"
  repository       = "https://charts.min.io"
  chart            = "minio"
  version          = "5.4.0"
  namespace        = "minio"
  create_namespace = true
  values = [templatefile("${path.module}/charts/minio/values/helm-values.yaml", {
    #    key   = value,
    #    key   = value
  })]
  depends_on = [
    helm_release.hvv-vault
  ]
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
    helm_release.cert_manager,
    kubernetes_namespace.istio_ingress
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

# Monitoring
resource "helm_release" "prometheus_operator" {
  name             = "prometheus-operator"
  chart            = "kube-prometheus-stack"
  repository       = "https://prometheus-community.github.io/helm-charts"
  namespace        = "prometheus"
  create_namespace = true
  version          = "48.2.1"
  cleanup_on_fail  = true

  values = [templatefile("${path.module}/charts/prometheus-operator/config/helm-values.yaml", {
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

########

# Logging
resource "helm_release" "grafana_loki" {
  name             = "grafana-loki"
  chart            = "loki"
  repository       = "https://grafana.github.io/helm-charts"
  namespace        = "logging"
  create_namespace = true
  version          = "6.29.0"
  cleanup_on_fail  = true
  values = [templatefile("${path.module}/charts/grafana-loki/values/helm-values.yaml", {
    #    key   = value,
    #    key   = value
  })]
  depends_on = [
    helm_release.minio
  ]
}
########

# CI/CD
resource "helm_release" "jenkins" {
  name             = "jenkins"
  chart            = "jenkins"
  repository       = "https://charts.jenkins.io"
  namespace        = "cicd"
  create_namespace = true
  version          = "5.8.36"
  cleanup_on_fail  = true

  values = [templatefile("${path.module}/charts/jenkins/values/helm-values.yaml", {
    #    key   = value,
    #    key   = value
  })]
  depends_on = [
    helm_release.hvv-vault
  ]
}
########
