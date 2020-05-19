# Security: Create and Manage TLS Certificates for Cluster Components

Back to [Certified Kubernetes Administrator (CKA) Tutorial](https://github.com/larkintuckerllc/k8s-cka-tutorial)

**Addendum**: As far as being able to use the alternative names, e.g, *example-dev.default*, there were two problems.  First problem is that the FQDN needs be one of the alternative names (fixed in the *csr.cnf* file). Two, this is a [bug](https://github.com/awslabs/amazon-eks-ami/issues/341) that is resolved in the EKS 1.16 (was doing video in EKS 1.15).

[![Security: Create and Manage TLS Certificates for Cluster Components
](http://img.youtube.com/vi/XRrRSxPqWyk/0.jpg)](https://youtu.be/XRrRSxPqWyk)

## Script

So far we have been using HTTP protocol within our cluster and providing HTTPS protocol outside of our cluster by off-loading TLS to the AWS Load Balancer. What if we wanted to use HTTPS end-to-end (say we are required to do this for compliance reasons)?

We will roughly follow the K8s documentation on this topic:

> Till now we have only accessed the nginx server from within the cluster. Before exposing the Service to the internet, you want to make sure the communication channel is secure.

*-Kubernetes-[Connecting Applications with Services](https://kubernetes.io/docs/concepts/services-networking/connect-applications-service/)*

The following article is also useful:

> Kubernetes provides a certificates.k8s.io API, which lets you provision TLS certificates signed by a Certificate Authority (CA) that you control. These CA and certificates can be used by your workloads to establish trust.

*-Kubernetes-[Manage TLS Certificates in a Cluster](https://kubernetes.io/docs/tasks/tls/managing-tls-in-a-cluster/)*

### Cluster Certificate Authority (CA) Certificate

As the K8s CA is not a root CA that is configured into a browser / OS, we need to obtain it and supply it to our client application. For example, we will be simply using the *curl* CLI and we need to supply a CA certificate using the *--cacert* option:

> (TLS) Tells curl to use the specified certificate file to verify the peer. The file may contain multiple CA certificates. The certificate(s) must be in PEM format. Normally curl is built to use a default file for this, so this option is typically used to alter that default file.

*-Curl-[curl.1 the man page](https://curl.haxx.se/docs/manpage.html)*

We obtain the CA certificate:

```plaintext
kubectl config view --raw \
  -o jsonpath='{.clusters[0].cluster.certificate-authority-data}' | \
  base64 --decode > \
  ca.crt
```

We create a K8s ConfigMap to deliver it to our client applications:

```plaintext
kubectl create configmap ca \
  --from-file=ca.crt
```

### Create Certificate Signing Request (CSR)

We now need to create a CSR for the domain name for our Service; *example-dev.default.svc.cluster.local* as well as the shorted versions *example-dev.default* and *example*.

We create the private key and CSR:

```plaintext
openssl req \
  -out server.csr \
  -newkey rsa:2048 \
  -nodes \
  -keyout server.key \
  -config csr.cnf
```

### Create, Approve K8s CSR Object

> Generate a CSR yaml blob and send it to the apiserver by running the following command:

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

*-Kubernetes-[Manage TLS Certificates in a Cluster](https://kubernetes.io/docs/tasks/tls/managing-tls-in-a-cluster/)*

Approve the CSR:

```plaintext
kubectl certificate approve example-dev.default
```

### TLS Certificate

We first download the certificate:

```plaintext
kubectl get csr example-dev.default -o jsonpath='{.status.certificate}' | base64 --decode > server.crt
```

We can look at the contents of the certificate (notice expiration):

```plaintext
openssl x509 -in server.crt -text -noout
```

We then store the certificate and private key as a K8s Secret:

```plaintext
kubectl create secret tls example-dev \
  --key server.key \
  --cert server.crt
```

**note:** We will talk about secrets in more detail later; just think of them as obscured ConfigMaps for now.

### Server Configuration

> To configure an HTTPS server, the ssl parameter must be enabled on listening sockets in the server block, and the locations of the server certificate and private key files should be specified

*-NGINX-[Configuring HTTPS Servers](https://nginx.org/en/docs/http/configuring_https_servers.html)*

Starting from the original *default.conf* create an updated configuration.

```plaintext
kubectl create configmap example-dev \
  --from-file=default.conf
```

### Install Client / Server and Validate

```plaintext
helm install dev cert
```

Validate insecure HTTPS using *curl*:

```plaintext
curl -k https://example-dev.default.svc.cluster.local
```

Validate secure HTTPS using *curl*:

```plaintext
curl --cacert /cert/ca.crt https://example-dev.default.svc.cluster.local
```

### LoadBalancer

Because we used a LoadBalancer for the service, we finish by pointing a DNS name to it.

### Sidebar Into K8s Public Key Infrastructure (PKI)

The first example of K8s PKI we used was when we created client certificates to authenticate users (when we were using our own K8s Cluster). Again, we don't use this approach for EKS.

The second example of K8s PKI is this example of a server certificate.

Under the hood, however, Kubernetes uses PKI for a number of operations, e.g.,:

> Kubernetes requires PKI for the following operations:

* Client certificates for the kubelet to authenticate to the API server

* Server certificate for the API server endpoint

* AND MORE...

*-Kubernetes-[PKI certificates and requirements](https://kubernetes.io/docs/setup/best-practices/certificates/)*

As with our certificates, these expire in a year and need to be renewed.  The good news is:

> kubeadm renews all the certificates during control plane upgrade.
> This feature is designed for addressing the simplest use cases; if you don’t have specific requirements on certificate renewal and perform Kubernetes version upgrades regularly (less than 1 year in between each upgrade), kubeadm will take care of keeping your cluster up to date and reasonably secure.

*-Kubernetes-[Certificate Management with kubeadm](https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-certs/)*

If the cluster was installed using the *kubeadm* command, then one can use *kubeadm alpha certs renew* to renew all the certificates at any time.

**note:** In the case of EKS, it seems like the approach will be to follow the recommendation of upgrading cluster on a regular (less than 1 year) cycle.
