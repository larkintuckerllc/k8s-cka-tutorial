# Security: Create and Manage TLS Certificates for Cluster Components

Back to [Certified Kubernetes Administrator (CKA) Tutorial](https://github.com/larkintuckerllc/k8s-cka-tutorial)

[![Security: Create and Manage TLS Certificates for Cluster Components
](http://img.youtube.com/vi/XXXXXX/0.jpg)](XXXXXX)

## Script

So far we have been using HTTP protocol within our cluster and providing HTTPS protocol outside of our cluster by off-loading TLS to the AWS Load Balancer. What if we wanted to use HTTPS end-to-end (say we are required to do this for compliance reasons)?

We will roughly follow the K8s documentation on this topic:

> Till now we have only accessed the nginx server from within the cluster. Before exposing the Service to the internet, you want to make sure the communication channel is secure.

*-Kubernetes-[Connecting Applications with Services](https://kubernetes.io/docs/concepts/services-networking/connect-applications-service/)*

The following article is also useful:

> Kubernetes provides a certificates.k8s.io API, which lets you provision TLS certificates signed by a Certificate Authority (CA) that you control. These CA and certificates can be used by your workloads to establish trust.

*-Kubernetes-[Manage TLS Certificates in a Cluster](https://kubernetes.io/docs/tasks/tls/managing-tls-in-a-cluster/)*

### Create Certificate Signing Request (CSR)

Manually Generate a Certificate Signing Request (CSR) Using OpenSSL

https://www.ssl.com/how-to/manually-generate-a-certificate-signing-request-csr-using-openssl/

```plaintext
openssl genrsa -out server.key 2048
```

```plaintext
openssl req -new -key server.key -out server.csr
```

example-dev.default.svc.cluster.local

### Create, Approve K8s CSR Object

```plaintext
cat <<EOF | kubectl apply -f -
apiVersion: certificates.k8s.io/v1beta1
kind: CertificateSigningRequest
metadata:
  name: example-dev.default
spec:
  request: $(cat server.csr | base64 | tr -d '\n')
  usages:
  - digital signature
  - key encipherment
  - server auth
EOF
```

```plaintext
kubectl get csr
```

kubectl certificate approve example-dev.default

### Create TLS Secret

kubectl get csr example-dev.default -o jsonpath='{.status.certificate}' | base64 --decode > server.crt

```plaintext
kubectl create secret tls example-dev \
  --key server.key \
  --cert server.crt
```

### Secure Server

kubectl create configmap example-dev \
  --from-file=default.conf

### More Stuff

kubectl config view --raw -o jsonpath='{.clusters[0].cluster.certificate-authority-data}' | base64 --decode > ca.crt

kubectl create configmap ca \
  --from-file=ca.crt

curl --cacert /cert/ca.crt https://example-dev.default.svc.cluster.local

### More Shit

