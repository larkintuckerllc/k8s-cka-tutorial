# Application Lifecycle Management: Understand the primitives necessary to create a self-healing application

Back to [Certified Kubernetes Administrator (CKA) Tutorial](https://github.com/larkintuckerllc/k8s-cka-tutorial)

**note:** Includes the following additional topics:

* Application Lifecycle Management: Know how to scale applications

[![Application Lifecycle Management: Understand the primitives necessary to create a self-healing application](http://img.youtube.com/vi/FNNjDbX0UIo/0.jpg)](https://youtu.be/FNNjDbX0UIo)

## Test Preparation: Relevant Kubernetes Documentation

Topics to search for:

* *replicaset*: [ReplicaSet](https://kubernetes.io/docs/concepts/workloads/controllers/replicaset/)

* *horizontal pod autoscaler*: [Horizontal Pod AutoScaler](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/)

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

* Any Pod matching the selector (and not otherwise owned) is aquired by the ReplicaSet, e.g., even existing Pods.  Has to be the same namespace as the RS though

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

Show RS recreating a deleted Pod:

```plaintext
kubectl delete pod XXX
```

Show RS accidentally aquiring a Pod:

```plaintext
helm install dev aquiring
```

Example of scaling ReplicaSet successfullly.

Example of not upgrading Pods in ReplicaSet successfully; i.e., changing Pod template only effects future Pods.  Would have to scale to 0 and scale back up to change out version.

### Horizontal Pod Autoscaler

A little bit of a side bar.

> The Horizontal Pod Autoscaler automatically scales the number of pods in a replication controller, deployment, replica set or stateful set based on observed CPU utilization (or, with custom metrics support, on some other application-provided metrics).

*-Kubernetes-[Horizontal Pod Autoscaler](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/)*

> The HorizontalPodAutoscaler normally fetches metrics from a series of aggregated APIs (metrics.k8s.io, custom.metrics.k8s.io, and external.metrics.k8s.io). The metrics.k8s.io API is usually provided by metrics-server, which needs to be launched separately.

*-Kubernetes-[Horizontal Pod Autoscaler](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/)*

Some observations:

* Implemented as a control loop; managed by kube-controller-manager

* Loop cycle defaults to 15 seconds

* Requires resource requests set for metric; otherwise does nothing

A light touch on resource requests:

> When you specify a Pod, you can optionally specify how much of each resource a Container needs. The most common resources to specify are CPU and memory (RAM); there are others.

*-Kubernetes-[Managing Resources for Containers](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/)*

```plaintext
helm install dev rs-hpa
```

**note:** Could never get HPA to work using documented configuration file.  Ended up using imperative command to create and then examine results.

```plaintext
kubectl get hpa
kubectl describe hpa
```
