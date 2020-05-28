# Scheduling: Use Label Selectors to Schedule Pods

Back to [Certified Kubernetes Administrator (CKA) Tutorial](https://github.com/larkintuckerllc/k8s-cka-tutorial)

[![Scheduling: Use Label Selectors to Schedule Pods](http://img.youtube.com/vi/XXXXX/0.jpg)]()

## Script

### QoS

> For a Pod to be given a QoS class of Guaranteed:

and

> Every Container in the Pod must have a memory limit and a memory request, and they must be the same.
Every Container in the Pod must have a CPU limit and a CPU request, and they must be the same.

and

> A Pod is given a QoS class of Burstable if:

and

>The Pod does not meet the criteria for QoS class Guaranteed.
> At least one Container in the Pod has a memory or CPU request.

and

> For a Pod to be given a QoS class of BestEffort, the Containers in the Pod must not have any memory or CPU limits or requests.

-Kubernetes-[Configure Quality of Service for Pods](https://kubernetes.io/docs/tasks/configure-pod-container/quality-service-pod/)

```plaintext
helm install qos
```

### Out of Resource Handling

Let us see how this relates to QoS.

> If the kubelet is unable to reclaim sufficient resource on the node, kubelet begins evicting Pods.

and

> The kubelet ranks Pods for eviction first by whether or not their usage of the starved resource exceeds requests, then by Priority, and then by the consumption of the starved compute resource relative to the Pods’ scheduling requests.

*-Kubernetes-[Configure Out of Resource Handling](https://kubernetes.io/docs/tasks/administer-cluster/out-of-resource/)*

Thinking about this, the result is:

* BestEffort is first to go since they don't have any requests

* Guaranteed generally is never evicted as they cannot exceed their requests

* Burstable are in-between
