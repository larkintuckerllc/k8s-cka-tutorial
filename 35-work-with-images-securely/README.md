# Security: Work with Images Securely

Back to [Certified Kubernetes Administrator (CKA) Tutorial](https://github.com/larkintuckerllc/k8s-cka-tutorial)

[![Security: Work with Images Securely](http://img.youtube.com/vi/QeAFOMXARqc/0.jpg)](https://youtu.be/QeAFOMXARqc)

## Test Preparation: Relevant Kubernetes Documentation

Search for *imagePullSecrets*  and find:

* [Images](https://kubernetes.io/docs/concepts/containers/images/)

* [Pull an Image from a Private Registry](https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/)

* [Configure Service Accounts for Pods](https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/)

## Script

### Private Registry Solutions

> There are a number of solutions for configuring private registries. Here are some common use cases and suggested solutions.

*-Kubernetes-[Images](https://kubernetes.io/docs/concepts/containers/images/#specifying-imagepullsecrets-on-a-pod)*

#### Non-Proprietary

Cluster running only non-proprietary (e.g. open-source) images. No need to hide images.
Use public images on the Docker hub.

#### Some-Proprietary - Visible to All Cluster Users

Use private registry.

* Docker Hub or Other Registry Provider: Need to provide credentials (below)

* Internal Private Registry: No credentials required

* Cloud, e.g., Credentials managed for you, e.g., Amazon ECR

For managing credentials, can do at the Node-level (does not work with most Cloud providers) or using Secrets (will cover below).

#### Some-Proprietary - Some Limited Access

Use Secrets (will cover below).

Ensure AlwaysPullImages admission controller is active. Otherwise, all Pods potentially have access to all images.

**note**: AWS ECR is automatically open to all users.

**note**: AlwaysPullImages admission controller is not available on EKS.

### Push an Image to a Private Registry

Go to Docker Hub and create repository.

Walk through building and pushing.

```plaintext
docker login

docker build . --tag hello:0.1.0

docker tag hello:0.1.0 sckmkny/hello:0.1.0

docker push sckmkny/hello:0.1.0
```

### Pull an Image from a Private Registry (Pod Level)

Basically a walk-through of the document [Pull an Image from a Private Registry](https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/).

**Addendum**: Should have briefly mentioned that this security section fits into the [4C’s of Cloud Native Security](https://kubernetes.io/docs/concepts/security/).

### Pull an Image from a Private Registry (Service Account Level)

Follow [Add image pull secret to service account](https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/#add-imagepullsecrets-to-a-service-account) to edit *default* ServiceAccount.
