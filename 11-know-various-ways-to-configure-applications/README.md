# Application Lifecycle Management: Know Various Ways to Configure Applications

Back to [Certified Kubernetes Administrator (CKA) Tutorial](https://github.com/larkintuckerllc/k8s-cka-tutorial)

[![Core Concepts: Understand the Kubernetes API Primitives](http://img.youtube.com/vi/XXXXX/0.jpg)]()

## Script

### Not Scheduled

```plaintext
helm install dev not-scheduled
```

Inspect:

```plaintext
kubectl get pods
kubectl describe pod not-scheduled-dev
kubectl get pod not-scheduled-dev -o yaml
```

### Not Initialized

> A Pod can have multiple containers running apps within it, but it can also have one or more init containers, which are run before the app containers are started.

Init containers are exactly like regular containers, except:

* Init containers always run to completion.

* Each init container must complete successfully before the next one starts.

*-Kubernetes-[Init Containers](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/)*
