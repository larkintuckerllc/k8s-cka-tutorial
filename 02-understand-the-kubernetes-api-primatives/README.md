# Core Concepts: Understand the Kubernetes API Primatives

TODO: VIDEO

## Script

Now that we have an operational Kubernetes Cluster, we can understand many of its features through the API it exposes.

A Kubernetes cluster supports any number of versioned API Groups, e.g., */apis/$GROUP_NAME/$VERSION*. The core, aka. legacy, group, however, is exposed as */api/v1*.

We can see the versioned API Groups supported by our cluster with:

```plaintext
kubectl api-versions
```

Many of these API endpoints define a kind of persistent Kubernetes object, aka., resources.

> Kubernetes objects are persistent entities in the Kubernetes system. Kubernetes uses these entities to represent the state of your cluster.

*-Kubernetes-[Understanding Kubernetes Objects](https://kubernetes.io/docs/concepts/overview/working-with-objects/kubernetes-objects/)*

We can see the kinds of Kubernetes objects supported by our cluster with:

```plaintext
kubectl api-resources
```

> Each object in your cluster has a Name that is unique for that type of resource. Every Kubernetes object also has a UID that is unique across your whole cluster.

*-Kubernetes-[Object Names and IDs](https://kubernetes.io/docs/concepts/overview/working-with-objects/names/)*

For kinds of objects that are namespaced, the previous statement about unique Names is relative to Namespaces:

> Namespaces provide a scope for names. Names of resources need to be unique within a namespace, but not across namespaces. Namespaces can not be nested inside one another and each Kubernetes resource can only be in one namespace.

*-Kubernetes-[Namespaces](https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/)*

We can see which kinds of objects are namespaced with:

```plaintext
kubectl api-resources
```

We can get a list of the Namespaces with:

```plaintext
kubectl get namespaces
```

We can get a list of common objects across all namespaces with:

```plaintext
kubectl get all --all-namespaces
```

We can see that our Cluster already has a number of Kubernetes objects. Some, e.g., those related to `kube-proxy`, are built-in and some are from pre-installed Addons:

* [CoreDNS](https://coredns.io/): A flexible, extensible DNS server which can be installed as the in-cluster DNS for pods

* [Amazon VPC Container Network Interface (CNI)](https://docs.aws.amazon.com/eks/latest/userguide/pod-networking.html): Supports native VPC networking

As described in [Cluster Networking](https://kubernetes.io/docs/concepts/cluster-administration/networking/), Kubernetes Clusters require a Container Network Interface (CNI) Addon.
