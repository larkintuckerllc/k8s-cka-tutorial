# Networking: Deploy and Configure Network Load Balancer

Back to [Certified Kubernetes Administrator (CKA) Tutorial](https://github.com/larkintuckerllc/k8s-cka-tutorial)

[![Networking: Deploy and Configure Network Load Balancer](http://img.youtube.com/vi/NUTuloFZo2Y/0.jpg)](https://youtu.be/NUTuloFZo2Y)

## Script

### LoadBalancer

> On cloud providers which support external load balancers, setting the type field to LoadBalancer provisions a load balancer for your Service. The actual creation of the load balancer happens asynchronously, and information about the provisioned balancer is published in the Service’s .status.loadBalancer field.

*-Kubernetes-[Service](https://kubernetes.io/docs/concepts/services-networking/service/)*

```plaintext
helm install dev load-balancer
```

Observe; including NodePort. The way this works, is that the Nodes are configured to listen on the NodePort and route traffic to the Service Endpoints.

```plaintext
kubectl get all

kubectl describe service eample-dev
```

Observe AWS Classic LoadBalancer.  In particular the Instances and Listeners.

### LoadBalancer (HTTPS)

The AWS specific solution involves:

1. Obtaining a custom domain name, e.g., using AWS Route 53

2. Create a SSL/TLS certificate using AWS Certificate Manager

3. Create a LoadBalancer using a configuration

4. Mapping the custom domain name to the LoadBalancer, e.g., using AWS Route 53

Kubernetes provides documentation on the specific configurations for each of the [Cloud Providers](https://kubernetes.io/docs/concepts/cluster-administration/cloud-providers).

```plaintext
helm install dev load-balancer-ssl
```

### NodePort

> Exposes the Service on each Node’s IP at a static port (the NodePort). A ClusterIP Service, to which the NodePort Service routes, is automatically created. You’ll be able to contact the NodePort Service, from outside the cluster, by requesting NodeIP:NodePort.

*-Kubernetes-[Service](https://kubernetes.io/docs/concepts/services-networking/service/)*

```plaintext
helm install dev node-port
```

### ExternalName

ExternalName is a special case Service that does not get an IP address, but simply provides DNS CName for an external name:

> When looking up the host my-service.prod.svc.cluster.local, the cluster DNS Service returns a CNAME record with the value my.database.example.com. Accessing my-service works in the same way as other Services but with the crucial difference that redirection happens at the DNS level rather than via proxying or forwarding.

*-Kubernetes-[Service](https://kubernetes.io/docs/concepts/services-networking/service/)*

TODO: EXAMPLE

### Headless Service

This is another special case of a Service:

> Sometimes you don’t need load-balancing and a single Service IP. In this case, you can create what are termed “headless” Services, by explicitly specifying "None" for the cluster IP (.spec.clusterIP).

and

> For headless Services, a cluster IP is not allocated, kube-proxy does not handle these Services, and there is no load balancing or proxying done by the platform for them. How DNS is automatically configured depends on whether the Service has selectors defined:

and

> For headless Services that define selectors, the endpoints controller creates Endpoints records in the API, and modifies the DNS configuration to return records (addresses) that point directly to the Pods backing the Service.

*-Kubernetes-[Service](https://kubernetes.io/docs/concepts/services-networking/service/)*

Re-examine *statefulset* example in *14-understand-self-healing-application*.

**note:** Headless Services w/o a Selector behave similarly; mapping DNS names to EndPoints. Not going to cover this.
