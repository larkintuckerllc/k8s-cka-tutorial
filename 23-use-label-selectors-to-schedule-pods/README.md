# Scheduling: Use Label Selectors to Schedule Pods

Back to [Certified Kubernetes Administrator (CKA) Tutorial](https://github.com/larkintuckerllc/k8s-cka-tutorial)

**note**: Includes the following additional topics:

* Scheduling: Manually schedule a pod without a scheduler

* Scheduling: Display Scheduler Events

* Scheduling: Understand how to run multiple schedulers and how to configure Pods to use them

[![Scheduling: Use Label Selectors to Schedule Pods](http://img.youtube.com/vi/XtZBhTs6vmY/0.jpg)](https://youtu.be/XtZBhTs6vmY)

## Test Preparation: Relevant Kubernetes Documentation

Search for *assign pods* and get [Assign Pods to Nodes](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/).

## Script

> A scheduler watches for newly created Pods that have no Node assigned. For every Pod that the scheduler discovers, the scheduler becomes responsible for finding the best Node for that Pod to run on. The scheduler reaches this placement decision taking into account the scheduling principles described below.

and

> kube-scheduler is the default scheduler for Kubernetes and runs as part of the control plane. kube-scheduler is designed so that, if you want and need to, you can write your own scheduling component and use that instead.

and

> In a cluster, Nodes that meet the scheduling requirements for a Pod are called feasible nodes. If none of the nodes are suitable, the pod remains unscheduled until the scheduler is able to place it.

and

> The scheduler finds feasible Nodes for a Pod and then runs a set of functions to score the feasible Nodes and picks a Node with the highest score among the feasible ones to run the Pod. The scheduler then notifies the API server about this decision in a process called binding.

*-Kubernetes-[Kubernetes Scheduler](https://kubernetes.io/docs/concepts/scheduling-eviction/kube-scheduler/)*

**note:** It is important to note, that schedulers works by identifying what Node to run Pods on during scheduling; it does not deal with executing Pods, i.e., evicting.

### Custom Scheduler

> Kubernetes ships with a default scheduler that is described here. If the default scheduler does not suit your needs you can implement your own scheduler. Not just that, you can even run multiple schedulers simultaneously alongside the default scheduler and instruct Kubernetes what scheduler to use for each of your pods. Let’s learn how to run multiple schedulers in Kubernetes with an example.

*-Kubernetes-[Configure Multiple Schedulers](https://kubernetes.io/docs/tasks/administer-cluster/configure-multiple-schedulers/)*

Process generally involves:

* Install new scheduler using a Deployment; schedulers are associated with a unique cluster-wide name to identify them

* Associate Pods to scheduler using the name, i.e., *schedulerName: default-scheduler*

We will look at in a minute.

### nodeName

> nodeName is the simplest form of node selection constraint, but due to its limitations it is typically not used. nodeName is a field of PodSpec. If it is non-empty, the scheduler ignores the pod and the kubelet running on the named node tries to run the pod. Thus, if nodeName is provided in the PodSpec, it takes precedence over the above methods for node selection.

*-Kubernetes-[Assigning Pods to Nodes](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/)*

**note**: By directly setting *nodeName* you by-pass the scheduler as this is what scheduler actually does.  The Kublet on that Node is what then actually runs the Pod (uses this value).

Here we fail:

```plaintext
helm install dev node-name
```

**note**: Look at the *schedulerName* value in full yaml.

```plaintext
kubectl describe pod example

kubectl get events -n kube-system
```

### nodeSelector

> nodeSelector is the simplest recommended form of node selection constraint. nodeSelector is a field of PodSpec. It specifies a map of key-value pairs. For the pod to be eligible to run on a node, the node must have each of the indicated key-value pairs as labels (it can have additional labels as well). The most common usage is one key-value pair.

Notice that Nodes are pre-populated with a number of labels; including one that specifies the Availability Zone.

```plaintext
kubectl get nodes

kubectl describe node XXX
```

In the last video, we created a Pod using an EBS volume that is only usable on Pods scheduled to Nodes in a particular Availability Zone. We had one Node, so we glossed over this problem.

Here we start up two Nodes and inspect / install:

```plaintext
helm install dev node-selector
```

**note**: By using labels prefixed with *node-restriction.kubernetes.io/* and enabling the NodeRestriction admission controller we can prevent Nodes from scheduling security-senstive Pods on themselves.

**note**: Enabling or disabling (there are defaults) admission controllers is a flag on *kube-apiserver*. For EKS there is a fixed set of compiled-in admission controllers (NodeRestriction is included) but it does support Dynamic Admission Control (where can use web hooks)

### Affinity and Anti-Affinity

> nodeSelector provides a very simple way to constrain pods to nodes with particular labels. The affinity/anti-affinity feature, greatly expands the types of constraints you can express. The key enhancements are

* The affinity/anti-affinity language is more expressive

* you can indicate that the rule is “soft”/“preference”

* you can constrain against labels on other pods running on the node

*-Kubernetes-[Assigning Pods to Nodes](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/)*

#### nodeAffinity

> Node affinity is conceptually similar to nodeSelector – it allows you to constrain which nodes your pod is eligible to be scheduled on, based on labels on the node.

and

> There are currently two types of node affinity, called requiredDuringSchedulingIgnoredDuringExecution and preferredDuringSchedulingIgnoredDuringExecution. You can think of them as “hard” and “soft” respectively,

*-Kubernetes-[Assigning Pods to Nodes](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/)*

**note**: "required" is processed first and "preferred" sets a weight to help choose between remaining choices. Will focus on "required".

```plaintext
helm install dev node-affinity
```

> You can see the operator In being used in the example. The new node affinity syntax supports the following operators: In, NotIn, Exists, DoesNotExist, Gt, Lt. You can use NotIn and DoesNotExist to achieve node anti-affinity behavior,

and

> If you specify both nodeSelector and nodeAffinity, both must be satisfied for the pod to be scheduled onto a candidate node.

and

> If you specify multiple nodeSelectorTerms associated with nodeAffinity types, then the pod can be scheduled onto a node if one of the nodeSelectorTerms can be satisfied.

and

> If you specify multiple matchExpressions associated with nodeSelectorTerms, then the pod can be scheduled onto a node only if all matchExpressions is satisfied.

*-Kubernetes-[Assigning Pods to Nodes](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/)*

#### podAffinity

> Inter-pod affinity and anti-affinity allow you to constrain which nodes your pod is eligible to be scheduled based on labels on pods that are already running on the node rather than based on labels on nodes

and

> As with node affinity, there are currently two types of pod affinity and anti-affinity, called requiredDuringSchedulingIgnoredDuringExecution and preferredDuringSchedulingIgnoredDuringExecution which denote “hard” vs. “soft” requirements.

and

> Inter-pod affinity is specified as field podAffinity of field affinity in the PodSpec. And inter-pod anti-affinity is specified as field podAntiAffinity of field affinity in the PodSpec.

*-Kubernetes-[Assigning Pods to Nodes](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/)*

**note:**  Because Pods are namespaced, rules default to the same NS as the Pod.  Rules, however, can be namespaced.

The general idea is that you specify a *topologyKey* for a selection rule that groups Nodes based on this key; these are labels on Nodes, e.g., Availability Zone. Then the rule is about Pods (identified by label) in that group.

Here we spread out Pods across Availability Zones.

```plaintext
helm install dev pod-affinity
```

```plaintext
kubectl get pod -o=custom-columns=NODE:.spec.nodeName,NAME:.metadata.name
```
