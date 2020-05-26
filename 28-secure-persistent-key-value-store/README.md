# Security: Secure Persistent Key Value Store

Back to [Certified Kubernetes Administrator (CKA) Tutorial](https://github.com/larkintuckerllc/k8s-cka-tutorial)

[![Security: Secure Persistent Key Value Store](http://img.youtube.com/vi/XXXXX/0.jpg)]()

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
helm install dev secret
```

*note:* Will address *type* in a bit.

View Secret.

view logs.

Decode Secret. Interesting.

**note:** Notice that the type is *Opaque* but others are different. This is just about validation of the data as seen from the source code.

https://github.com/kubernetes/kubernetes/blob/7693a1d5fe2a35b6e2e205f03ae9b3eddcdabc6b/pkg/apis/core/types.go#L4394-L4478

### Secret Volume

TODO: AWS