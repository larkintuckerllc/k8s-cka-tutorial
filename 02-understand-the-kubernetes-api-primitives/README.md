# Core Concepts: Understand the Kubernetes API Primitives

Back to [Certified Kubernetes Administrator (CKA) Tutorial](https://github.com/larkintuckerllc/k8s-cka-tutorial)

[![Core Concepts: Understand the Kubernetes API Primitives](http://img.youtube.com/vi/rwWiOC2j3vs/0.jpg)](https://youtu.be/rwWiOC2j3vs)

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

We see the following built-in Namespaces:

* *default*: As the name suggests, this is the Namespace used when otherwise not specified

* *kube-node-lease*: This is an internal Kubernetes Namespace

* *kube-public*: This is a Namespace for objects that are generally readable; even by unauthenticated users

* *kube-system*: This is an internal Kubernetes Namespace

In addition to the built-in Namespaces, we can create additional ones:

> Namespaces are intended for use in environments with many users spread across multiple teams, or projects. For clusters with a few to tens of users, you should not need to create or think about namespaces at all. Start using namespaces when you need the features they provide.

*-Kubernetes-[Namespaces](https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/)*

We can get a list of common objects across all namespaces with:

```plaintext
kubectl get all --all-namespaces
```

We can see that our Cluster already has a number of Kubernetes objects. Some, e.g., those related to `kube-proxy`, are built-in and some are from pre-installed Addons:

* [CoreDNS](https://coredns.io/): A flexible, extensible DNS server which can be installed as the in-cluster DNS for pods

* [Amazon VPC Container Network Interface (CNI)](https://docs.aws.amazon.com/eks/latest/userguide/pod-networking.html): Supports native VPC networking

As described in [Cluster Networking](https://kubernetes.io/docs/concepts/cluster-administration/networking/), Kubernetes Clusters require a Container Network Interface (CNI) Addon.

Also notice that these, as well as most Addons, create objects in the *kube-system* Namespace.

We can install another commonly used Addon, [metrics-server](https://github.com/kubernetes-sigs/metrics-server).

**note:**: While AWS provides the same installation [instructions](
https://docs.aws.amazon.com/eks/latest/userguide/metrics-server.html
), there is an [issue](https://github.com/kubernetes-sigs/metrics-server/issues/247) (and resolution) with it.

We first observe that without *metrics-server* installed, some built-in *kubectl* commands do not work, e.g.:

```plaintext
kubectl top nodes
```

We install *metrics-server*:

```plaintext
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.3.6/components.yaml
```

**note:**: We will cover the *apply* command in more detail later.

We can observe the added objects:

```plaintext
kubectl get all --all-namespaces
```

To resolve the issue, we can use the following fix:

```plaintext
kubectl edit deployment metrics-server -n kube-system
```

and adding these container arguments:

```plaintext
--kubelet-preferred-address-types=InternalIP
--kubelet-insecure-tls=true
```

We try the built-in *kubectl* command again:

```plaintext
kubectl top nodes
```
