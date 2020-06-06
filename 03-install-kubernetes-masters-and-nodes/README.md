# Installation, Configuration & Validation: Install Kubernetes Masters and Nodes

Back to [Certified Kubernetes Administrator (CKA) Tutorial](https://github.com/larkintuckerllc/k8s-cka-tutorial)

**note:** Includes the following additional topics under *Installation, Configuration & Validation*.

* Design a Kubernetes Cluster

* Know where to get the Kubernetes release binaries

* Provision underlying infrastructure to deploy a Kubernetes cluster

* Choose a network solution

* Choose your Kubernetes infrastructure configuration

* Install and use kubeadm to install, configure, and manage Kubernetes clusters

[![Installation, Configuration & Validation: Install Kubernetes Masters and Nodes](http://img.youtube.com/vi/D3mQl-FaFfQ/0.jpg)](https://youtu.be/D3mQl-FaFfQ)

## Test Preparation: Relevant Kubernetes Documentation

In our example, we added a Worker Node as part of the intitial install. In the exam, we need to be prepared to add a Worker Node after-the-fact using the instructions at [Creating a single control-plane cluster with kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/); one thing document fails to mention is that the kube-apiserver runs on port *6443*. Search for *install kubeadm*.

## Script

There are compelling reasons to use Amazon's EKS instead of trying to install your own cluster from scratch; mostly EKS has deep integrations with other AWS services out of the box and is HA. But we are here to learn...

Also, while one can install learning environments on one's workstation, e.g,. *Minikube* or *microK8s*, we want to install in a more "real" environment.

There are a number of tools that automate the creation of clusters (much like EKS), e.g.:

* [kops](https://github.com/kubernetes/kops): The easiest way to get a production grade Kubernetes cluster up and running

* [KRIB](https://github.com/digitalrebar/provision-content): Kubernetes Rebar Integrated Bootstrap content pack

* [Kubespray](https://github.com/kubernetes-sigs/kubespray): Deploy a Production Ready Kubernetes Cluster

As we are here to learn, we are going to manually install a Kubernetes cluster using the *kubeadm* tool.

### Installation

For simplicy, we will use a network configuration with a single public subnet, e.g., the default AWS VPC and subnets.

We start with using AWS console to launch two EC2 instance.

* t3.medium

* Ubuntu LTS

* Security Group: TCP/22 from anywhere, All traffic from the Security Group itself

Installation starts with [installing kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/) on both instances. Steps generally involve:

* Bridge: kernel and config

* Container Runtime: Docker

* kubeadm, kublet, and kubectl

To keep it simple, we will follow the instructions in [Creating a single control-plane cluster with kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/). This configuration has one instance as a Control Plane Node (aka, Master Node) and one as a Worker Node.

The actual installation, planning for the Calico Pod Network, is the following command followed with the generated instructions:

```plaintext
kubeadm init --pod-network-cidr 192.168.0.0/16
```

As we will learn, many Kubernetes objects, e.g., Pods, are associated with an IP address and these addresses are drawn from this CIDR network. Notice this address range is completly separate from the IP addresses in the VPC (important as they are independently managed).

The next step is to install Calico Pod Network Addon.

Finally, on second host, follow instructions to join as Worker Node.

### Validation On Each Node

**note:** All the following quotes and diagram are from [Kubernetes Components](https://kubernetes.io/docs/concepts/overview/components/).

![Components of Kubernetes](components-of-kubernetes.png)

#### Container Runtime (runs as an OS service, e.g., Docker)

> The container runtime is the software that is responsible for running containers.

Confirm operational:

```plaintext
systemctl status docker
```

#### Kubelet (runs as an OS service)

> An agent that runs on each node in the cluster. It makes sure that containers are running in a Pod.

Confirm operational:

```plaintext
systemctl status kubelet
```

#### kube-proxy (runs as a Pod)

> maintains network rules on nodes. These network rules allow network communication to your Pods from network sessions inside or outside of your cluster

Confirm operational (run from Master):

```plaintext
kubectl get pods --all-namespaces --field-selector spec.nodeName=ip-172-31-42-199
```

**note:** Your Node name will be different.

### Validation On the Master (or Control Plane) Node

#### kube-apiserver (runs as a Pod)

> The API server is a component of the Kubernetes control plane that exposes the Kubernetes API. The API server is the front end for the Kubernetes control plane.

Confirm operational (for following Pods too):

```plaintext
kubectl get pods --all-namespaces --field-selector spec.nodeName=ip-172-31-47-139
```

**note:** Your Node name will be different.

**note:** Observe the *CoreDNS* and *Calico* Addons.

#### kube-scheduler (runs as a Pod)

> Control plane component that watches for newly created Pods with no assigned node, and selects a node for them to run on.

#### kube-controller-manager (runs as a Pod)

> Control Plane component that runs controller processes.

#### cloud-controller-manager (runs as a Pod)

> A Kubernetes control plane component that embeds cloud-specific control logic.

#### etcd (runs as a Pod)

> Consistent and highly-available key value store used as Kubernetes’ backing store for all cluster data.
