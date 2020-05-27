# Security: Know How to Configure Authentication and Authorization

Back to [Certified Kubernetes Administrator (CKA) Tutorial](https://github.com/larkintuckerllc/k8s-cka-tutorial)

[![Security: Know How to Configure Authenication and Authorization](http://img.youtube.com/vi/XXXXX/0.jpg)]()

## Script

```plaintext
helm install dev service-account
```

```plaintext
curl -H "Authorization: bearer $(cat /var/run/secrets/kubernetes.io/serviceaccount/token)" --cacert /vr/run/secrets/kubernetes.io/serviceaccount/ca.crt https://kubernetes.default/api/v1/namespaces/default/pods
```
