# Networking: Know How to Configure and Use the Cluster DNS

Back to [Certified Kubernetes Administrator (CKA) Tutorial](https://github.com/larkintuckerllc/k8s-cka-tutorial)

[![Networking: Know How to Configure and Use the Cluster DNS](http://img.youtube.com/vi/v9zhyPzYT7E/0.jpg)](https://youtu.be/v9zhyPzYT7E)

## Test Preparation: Relevant Kubernetes Documentation

Search term *dns* finds:

* [DNS for Service and Pods](https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/)

* [Customizing DNS Service](https://github.com/larkintuckerllc/k8s-cka-tutorial/tree/master/18-configure-and-use-cluster-dns)

## Script

### CoreDNS

> DNS is a built-in Kubernetes service launched automatically using the addon manager cluster add-on.
> As of Kubernetes v1.12, CoreDNS is the recommended DNS Server, replacing kube-dns. However, kube-dns may still be installed by default with certain Kubernetes installer tools. Refer to the documentation provided by your installer to know which DNS server is installed by default

*-Kubernetes-[Customizing DNS Service](https://kubernetes.io/docs/tasks/administer-cluster/dns-custom-nameservers/)*

Observe *kube-dns* service and *coredns* deployment:

```plaintext
kubectl get all --all-namespaces
```

> CoreDNS is a DNS server that is modular and pluggable, and each plugin adds new functionality to CoreDNS. This can be configured by maintaining a Corefile, which is the CoreDNS configuration file. A cluster administrator can modify the ConfigMap for the CoreDNS Corefile to change how service discovery works.

*-Kubernetes-[Customizing DNS Service](https://kubernetes.io/docs/tasks/administer-cluster/dns-custom-nameservers/)*

```plaintext
kubectl describe cm coredns -n kube-system
```

The principle configuration values are:

> CoreDNS has the ability to configure stubdomains and upstream nameservers using the forward plugin.

*-Kubernetes-[Customizing DNS Service](https://kubernetes.io/docs/tasks/administer-cluster/dns-custom-nameservers/)*

* stubdomains: Setting DNS servers for a particular domain

* upstream nameservers: DNS servers for other domains (other than stubdomain and cluster)

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

This is the case where an A record points to a service IP; used to discover service.

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

This is the case where we need to have a persistent name for each Pod in the Service; using StatefulSet and Headless Service.

```plaintext
nslookup headless-dev-0.headless-dev
```

### Service and Pod A Records

This is the case of persistent name for each Pod using Headless Service.

```plaintext
nslookup pod-a.pod-dev
```

#### Service SVC Records

This allows one to lookup the hostname and port of a service port.

> SRV Records are created for named ports that are part of normal or Headless Services. For each named port, the SRV record would have the form _my-port-name._my-port-protocol.my-svc.my-namespace.svc.cluster-domain.example. For a regular service, this resolves to the port number and the domain name: my-svc.my-namespace.svc.cluster-domain.example. For a headless service, this resolves to multiple answers, one for each pod that is backing the service, and contains the port number and the domain name of the pod of the form auto-generated-name.my-svc.my-namespace.svc.cluster-domain.example.

-Kubernetes-[DNS for Services and Pods](https://kubernetes.io/docs/concepts/services-networking/dns-pod-service)

```plaintext
nslookup -type=SRV  http.tcp.head-dev.default.svc.cluster.local
```

### Pod DNS Policy and Config

The Pod *spec.dnsPolicy* indicates how DNS works for the Pod; the *ClusterFirst* setting is the default.

> “ClusterFirst”: Any DNS query that does not match the configured cluster domain suffix, such as “www.kubernetes.io”, is forwarded to the upstream nameserver inherited from the node. Cluster administrators may have extra stub-domain and upstream DNS servers configured.

-Kubernetes-[DNS for Services and Pods](https://kubernetes.io/docs/concepts/services-networking/dns-pod-service)

> Below are the properties a user can specify in the *dnsConfig* field:

* *nameservers*: a list of IP addresses that will be used as DNS servers for the Pod

* *searches*: a list of DNS search domains for hostname lookup in the Pod

* options: an optional list of objects supplied to */etc/resolv.conf*

```plaintext
helm install dev config
```

Install *dnsutils*, observe */etc/resolv.conf*, and search for *gmail*
