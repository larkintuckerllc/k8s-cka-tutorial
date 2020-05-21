# Security: Know How to Use Network Policies

Back to [Certified Kubernetes Administrator (CKA) Tutorial](https://github.com/larkintuckerllc/k8s-cka-tutorial)

[![Security: Know How to Use Network Policies](http://img.youtube.com/vi/XXXXX/0.jpg)]()

## Script

As you may have noticed so far, by default, any Pod can communicate to any other Pod (or be exposed externally, i.e., LoadBalancer). This is not consistent with the pattern of a secure multi-tier application.

To help understand the pattern, let us look at an example (first conceptually):

TODO: IMAGE

* *Logic (or Application) Tier*: Say a Flask application providing an API

* *Data Tier*: Say a Redis database storing the application's data

* Data Tier only accessible from Logic Tier; and limited to redis port

* Logic Tier generally accessible; and limited to http port

* For demonstration, put an Ubuntu Pod in the Logic Tier and another one elsewhere

So how do these tiers relate to K8s concepts?

Thinking about tiers as basically groupings of Pods, it is unsurprising that we use K8s labels and Namespaces to define these tiers. In this example, the tiers are defined by:

* *Logic Tier*: Pods with namespace: *production* with a label *network/logic*: *true*

* *Data Tier*: Pods with namespace: production with a label *network/data*: *true*

**note:**: The specific label key / values is arbitrary.

Look at: *flask-deployment.yaml*, *redis-development.yaml*, and *ubuntu-production-pod.yaml*.

### Install Project Calico into EKS

> Project Calico is a network policy engine for Kubernetes. With Calico network policy enforcement, you can implement network segmentation and tenant isolation. This is useful in multi-tenant environments where you must isolate tenants from each other or when you want to create separate environments for development, staging, and production. Network policies are similar to AWS security groups in that you can create network ingress and egress rules. Instead of assigning instances to a security group, you assign network policies to pods using pod selectors and labels.

*-AWS-[Installing Calico on Amazon EKS](https://docs.aws.amazon.com/eks/latest/userguide/calico.html)*

**note:** This is separate from the Calico CNI addon.

Easiest to understand NetworkPolicy objects by example.

### TODO: BUILD THE FLASK APP

TODO

### Isolated and Non-Isolated Pods

> By default, pods are non-isolated; they accept traffic from any source.
> Pods become isolated by having a NetworkPolicy that selects them. Once there is any NetworkPolicy in a namespace selecting a particular pod, that pod will reject any connections that are not allowed by any NetworkPolicy.

*-Kubernetes-[Network Policies](https://kubernetes.io/docs/concepts/services-networking/network-policies/)*

Technically, isolation is specific to ingress and egress traffic separately; we will only be considering ingress in this video.

Look at *any-from-any-none-network-policy.yaml*.  This is a special case NetworkPolicy that targets all Pods in the *production-X* Namespace and provides an empty set of Ingress rules; this causes all the Pods in *production-X* to be isolated.

### Securing the Data Tier

Look at *data-from-logic-redis-network-policy.yaml*. This targets all Pods in the *production-X* namespace with a label *networking/data*: *true* (aka Data Tier).

The rule here enables Redis traffic from Pods in the *production-X* namespace with a label *networking/logic*: *true* (aka Logic Tier).

### Securing the Logic Tier

Look at *logic-from-any-http-network-policy.yaml*. This targets all Pods in the *production-X* namespace with a label *networking/logic*: *true* (aka Logic Tier).

The rule here enables HTTP traffic from any source (no *from*).

### Validating the Solution

TODO

### TODO OTHER SELECTORS
