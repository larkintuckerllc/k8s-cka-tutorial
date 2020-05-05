# Security: Know How to Configure Authenication and Authorization

Back to [Certified Kubernetes Administrator (CKA) Tutorial](https://github.com/larkintuckerllc/k8s-cka-tutorial)

[![Security: Know How to Configure Authenication and Authorization](http://img.youtube.com/vi/XXX/0.jpg)](XXX)

## Script

First, will acknowledge that authentication and authorization is usually a complicated topic; Kubernetes is no different.

Also, it will be useful to already have a basic understanding how digital certificates work; [How do Digital Certificates Work - An Overview](https://www.jscape.com/blog/an-overview-of-how-digital-certificates-work).

We will also first explore the topic using the cluster we created with *kubeadm*; later will explore the Elastic Kubernetes Service (EKS) cluster.

### Certificate Authority

The default *kubadm* installation enables the *kube-controller-manager* as the Certificate Authority, i.e., it can create signed certificates.

> The Kubernetes controller manager provides a default implementation of a signer. To enable it, pass the --cluster-signing-cert-file and --cluster-signing-key-file parameters to the controller manager with paths to your Certificate Authority’s keypair.

*-Kubernetes-[Manage TLS Certificates in a Cluster](https://kubernetes.io/docs/tasks/tls/managing-tls-in-a-cluster/)*

```plaintext
kubectl describe pod kube-controller-manager-ip-172-31-47-139 -n kube-system
```

### Cluster Authentication

Indeed, observe that this CA certificate is what *kubectl* uses to validate the *kube-apiserver* certificate.

```plaintext
cat .kube/config

cat /etc/kubernetes/pki/ca.crt

grep -e certificate-authority-data .kube/config | \
  cut -d" " -f6 | \
  base64 -d
```

We can see what DNS names / IP addresses are associated with the *kube-apiserver* certificate. Needs to match up with the server used by *kubectl*.

```plaintext
kubectl describe pod/kube-apiserver-ip-172-31-47-139 -n kube-system

openssl x509 -in /etc/kubernetes/pki/apiserver.crt -noout -text

cat .kube/config
```

### User Authentication

We that this same CA certificate is what *kube-apiserver* defaults to validate the user certificates.

> Client certificate authentication is enabled by passing the --client-ca-file=SOMEFILE option to API server. The referenced file must contain one or more certificate authorities to use to validate client certificates presented to the API server. If a client certificate is presented and verified, the common name of the subject is used as the user name for the request.

*-Kubernetes-[Authenticating](https://kubernetes.io/docs/reference/access-authn-authz/authentication/)*

```plaintext
kubectl describe pod/kube-apiserver-ip-172-31-47-139 -n kube-system
```

We see that the default client certificate authenticates to user *kubernetes-admin* and group *system:masters*.

```plaintext
grep -e client-certificate-data .kube/config | \
  cut -d" " -f6 | \
  base64 -d | \
  openssl x509 -noout -text
```
