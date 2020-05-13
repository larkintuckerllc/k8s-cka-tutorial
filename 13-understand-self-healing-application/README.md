# Application Lifecycle Management: Understand the primitives necessary to create a self-healing application

Back to [Certified Kubernetes Administrator (CKA) Tutorial](https://github.com/larkintuckerllc/k8s-cka-tutorial)

* Troubleshoot: Troubleshoot Application Failure

[![Networking: Understand Pod Networking Concepts](http://img.youtube.com/vi/XXXXX/0.jpg)](XXXXX)

## Script

### ReplicaSet

As we learned earlier, Pods are ephemeral, i.e., they can be terminated unexpectedly, e.g., say if a Node goes down (even for maintainence).

Let intoduce the simplest solution to this problem; a ReplicaSet:

> A ReplicaSet’s purpose is to maintain a stable set of replica Pods running at any given time. As such, it is often used to guarantee the availability of a specified number of identical Pods.

*-Kubernetes-[ReplicaSet](https://kubernetes.io/docs/concepts/workloads/controllers/replicaset/)*

> A ReplicaSet is defined with fields, including a selector that specifies how to identify Pods it can acquire, a number of replicas indicating how many Pods it should be maintaining, and a pod template specifying the data of new Pods it should create to meet the number of replicas criteria. A ReplicaSet then fulfills its purpose by creating and deleting Pods as needed to reach the desired number. When a ReplicaSet needs to create new Pods, it uses its Pod template.

*-Kubernetes-[ReplicaSet](https://kubernetes.io/docs/concepts/workloads/controllers/replicaset/)*

Some key observations:

* *ownerReferences* metadata field on Pod references ReplicaSet

* Any Pod matching the selector is aquired by the ReplicaSet, e.g., even existing Pods.  Has to be the same namespace as the RS though

* Deleting a ReplicaSet, by default, will delete all aquired Pods; *--cascade=false* option on delete disables this behavior

**note:** Replaces ReplicationController resource kind.

```plaintext
helm install dev rs
```

Inspect RS:

```plaintext
kubectl get rs
kubectl describe rs
```

Inspect Pods; notice name with suffix:

```plaintext
kubectl get pods
kubectl describe pod XXX
kubectl get pod -o yaml XXX
```

Show RS accidentally aquiring a Pod:

```plaintext
helm install dev aquiring
```

Example of scaling ReplicaSet successfullly.

Example of not upgrading Pods in ReplicaSet successfully; i.e., changing Pod template only effects future Pods.  Would have to scale to 0 and scale back up to change out version.

TODO: HPA
