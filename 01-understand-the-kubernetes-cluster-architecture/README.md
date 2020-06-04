# Core Concepts: Understand the Kubernetes Cluster Architecture

Back to [Certified Kubernetes Administrator (CKA) Tutorial](https://github.com/larkintuckerllc/k8s-cka-tutorial)

**Addendum:** When discussing Cluster topologies, I said that the Control Plane runs on a Node. While this is the case some cases, it can also run outside of a Node; for example this is how it runs for Amazon EKS.

[![Core Concepts: Understand the Kubernetes Cluster Architecture](http://img.youtube.com/vi/lp9Swv1G5SI/0.jpg)](
https://youtu.be/lp9Swv1G5SI)

## Test Preparation: Relevant Kubernetes Documentation

None. This section is purely theory.

## Script

We start with a basic understanding of Kubernetes:

> Kubernetes is a portable, extensible, open-source platform for managing containerized workloads and services, that facilitates both declarative configuration and automation. It has a large, rapidly growing ecosystem. Kubernetes services, support, and tools are widely available.

*- Kubernetes - [What is Kubernetes?](https://kubernetes.io/docs/concepts/overview/what-is-kubernetes/)*

**note**: Kubernetes is often described as providing container orchestration.

And then, Kubernetes Clusters, Nodes, and Control Planes:

> A Kubernetes cluster consists of a set of worker machines, called nodes, that run containerized applications. Every cluster has at least one worker node.
The worker node(s) host the Pods that are the components of the application workload. The control plane manages the worker nodes and the Pods in the cluster. In production environments, the control plane usually runs across multiple computers and a cluster usually runs multiple nodes, providing fault-tolerance and high availability.

*- Kubernetes - [Kubernetes Components](https://kubernetes.io/docs/concepts/overview/components/)*

While sometimes considered part of the Control Plane, Kubernetes clusters have distinct etcd database(s):

> Consistent and highly-available key value store used as Kubernetes' backing store for all cluster data.

*- Kubernetes - [Kubernetes Components](https://kubernetes.io/docs/concepts/overview/components/)*

Kubernetes supports a range of Cluster topologies, including two high availability options:

- Single Node with etcd, Control Plane, and Worker

- Single Node with etcd and Control Plane; multiple Worker Nodes

- (High Availability-Stacked etdc) Multiple Nodes with etcd and Control Plane; multiple Worker Nodes

- (High Availability-External etcd) Multiple etcd hosts, multiple Control Plane Nodes; multiple Worker Nodes

Before we create our Kubernetes Cluster, we need to create a network to host the Nodes and/or etcd hosts:

One option is to place all Kubernetes resources into multiple public subnets spread across multiple Availablility Zones.

The AWS recommended option is to use a combination of public and private subnets:

> Public and private subnets - This VPC has two public and two private subnets. One public and one private subnet are deployed to the same Availability Zone. The other public and private subnets are deployed to a second Availability Zone in the same Region. We recommend this option for all production deployments. This option allows you to deploy your worker nodes to private subnets and allows Kubernetes to deploy load balancers to the public subnets that can load balance traffic to pods running on worker nodes in the private subnets.

*- AWS - [Creating a VPC for your Amazon EKS cluster](https://docs.aws.amazon.com/eks/latest/userguide/create-public-private-vpc.html)*

Because we are using a combination of public and private subnets, we require the use of a Bastion (or Jumpbox) host to login and troubleshoot the Kubernetes Nodes.

One benefit of using EKS is that it uses the High Availability-External etcd cluster topology and supports the public / private network configuration:

![k8s networking](k8s-network.png)

We now create an Amazon EKS cluster by following [Getting started with Amazon EKS](https://docs.aws.amazon.com/eks/latest/userguide/getting-started.html); using all the defaults

**note**: At the time of this writing, the *eksctl* CLI tool had an issue that prevented me from using it.

We also will want to deploy a Bastion host into the public subnet; e.g., launching an EC2 instance.

**note**: While I did install the Kubernetes cluster using the AWS Management Console, I replicated the resultant cluster configuration in a Terraform configuration available in the *terraform* folder.

We validate that Cluster is fully operational:

```plaintext
kubectl get nodes
```

We list our kubectl configuration; observe current context:

```plaintext
kubectl config view
```

We switch context:

```plaintext
kubectl config use-context arn:aws:eks:us-east-1:143287522423:cluster/k8s-cka-tutorial
```

**note**: Your context name will be different.

We wrap this up by running some troubleshooting commands on a Worker Node; we first add our PEM key to SSH Agent.

```plaintext
ssh-add ubuntu-laptop.pem
```

**note**: Your PEM file will be different.

We can now login to our Bastion host with:

```plaintext
ssh -A ec2-user@3.80.176.141
```

**note**: Your IP address will be different.

And from the Bastion host, we login to a Worker Node:

```plaintext
ssh 192.168.236.184
```

**note**: Your IP address will be different.

We can confirm that we are indeed on a Worker Node by observing that is running the *kublet* service:

```plaintext
systemctl status kubelet
```

We can also see that Docker is running a number of containers:

```plaintext
docker container ls
```

**note:** We will cover all this in more detail later.
