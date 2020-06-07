# Certified Kubernetes Administrator (CKA) Tutorial

**Addendum**: After the *Videos* section below, I summarized some test preparation steps that I found useful.

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

*[Security: Create and Manage TLS Certificates for Cluster Components](19-create-manage-tls-certificates)*  
*Keywords*: Certificate Authority, CertificateSigningRequest

*[Networking: Know How to Use Ingress Rules](20-know-how-to-use-ingress-rules)*  
*Keywords*: Ingress Controller, Ingress

*[Security: Know How to Configure Network Policies](21-know-how-to-configure-network-policies)*  
*Keywords*: Network Policy

*[Storage: Understand Kubernetes Storage Objects](22-understand-kubernetes-storage-objects)*  
*Keywords*: PersistentVolume, PersistentVolumeClaim, StorageClaim 

*[Scheduling: Use Label Selectors to Schedule Pods](23-use-label-selectors-to-schedule-pods)*  
*Keywords*: nodeName, nodeSelector, nodeAffinity, podAffinity, podAntiAffinity

*[Scheduling: Use Label Selectors to Schedule Pods](24-use-label-selectors-to-schedule-pods)*  
*Keywords*: Taint, Toleration

*[Logging/Monitoring: Manage Application Logs](25-manage-application-logs)*  
*Keywords*: Sidecar Container, fluentd, Node Agent  

*[Logging/Monitoring: Manage Cluster Component Logs](26-manage-cluster-component-logs)*  
*Keywords*:

*[Logging/Monitoring: Understand How to Monitor All Cluster Components](27-understand-how-to-monitor-all-cluster-components)*  
*Keywords*: Metrics Server, Dashboard, Prometheus 

*[Security: Secure Persistent Key Value Store](28-secure-persistent-key-value-store)*  
*Keywords*: ConfigMap, Secret

*[Security: Know How to Configure Authentication and Authorization](29-know-how-to-configure-authentication-and-authorization)*  
*Keywords*: ServiceAccount

*[Scheduling: Understand How Resource Limits Can Affect Pod Scheduling](30-understand-resource-limits)*  
*Keywords*: Resource Request, Resource Limits

*[Scheduling: Understand How Resource Limits Can Affect Pod Scheduling](31-understand-resource-limits)*  
*Keywords*: QoS Class, PriorityClass

*[Scheduling: Understand How Resource Limits Can Affect Pod Scheduling](32-understand-resource-limits)*  
*Keywords*: LimitRange, ResourceQuota 

*[Security: Define Security Context](33-define-security-contexts)*  
*Keywords*: securityContext, PodSecurityPolicy

*[Cluster Maintenance: Understand Kubernetes Cluster Upgrade Process](34-understand-kubernetes-cluster-upgrade-process)*  
*Keywords*: kubeadm, etcdctl

*[Security: Work with Images Securely](35-work-with-images-securely)*  
*Keywords*: imagePullSecrets

*[Installation, Configuration & Validation: Configure a Highly-Available Kubernetes Cluster](36-configure-a-highly-available-k8s-cluster)*  
*Keywords*: kubeadm

## Test Preparation

While it has an unusual URL, I found the [Kubernetes Exam Simulator](https://killer.sh/) well worth the money.

Also, as you can use the official Kubernetes documentation during the exam, it is important to be able to navigate it quickly. The assumption is that you already know the theory, but need to use the documentation to remember the specific configuration syntax.

As a exercise, I went back to each section and added my thoughts on how to find the relevant configuration syntax.

In the interest of time, there are a number of things to know off the top of your head:

### Misc Not kubectl

* Create time saving CLI shortcuts: *alias k=kubctl* and *do="--dry-run=client -o yaml"*

* Get status and logs from Node service: *kublet* and *docker*: *systemctl --type service*, *systemctl status XXXXX*, and *journalctl -u XXXXX*

* Extract text out of certificates: *openssl x509 -text -in XXXX*

* Retrieve iptables on a Node: *iptables-save*

### Misc kubectl

**note:** Can use ranges in CLI, i.e., *{1..3}*

* Copy files to a container: *k cp --help*

* Delete resources: *k delete XXXXX XXXXX*; to return quickly from Pod deletion use *--wait=false*

* Label resources: *k label XXXXX XXXX*

* Annotate resouces: *k annotate XXXXX XXXXX*

* Validate authorization: *k auth can-i XXXXX XXXXX [-as XXXXXX]*

### Inspection

* Manipulate the kubectl configuration file:  *k config view*, *k config use-context XXXXX*

* Get API groups / resource: *k api-versions* and *k api-resources -o wide*

* Get application-centric resources from a namespace: *k get all -n XXXXX -o wide*

* Run temporary Pod to hit a URL: *k run tmp --restart=Never --rm --image=busybox -it -- wget -O- -T 3 XXXXX*

* Create configuration file from live resource: *k get XXXXX XXXXX -o yaml

* Login to a Pod: *k exec XXXXX -it -- sh*

* Learn to use basic JSONPath, [JSONPath Support](https://kubernetes.io/docs/reference/kubectl/jsonpath/); often helpful in getting specific summary information from an array of objects

* Learn to sort results, principally by time, e.g.,  *--sort-by=.metadata.creationTimestamp*

### Imperative Creation

**note:** Need to pay attention to namespaces, i.e., supply the *-n XXXXX* option to add *namespace* to configuration file after generating it with *$do* option.

**note:** Also the *--help* option is super helpful here.

* Create a Pod: *k run XXXXX --image=XXXXX*

* Create a Namespace: *k create namespace XXXX*

* Create a Deployment: *k create deployment XXXXX --image =XXXXX*

* Create a Service: *k expose deployment XXXXX --port=XX --target-port=XX*

* Create an Job, CronJob...: *k create --help*

### Deployment Manipulation

* History: *k rollout history deployment XXXXX*

* Status: *k rollout status deployment XXXXX [--revision=X]*

* Undo: *k rollout undo deployment XXXXX [--to-revision=X]*

* Pause: *k rollout pause deployment XXXXX*

* Set Image: *k set image --help*

* Autoscale: *k autoscale --help*

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
