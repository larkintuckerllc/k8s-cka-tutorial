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

