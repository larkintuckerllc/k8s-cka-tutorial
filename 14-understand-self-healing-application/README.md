# Application Lifecycle Management: Understand the primitives necessary to create a self-healing application

Back to [Certified Kubernetes Administrator (CKA) Tutorial](https://github.com/larkintuckerllc/k8s-cka-tutorial)

[![Networking: Understand Pod Networking Concepts](http://img.youtube.com/vi/XXXXX/0.jpg)](XXXXX)

## Script

### Deployment

> A Deployment provides declarative updates for Pods and ReplicaSets.
> You describe a desired state in a Deployment, and the Deployment Controller changes the actual state to the desired state at a controlled rate. You can define Deployments to create new ReplicaSets, or to remove existing Deployments and adopt all their resources with new Deployments.

*-Kubernetes-[Deployments](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)*

Recall that changing a ReplicaSet's Pod template did not automatically cause all the Pods to be swapped out.  If we wanted to swap them out, we had to scale down the RS and then scale it back up.

Much like ReplicaSets controlling Pods, a Deployment controls a ReplicaSet to address this very problem. Technically, it will at times use two ReplicaSets to achieve the Pod swapout (scaling up one while scaling down another).

Let us create a deployment:

```plaintext
helm install dev deployment
```

Quick way to inspect all "application" resources:

Notice that the generated RS is named after the deployment (with hash) much like the Pods are named after the RS (with hash).

```plaintext
kubectl get all
```

Much like Pods and RS, the RS is controlled by the Deployment.

```plaintext
kubectl describe rs
```

Let us change the Pod template in the Deployment; image to ubuntu:20.04.

```plaintext
helm upgrade dev deployment
```

Monitor deployment rollout:

```plaintext
kubectl rollout status deployment example-dev --watch
kubectl get all
kubectl describe deployment
```

You may be wondering how the Deployment decides to scale down and up the ReplicaSets? A bad strategy would be to completely scale down one and scale up the second (application down). Likewise scaling one up and then scale down the second would be bad (wasting resources).

> Deployment ensures that only a certain number of Pods are down while they are being updated. By default, it ensures that at least 75% of the desired number of Pods are up (25% max unavailable).
> Deployment also ensures that only a certain number of Pods are created above the desired number of Pods. By default, it ensures that at most 125% of the desired number of Pods are up (25% max surge).

*-Kubernetes-[Deployments](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)*

We will explore managing Deployment in detail in a later video.

### DaemonSet

> A DaemonSet ensures that all (or some) Nodes run a copy of a Pod. As nodes are added to the cluster, Pods are added to them. As nodes are removed from the cluster, those Pods are garbage collected. Deleting a DaemonSet will clean up the Pods it created.

*-Kubernetes-[DaemonSet](https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/)*

Some observations:

* Like Deployments, can rollout Pod changes

* Does not, however, use ReplicaSets. It directly manages the Pods

* Configuration, virtually same as RS and Deployment; just no replicas

Examples of DaemonSets, *aws-node* and *kube-proxy* for networking:

```plaintext
kubectl get all --all-namespaces
```

```plaintext
helm install dev daemonset
```

```plaintext
helm get all
```
