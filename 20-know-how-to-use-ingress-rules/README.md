# Networking: Know How to Use Ingress Rules

Back to [Certified Kubernetes Administrator (CKA) Tutorial](https://github.com/larkintuckerllc/k8s-cka-tutorial)

[![Networking: Know How to Use Ingress Rules](http://img.youtube.com/vi/XXXXX/0.jpg)]()

## Script

When I first read up on Ingress, I was terribly confused as it seemed to overlap with what our LoadBalancer did.

> What is Ingress?
Ingress exposes HTTP and HTTPS routes from outside the cluster to services within the cluster. Traffic routing is controlled by rules defined on the Ingress resource.

and

> An Ingress may be configured to give Services externally-reachable URLs, load balance traffic, terminate SSL / TLS, and offer name based virtual hosting. An Ingress controller is responsible for fulfilling the Ingress, usually with a load balancer, though it may also configure your edge router or additional frontends to help handle the traffic.

and

> An Ingress does not expose arbitrary ports or protocols. Exposing services other than HTTP and HTTPS to the internet typically uses a service of type Service.Type=NodePort or Service.Type=LoadBalancer.

*-Kubernetes-[Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/)*

Knowing a bit more, the key concepts are:

* *Ingress*: Abstract rules used by an *Ingress Controller* to route HTTP/HTTPS traffic to various Services

* *Ingress Controller*: Vendor-specific implementation that implements the *Ingress* rules; for AWS this is going to be an Application Load Balancer

### Ingress Controller

> In order for the Ingress resource to work, the cluster must have an ingress controller running.
> Unlike other types of controllers which run as part of the kube-controller-manager binary, Ingress controllers are not started automatically with a cluster. Use this page to choose the ingress controller implementation that best fits your cluster.

*-Kubernetes-[Ingress Controllers](https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/)*

In our case, we are going to use the [AWS ALB Ingress Controller](https://github.com/kubernetes-sigs/aws-alb-ingress-controller).

The good news is that EKS provides detailed intructions to install it; [ALB Ingress Controller on Amazon EKS](https://docs.aws.amazon.com/eks/latest/userguide/alb-ingress.html).

Work done offscreen.

**note**: While tedious, the steps all worked except had to address one known [bug](https://stackoverflow.com/questions/60375599/malformedpolicydocument-when-calling-the-createpolicy-operation-aws).

### IngressClass

> Before the IngressClass resource and ingressClassName field were added in Kubernetes 1.18, Ingress classes were specified with a kubernetes.io/ingress.class annotation on the Ingress. This annotation was never formally defined, but was widely supported by Ingress controllers.
> The newer ingressClassName field on Ingresses is a replacement for that annotation, but is not a direct equivalent. While the annotation was generally used to reference the name of the Ingress controller that should implement the Ingress, the field is a reference to an IngressClass resource that contains additional Ingress configuration, including the name of the Ingress controller.

*-Kubernetes-[Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/)*

But, as we saw in the AWS documentation, they still use the annotation, i.e.,:

```plaintext
annotations:
    kubernetes.io/ingress.class: alb
```

### Ingress (Simple)

> Each HTTP rule contains the following information:

* An optional host. In this example, no host is specified, so the rule applies to all inbound HTTP traffic through the IP address specified. If a host is provided (for example, foo.bar.com), the rules apply to that host.

* A list of paths (for example, /testpath), each of which has an associated backend defined with a serviceName and servicePort. Both the host and path must match the content of an incoming request before the load balancer directs traffic to the referenced Service.

* A backend is a combination of Service and port names as described in the Service doc. HTTP (and HTTPS) requests to the Ingress that matches the host and path of the rule are sent to the listed backend.

*-Kubernetes-[Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/)*

We install a simple example:

```plaintext
helm install dev ingress
```

### Ingress (Multiple Hosts)

```plaintext
helm install dev ingress-multiple-hosts
```

Setup DNS to for *httpd.todosrus.com* and *nginx.todosrus.com*.

### Ingress (Multiple Paths)

```plaintext
helm install dev ingress-multiple-paths
```
