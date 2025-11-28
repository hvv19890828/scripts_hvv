# hvv-onprem

 - In case it's a new cluster, you need to create a secret with:

  kubectl create secret generic smbcreds \
  --dry-run=client \
  --from-literal username="" \
  --from-literal password="" \
  -o yaml

  and then create a sealedsecret from the secret with:
  
  kubeseal --controller-name=sealed-secrets --controller-namespace=kube-system --format yaml <secret.yaml>sealedsecret.yaml
