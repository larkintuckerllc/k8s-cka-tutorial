# Security: Secure Persistent Key Value Store

Back to [Certified Kubernetes Administrator (CKA) Tutorial](https://github.com/larkintuckerllc/k8s-cka-tutorial)

[![Security: Secure Persistent Key Value Store](http://img.youtube.com/vi/KjbeicqU844/0.jpg)](https://youtu.be/KjbeicqU844)

## Script

### ConfigMap

```plaintext
helm install dev config-map-environment
```

View ConfigMap.

View logs.

```plaintext
helm install dev config-map-volume
```

View logs.

### Secret

> Kubernetes Secrets let you store and manage sensitive information, such as passwords, OAuth tokens, and ssh keys. Storing confidential information in a Secret is safer and more flexible than putting it verbatim in a Pod definition or in a container image.

*-Kubernetes-[Secrets](https://kubernetes.io/docs/concepts/configuration/secret/)*

```plaintext
helm install dev secret-environment
```

View Secret.

view logs.

Decode Secret. Interesting.

**note:** Notice that the type is *Opaque* but others are different. This is just about validation of the data as seen from the source code.

https://github.com/kubernetes/kubernetes/blob/7693a1d5fe2a35b6e2e205f03ae9b3eddcdabc6b/pkg/apis/core/types.go#L4394-L4478

### Secret Volume

> Inside the container that mounts a secret volume, the secret keys appear as files and the secret values are base64 decoded and stored inside these files.

*-Kubernetes-[Secrets](https://kubernetes.io/docs/concepts/configuration/secret/)*

```plaintext
helm install dev secret-volume
```

> When a secret currently consumed in a volume is updated, projected keys are eventually updated as well. The kubelet checks whether the mounted secret is fresh on every periodic sync.

*-Kubernetes-[Secrets](https://kubernetes.io/docs/concepts/configuration/secret/)*

**note:** K8s does take precautions to limit the risk of exposing secrets; see Secrets link. But still feels weird that Secrets are still just Base64 encoded.

> Posted On: Mar 5, 2020
> You can now use AWS Key Management Service (KMS) keys to provide envelope encryption of Kubernetes secrets stored in Amazon Elastic Kubernetes Service (EKS). Implementing envelope encryption is considered a security best practice for applications that store sensitive data and is part of a defense in depth security strategy.

*-AWS-[Amazon EKS adds envelope encryption for secrets with AWS KMS](https://aws.amazon.com/about-aws/whats-new/2020/03/amazon-eks-adds-envelope-encryption-for-secrets-with-aws-kms/)*
