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

While one can install learning environments on your workstation, e.g,. *Minikube* or *microK8s*, we want to focus more on AWS.

At the same time, there are compelling reasons to use Amazon's EKS instead of trying to install your own cluster from scratch; mostly EKS has deep integrations with other AWS services out of the box.

But we are here to learn...

There are a number of tools that automate the creation of clusters (much like EKS), e.g.:

* [kops](https://github.com/kubernetes/kops): The easiest way to get a production grade Kubernetes cluster up and running

* [KRIB](https://github.com/digitalrebar/provision-content): Kubernetes Rebar Integrated Bootstrap content pack

* [Kubespray](https://github.com/kubernetes-sigs/kubespray): Deploy a Production Ready Kubernetes Cluster

As we are here to learn, we are going to manually install a Kubernetes cluster using the *kubeadm* tool.

To keep it simple, we will follow the instructions in [Creating a single control-plane cluster with kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/).

**note:** This assumes that you already [installed](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/) *kubeadm*.
