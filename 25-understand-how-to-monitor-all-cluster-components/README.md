# Logging/Monitoring: Understand How to Monitor All Cluster Components

Back to [Certified Kubernetes Administrator (CKA) Tutorial](https://github.com/larkintuckerllc/k8s-cka-tutorial)

[![Scheduling: Use Label Selectors to Schedule Pods](http://img.youtube.com/vi/XXXXX/0.jpg)]()

## Script

### Basic logging in Kubernetes

This is a repeat of content we explored earlier.

> Everything a containerized application writes to stdout and stderr is handled and redirected somewhere by a container engine.

and

> By default, if a container restarts, the kubelet keeps one terminated container with its logs. If a pod is evicted from the node, all corresponding containers are also evicted, along with their logs.

and

> An important consideration in node-level logging is implementing log rotation, so that logs don’t consume all available storage on the node. Kubernetes currently is not responsible for rotating logs, but rather a deployment tool should set up a solution to address that.

*-Kubernetes-[Logging Architecture](https://kubernetes.io/docs/concepts/cluster-administration/logging/)*

Could not find any documentation on how EKS configures the Nodes for log rotation; but it is easy enough to check.

Connect to a Node through the bastion host and examine the following configuration file.

```plaintext
cat /etc/docker/daemon.json
```

### Cluster-Level Logging Architecture

> While Kubernetes does not provide a native solution for cluster-level logging, there are several common approaches you can consider. Here are some options:

* Use a node-level logging agent that runs on every node.

* Include a dedicated sidecar container for logging in an application pod.

* Push logs directly to a backend from within an application.

*-Kubernetes-[Logging Architecture](https://kubernetes.io/docs/concepts/cluster-administration/logging/)*

AWS provides solution for managing metrics and logs from EKS.

> Use CloudWatch Container Insights to collect, aggregate, and summarize metrics and logs from your containerized applications and microservices. Container Insights is available for Amazon Elastic Container Service, Amazon Elastic Kubernetes Service, and Kubernetes platforms on Amazon EC2. The metrics include utilization for resources such as CPU, memory, disk, and network. Container Insights also provides diagnostic information, such as container restart failures, to help you isolate issues and resolve them quickly. You can also set CloudWatch alarms on metrics that Container Insights collects.

*-AWS-[Using Container Insights](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/ContainerInsights.html)*

Observe the log entries from the Ubuntu container in the Pod.
