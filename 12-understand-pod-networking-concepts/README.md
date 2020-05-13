# Networking: Understand Pod Networking Concepts

Back to [Certified Kubernetes Administrator (CKA) Tutorial](https://github.com/larkintuckerllc/k8s-cka-tutorial)

**note:** Includes the following additional topics:

* Troubleshoot: Troubleshoot Application Failure

[![Networking: Understand Pod Networking Concepts](http://img.youtube.com/vi/XXXXX/0.jpg)](XXXXX)

## Script

### Pod Networking

> Each Pod is assigned a unique IP address for each address family. Every container in a Pod shares the network namespace, including the IP address and network ports. Containers inside a Pod can communicate with one another using localhost. When containers in a Pod communicate with entities outside the Pod, they must coordinate how they use the shared network resources (such as ports).

*-Kubernetes-[Pod Overview](https://kubernetes.io/docs/concepts/workloads/pods/pod-overview/)*

**note:** TODO BLURB ABOUT IPC

> List of ports to expose from the container. Exposing a port here gives the system additional information about the network connections a container uses, but is primarily informational. Not specifying a port here DOES NOT prevent that port from being exposed. Any port which is listening on the default "0.0.0.0" address inside a container will be accessible from the network.

*-Kubernetes-[Reference](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.18/#podspec-v1-core)*

ssh into httpd
show index.html

ssh into ubuntu
apt-get update
apt-get install curl
curl localhost

Look at IP address of pod: 192.168.192.119

Look at AWS on Node EC2 and notice secondary IP address.

Login to Node:
curl 192.168.192.119

How is traffic to this IP address getting to Pod?

route

ifconfig

DIAGRAM

### Debug Running Pods

kubectl logs example-dev --container httpd

debug

kubectl logs example-dev

note: Alpha Ephemeral