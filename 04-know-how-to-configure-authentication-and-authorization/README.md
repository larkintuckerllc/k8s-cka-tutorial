# Security: Know How to Configure Authentication and Authorization

Back to [Certified Kubernetes Administrator (CKA) Tutorial](https://github.com/larkintuckerllc/k8s-cka-tutorial)

[![Security: Know How to Configure Authenication and Authorization](http://img.youtube.com/vi/XXX/0.jpg)](XXX)

## Script

First, will acknowledge that authentication and authorization is usually a complicated topic; Kubernetes is no different. Also, will mention that most tutorials that I have seen introduce this topic at the end; here we do it early.

As a pre-requisite, it will be useful to already have a basic understanding how digital certificates work; [How do Digital Certificates Work - An Overview](https://www.jscape.com/blog/an-overview-of-how-digital-certificates-work).

We will also first explore the topic using the cluster we created with *kubeadm*; later will explore it using the Elastic Kubernetes Service (EKS) cluster.

As we can see, controlling access to the Kubernetes API has three steps:

1. Authentication: Who are they

2. Authorization: What can they do

3. Admission Control: Additional logic to mutate and validate the API call

![Access Control Overview](access-control-overview.svg)

*-Kubernetes-[Controlling Access to the Kubernetes API](https://kubernetes.io/docs/reference/access-authn-authz/controlling-access/)*

### Sidebar into Transport Security

> In a typical Kubernetes cluster, the API serves on port 6443. The API server presents a certificate. This certificate is often self-signed, so $USER/.kube/config on the user’s machine typically contains the root certificate for the API server’s certificate, which when specified is used in place of the system default root certificate. This certificate is typically automatically written into your $USER/.kube/config when you create a cluster yourself using kube-up.sh. If the cluster has multiple users, then the creator needs to share the certificate with other users.

*-Kubernetes-[Controlling Access to the Kubernetes API](https://kubernetes.io/docs/reference/access-authn-authz/controlling-access/)*

Indeed, observe that the K8s controller manager CA certificate is what *kubectl* uses to validate the *kube-apiserver* certificate.

```plaintext
cat .kube/config

cat /etc/kubernetes/pki/ca.crt

grep -e certificate-authority-data .kube/config | \
  cut -d" " -f6 | \
  base64 -d
```

We can see what DNS names / IP addresses are associated with the *kube-apiserver* certificate. Needs to match up with the server used by *kubectl*.

```plaintext
openssl x509 -in /etc/kubernetes/pki/apiserver.crt -noout -text

cat .kube/config
```

### Authentication Concepts

> Normal users are assumed to be managed by an outside, independent service. An admin distributing private keys, a user store like Keystone or Google Accounts, even a file with a list of usernames and passwords. In this regard, Kubernetes does not have objects which represent normal user accounts. Normal users cannot be added to a cluster through an API call.

*-Kubernetes-[Authenticating](https://kubernetes.io/docs/reference/access-authn-authz/authentication/)*

**note:** Related to users are Service Accounts; will talk about them later.

> Authentication modules include Client Certificates, Password, and Plain Tokens, Bootstrap Tokens, and JWT Tokens (used for service accounts).
> Multiple authentication modules can be specified, in which case each one is tried in sequence, until one of them succeeds.

*-Kubernetes-[Controlling Access to the Kubernetes API](https://kubernetes.io/docs/reference/access-authn-authz/controlling-access/)*

Here we will only focus on Client Certificate authentication.

### Client Certificate Authentication

> Client certificate authentication is enabled by passing the --client-ca-file=SOMEFILE option to API server. The referenced file must contain one or more certificate authorities to use to validate client certificates presented to the API server. If a client certificate is presented and verified, the common name of the subject is used as the user name for the request.

*-Kubernetes-[Authenticating](https://kubernetes.io/docs/reference/access-authn-authz/authentication/)*

```plaintext
kubectl describe pod/kube-apiserver-ip-172-31-47-139 -n kube-system
```

We see that the installed client certificate authenticates to user *kubernetes-admin* and group *system:masters*.

```plaintext
cat ./kube/config

grep -e client-certificate-data .kube/config | \
  cut -d" " -f6 | \
  base64 -d | \
  openssl x509 -noout -text
```

### Sidebar into User Authorization

Default behavior is to use Role Based Access Control (RBAC):

```plaintext
kubectl describe pod/kube-apiserver-ip-172-31-47-139 -n kube-system
```

Without getting into the details now, we can see that being in the group *system:masters* grants us full access to the sytem.

One key understanding is that RBAC authorization is additive; i.e., start with no access and then add access (no remove access). 

```plaintext
kubectl describe ClusterRoleBinding | less

kubectl describe ClusterRole cluster-admin
```

### Granting Access to Another Cluster Administrator

**note:** These steps were courtesy of [Granting User Access to Your Kubernetes Cluster](https://www.openlogic.com/blog/granting-user-access-your-kubernetes-cluster).

Create a private key and CSR (public key wrapped in a request):

```plaintext
openssl req -new -newkey rsa:4096 -nodes -keyout fred.administrator.key -out fred.administrator.csr -subj "/CN=fred.administrator/O=system:masters"
```

Encode CSR:

```plaintext
cat fred.administrator.csr | base64 | tr -d "\n"
```

Configuration file to submit the CSR; adding the encoded CSR:

```plaintext
apiVersion: certificates.k8s.io/v1beta1
kind: CertificateSigningRequest
metadata:
  name: fred.administrator
spec:
  groups:
  - system:authenticated
  request: XXXXX
  usages:
  - client auth
```

Submit the CSR:

```plaintext
kubectl -f fred.administrator.yaml
```

**note:** This process uses a general pattern for interacting with the K8s API; will explain later.

Indeed we can observe the created CSR:

```plaintext
kubectl get csr

kubectl describe csr fred.administrator
```

We approve the CSR; essentially granting access:

```plaintext
kubectl certificate approve fred.administrator
```

We download the certificate:

```plaintext
kubectl get csr fred.administrator -o jsonpath='{.status.certificate}' | base64 --decode > fred.administrator.crt
```

We encode both the certificate and private key:

```plaintext
cat fred.administrator.crt | base64 | tr -d "\n"

cat fred.administrator.key | base64 | tr -d "\n"
```

We create entries in the *kubectl* configuration file:

```plaintext
vi .kube/config
```

We test:

```plaintext
kubectl get all --all-namespaces
```
