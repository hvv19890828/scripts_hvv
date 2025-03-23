# hvv-onprem

 - In case it's a new cluster, you need to create a secret with:

  kubectl create secret generic smbcreds \
  --from-literal username="" \
  --from-literal password=""

  and then from the secret create a sealesecret with:
  
  kubeseal --controller-name=sealed-secrets --controller-namespace=kube-system --format yaml <secret.yaml>sealedsecret.yaml


