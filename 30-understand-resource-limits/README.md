# Scheduling: Understand How Resource Limits Can Affect Pod Scheduling

Back to [Certified Kubernetes Administrator (CKA) Tutorial](https://github.com/larkintuckerllc/k8s-cka-tutorial)

[![Scheduling: Understand How Resource Limits Can Affect Pod Scheduling](http://img.youtube.com/vi/XXXXX/0.jpg)]()

## Script

> When you specify a Pod, you can optionally specify how much of each resource a Container needs. The most common resources to specify are CPU and memory (RAM); there are others.

and

> When you specify the resource request for Containers in a Pod, the scheduler uses this information to decide which node to place the Pod on. When you specify a resource limit for a Container, the kubelet enforces those limits so that the running container is not allowed to use more of that resource than the limit you set. The kubelet also reserves at least the request amount of that system resource specifically for that container to use.

*-Kubernetes-[Managing Resources for Containers](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/)*

### CPU

> Limits and requests for CPU resources are measured in cpu units. One cpu, in Kubernetes, is equivalent to 1 vCPU/Core for cloud providers and 1 hyperthread on bare-metal Intel processors.

and

> Fractional requests are allowed

and

> The expression 0.1 is equivalent to the expression 100m, which can be read as “one hundred millicpu”. Some people say “one hundred millicores”, and this is understood to mean the same thing

*-Kubernetes-[Managing Resources for Containers](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/)*

### Memory

> Limits and requests for memory are measured in bytes. You can express memory as a plain integer or as a fixed-point integer using one of these suffixes: E, P, T, G, M, K. You can also use the power-of-two equivalents: Ei, Pi, Ti, Gi, Mi, Ki.

*-Kubernetes-[Managing Resources for Containers](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/)*

### Resource Request and Scheduling

> When you create a Pod, the Kubernetes scheduler selects a node for the Pod to run on. Each node has a maximum capacity for each of the resource types: the amount of CPU and memory it can provide for Pods. The scheduler ensures that, for each resource type, the sum of the resource requests of the scheduled Containers is less than the capacity of the node. Note that although actual memory or CPU resource usage on nodes is very low, the scheduler still refuses to place a Pod on a node if the capacity check fails. This protects against a resource shortage on a node when resource usage later increases, for example, during a daily peak in request rate.

*-Kubernetes-[Managing Resources for Containers](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/)*

TODO: EXAMPLE

### Resource Limits and Execution

> If a Container exceeds its memory limit, it might be terminated. If it is restartable, the kubelet will restart it, as with any other type of runtime failure.

and

> A Container might or might not be allowed to exceed its CPU limit for extended periods of time. However, it will not be killed for excessive CPU usage.

*-Kubernetes-[Managing Resources for Containers](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/)*

TODO: EXAMPLE OF BOTH

### Other Resources

> As a beta feature, Kubernetes lets you track, reserve and limit the amount of ephemeral local storage a Pod can consume.

and

> Extended resources are fully-qualified resource names outside the kubernetes.io domain. They allow cluster operators to advertise and users to consume the non-Kubernetes-built-in resources.

*-Kubernetes-[Managing Resources for Containers](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/)*
