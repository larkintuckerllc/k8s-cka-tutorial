# Certified Kubernetes Administrator (CKA) Tutorial

[![Core Concepts: Understand the Kubernetes Cluster Architecture](http://img.youtube.com/vi/VdkDxGsQhmY/0.jpg)](https://youtu.be/VdkDxGsQhmY)

## Videos

*[Core Concepts: Understand the Kubernetes Cluster Architecture](01-understand-the-kubernetes-cluster-architecture)*  
*Keywords*: Cluster, Node, Control Plane, etcd, Cluster Topology

*[Core Concepts: Understand the Kubernetes API Primitives](02-understand-the-kubernetes-api-primitives)*  
*Keywords*: API Group, API Resource, Namespace, Addons, Metrics Server

*[Installation, Configuration & Validation: Install Kubernetes Masters and Node](03-install-kubernetes-masters-and-nodes)*  
*Keywords*: kubeadm, kube-api-server, kube-controller-manager, kube-scheduler, cloud-controller-manager, kublet, kube-proxy, etcd

*[Security: Know How to Configure Authentication and Authorization](04-know-how-to-configure-authentication-and-authorization)*  
*Keywords*: Authentication, Authorization, Adminission Control, Transport Security, User, Client Certificate Authentication

*[Security: Know How to Configure Authentication and Authorization](05-know-how-to-configure-authentication-and-authorization)*  
*Keywords*: AWS Authentication, Role-Based Access Control, Authorization Rules, ClusterRole, RoleBinding, ClusterRoleBinding

*[Security: Know How to Configure Authentication and Authorization](06-know-how-to-configure-authentication-and-authorization)*  
*Keywords*: ConfigMap, Role

*[Core Concepts: Understand the Kubernetes API Primitives](07-understand-the-kubernetes-api-primitives)*  
*Keywords*: Metadata, Labels, Annotations, spec, status, Imperative Commands, Imperative Object Configuration, Declarative Object Configuration

*[Core Concepts: Understand the Kubernetes API Primitives](08-understand-the-kubernetes-api-primitives)*  
*Keywords*: Helm

*[Core Concepts: Understand the Kubernetes API Primitives](09-understand-the-kubernetes-api-primitives)*  
*Keywords*: Kustomize

*[Application Lifecycle Management: Know Various Ways to Configure Applications](10-know-various-ways-to-configure-applications)*  
*Keywords*: Pod, Container, Pod Event, Pod Status (Phase), Pod Condition, Container State, Container Environment

*[Application Lifecycle Management: Know Various Ways to Configure Applications](11-know-various-ways-to-configure-applications)*  
*Keywords*: Container Lifecycle Hook, Probe, readinessGates

*[Networking: Understand Pod Networking Concepts](12-understand-pod-networking-concepts)*  
*Keywords*: Container Logs, Intra-Pod Networking, Inter-Pod (Cluster) Networking, Intra-Pod IPC

*[Application Lifecycle Management: Understand the primitives necessary to create a self-healing application](13-understand-self-healing-application)*  
*Keywords*: ReplicaSet, Horizontal Pod Autoscaler

*[Application Lifecycle Management: Understand the primitives necessary to create a self-healing application](14-understand-self-healing-application)*  
*Keywords*: Deployment, DaemonSet, StatefulSet

*[Application Lifecycle Management: Understand Deployments and How to Perform Rolling Update and Rollbacks](15-understand-deployments)*  
*Keywords*: Deployment Revision, Job, CronJob

*[Core Concepts: Understand Services and other Network Primitives](16-understand-services)*  
*Keywords*: Service, ClusterIP, Endpoints, Service Mode, Container Network Interface (CNI)

*[Deploy and Configure Network Load Balancer](17-network-load-balancer)*  
*Keywords*: LoadBalancer, NodePort, ExternalName, Headless Service

*[Networking: Know How to Configure and Use the Cluster DNS](18-configure-and-use-cluster-dns)*  
*Keywords*: CoreDNS, kube-dns, Pod DNS Policy, Pod DNS Config

## Script

First a disclaimer...  These videos were made as part of my preparation for the CKA certification exam.

The material is organizied around the official curriculum:

[Open Source Curriculum for CNCF Certification Courses](https://github.com/cncf/curriculum)

This tutorial is very different than your typical K8s tutorial, e.g.:

[Tutorials](https://kubernetes.io/docs/tutorials/)

Those tutorial get to the "fun stuff", e.g., Pods, containers, etc, at the start.  This is more appropriate for a first taste of K8s.

This tutorial, however, starts with more of the fundamentals, e.g., cluster topology, authentication, etc. The thinking here is that you already know you want to learn K8s.

While the official curriculum provided the organization, the bulk of the content comes from the K8s concepts section.

[Concepts](https://kubernetes.io/docs/concepts/)

Finally, there are also a number of K8s preparation course available (most were around $300 or so) that you might find valuable. Without naming names, I was fairly unsatisfied with the one that I took and thus was born this tutorial (I needed more hands on practice).
