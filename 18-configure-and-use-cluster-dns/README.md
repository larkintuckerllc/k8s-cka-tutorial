# Networking: Know How to Configure and Use the Cluster DNS

Back to [Certified Kubernetes Administrator (CKA) Tutorial](https://github.com/larkintuckerllc/k8s-cka-tutorial)

[![Networking: Know How to Configure and Use the Cluster DNS](http://img.youtube.com/vi/XXXXXX/0.jpg)](XXXXXX)

## Script

TODO: INTRO

TODO: WHY FOR ALL

### Search List

 > By default, a client Pod’s DNS search list will include the Pod’s own namespace and the cluster’s default domain.

-Kubernetes-[DNS for Services and Pods](https://kubernetes.io/docs/concepts/services-networking/dns-pod-service)

```plaintext
helm install dev dns
```

Login to *example-dev* pod and install *dnsutils*.

Notice that the DNS search list is managed by K8S:

Examine */etc/resolv.conf*.

#### Service A Records

So, searching for the *head* service A record can be abbreviated, e.g.:

```plaintext
nslookup head-dev

nslookup head-dev.default
```

As for a headless service, you get back A records for each Pod:

```plaintext
nslookup headless-dev.default.svc.cluster.local
```

#### Service and StatefulSet A Records

Because we used a StatefulSet referencing the service, we get A records for each Pod in the service:

```plaintext
lookup headless-dev-0.headless-dev
```

#### Service SVC Records

> SRV Records are created for named ports that are part of normal or Headless Services. For each named port, the SRV record would have the form _my-port-name._my-port-protocol.my-svc.my-namespace.svc.cluster-domain.example. For a regular service, this resolves to the port number and the domain name: my-svc.my-namespace.svc.cluster-domain.example. For a headless service, this resolves to multiple answers, one for each pod that is backing the service, and contains the port number and the domain name of the pod of the form auto-generated-name.my-svc.my-namespace.svc.cluster-domain.example.

-Kubernetes-[DNS for Services and Pods](https://kubernetes.io/docs/concepts/services-networking/dns-pod-service)

```plaintext
nslookup -type=SRV  http.tcp.head-dev.default.svc.cluster.local
```
