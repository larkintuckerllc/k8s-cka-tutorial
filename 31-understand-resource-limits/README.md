# Scheduling: Understand How Resource Limits Can Affect Pod Scheduling

Back to [Certified Kubernetes Administrator (CKA) Tutorial](https://github.com/larkintuckerllc/k8s-cka-tutorial)

[![Scheduling: Understand How Resource Limits Can Affect Pod Scheduling](http://img.youtube.com/vi/XXXXX/0.jpg)]()

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

### Pod Priority

> Pods can have priority. Priority indicates the importance of a Pod relative to other Pods. If a Pod cannot be scheduled, the scheduler tries to preempt (evict) lower priority Pods to make scheduling of the pending Pod possible.

and

> A PriorityClass is a non-namespaced object that defines a mapping from a priority class name to the integer value of the priority. The name is specified in the name field of the PriorityClass object’s metadata. The value is specified in the required value field. The higher the value, the higher the priority. The name of a PriorityClass object must be a valid DNS subdomain name, and it cannot be prefixed with system-.

and

> PriorityClass also has two optional fields: globalDefault and description. The globalDefault field indicates that the value of this PriorityClass should be used for Pods without a priorityClassName. Only one PriorityClass with globalDefault set to true can exist in the system. If there is no PriorityClass with globalDefault set, the priority of Pods with no priorityClassName is zero.

and

> When Pod priority is enabled, the scheduler orders pending Pods by their priority and a pending Pod is placed ahead of other pending Pods with lower priority in the scheduling queue.

and

> When Pods are created, they go to a queue and wait to be scheduled. The scheduler picks a Pod from the queue and tries to schedule it on a Node. If no Node is found that satisfies all the specified requirements of the Pod, preemption logic is triggered for the pending Pod. Let’s call the pending Pod P. Preemption logic tries to find a Node where removal of one or more Pods with lower priority than P would enable P to be scheduled on that Node. If such a Node is found, one or more lower priority Pods get evicted from the Node. After the Pods are gone, P can be scheduled on the Node.

*-Kubernetes-[Pod Priority and Preemption](https://kubernetes.io/docs/concepts/configuration/pod-priority-preemption/)*

```plaintext
helm install pre pre-no-evict
```

Wait for stable.

Notice Nodes resources don't track usage just requests / limits.

```plaintext
helm install post post-no-evict
```

Notice all Pods running.

Notice Nodes resources don't track usage just requests / limits.

```plaintext
helm install pre pre-evict
```

Wait for stable.

Notice Nodes resources don't track usage just requests / limits.

```plaintext
helm install post post-evict
```

Notice Pod evicted.

Look at events.
