# Installation, Configuration & Validation: Install Kubernetes Masters and Nodes

**note:** Includes the following additional topics under *Installation, Configuration & Validation*.

* Design a Kubernetes Cluster

* Know where to get the Kubernetes release binaries

* Provision underlying infrastructure to deploy a Kubernetes cluster

* Choose a network solution

* Choose your Kubernetes infrastructure configuration

* Install and use kubeadm to install, configure, and manage Kubernetes clusters

[![Installation, Configuration & Validation: Install Kubernetes Masters and Nodes](http://img.youtube.com/vi/XXXXXX/0.jpg)](XXXX)

## Script

There are compelling reasons to use Amazon's EKS instead of trying to install your own cluster from scratch; mostly EKS has deep integrations with other AWS services out of the box. But we are here to learn...

Also, while one can install learning environments on one's workstation, e.g,. *Minikube* or *microK8s*, we want to install in a more "real" environment.

There are a number of tools that automate the creation of clusters (much like EKS), e.g.:

* [kops](https://github.com/kubernetes/kops): The easiest way to get a production grade Kubernetes cluster up and running

* [KRIB](https://github.com/digitalrebar/provision-content): Kubernetes Rebar Integrated Bootstrap content pack

* [Kubespray](https://github.com/kubernetes-sigs/kubespray): Deploy a Production Ready Kubernetes Cluster

As we are here to learn, we are going to manually install a Kubernetes cluster using the *kubeadm* tool.

For simplicy, we will use a network configuration with a single public subnet, e.g., the default AWS VPC and subnets.

We start with using AWS console to launch two EC2 instance; one will be our Control Plane Node and one Worker Node.

* t3.medium

* Ubuntu LTS

* Security Group: TCP/22 from anywhere, All traffic from the Security Group itself

Installation starts with [installing kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/) on both hosts. Steps generally involve:

* Bridge: kernel and config

* Container Runtime: Docker

* kubeadm, kublet, and kubectl

To keep it simple, we will follow the instructions in [Creating a single control-plane cluster with kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/).

Install Kubernetes Cluster, planning for the Calico Pod Network; follow generated instructions:

```plaintext
kubeadm init --pod-network-cidr 192.168.0.0/16
```

Install Calico Pod Network Addon.

On second host, follow instructions to join as Worker Node.

Confirm Kubernetes Cluster operational:

```plaintext
kubectl get nodes
```
