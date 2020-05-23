# Scheduling: Use Label Selectors to Schedule Pods

Back to [Certified Kubernetes Administrator (CKA) Tutorial](https://github.com/larkintuckerllc/k8s-cka-tutorial)

[![Scheduling: Use Label Selectors to Schedule Pods](http://img.youtube.com/vi/XXXXX/0.jpg)]()

## Script

> Node affinity, is a property of Pods that attracts them to a set of nodes (either as a preference or a hard requirement). Taints are the opposite – they allow a node to repel a set of pods.

and

> Tolerations are applied to pods, and allow (but do not require) the pods to schedule onto nodes with matching taints.

and

> Taints and tolerations work together to ensure that pods are not scheduled onto inappropriate nodes. One or more taints are applied to a node; this marks that the node should not accept any pods that do not tolerate the taints.

*-Kubernetes-[Taints and Tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/)*

The key observations here are that Taints / Tolerations:

* Focused only on repeling Pods

* Feature is principally driven from Node configuration

* Can impact both scheduling (kube-scheduler) and execution (kublet)

As we will see, we can repel Pods from a Node without making any changes to the Pod template; not true for nodeName, nodeSelector, and Affinity.

### Taint

Nodes have taints, includes an artibrary key-value pair and effect. Effects are one of (names are self-explainatory).

* *NoSchedule*

* *PreferNoSchedule*

* *NoExecute*

### Built-in Taints

K8s has built-in NoExecute Taints with a blank value; sampling:

* node.kubernetes.io/not-ready

* node.kubernetes.io/unreachable

### Tolerations

Pods can have Tolerations; essentialy key-value pair and effect.  The essentially nullify the effect of a Taint.

In the case of a NoExecute Toleration can optionally supply a *tolerationSeconds* to invalidate it after a fixed period of time of a Taint.

### Built-in Tolerations

Install and observe tolerations:

```plaintext
helm install dev hello-pod
```

Daemon Pods even more:

```plaintext
kubectl describe pod kube-proxy-2rlfj -n kube-system
```

TODO: EXAMPLE OF EVICTING A POD AND THEN REMOVING