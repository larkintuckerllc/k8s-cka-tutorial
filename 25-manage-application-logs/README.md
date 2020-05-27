# Logging/Monitoring: Manage Application Logs

Back to [Certified Kubernetes Administrator (CKA) Tutorial](https://github.com/larkintuckerllc/k8s-cka-tutorial)

**Addendum:** Should have mentioned that one uses the *--previous* flag with *kubectl logs* to get the logs from the previous container.

[![Logging/Monitoring: Manage Application Logs](http://img.youtube.com/vi/SeDwgzZcPIQ/0.jpg)](https://youtu.be/SeDwgzZcPIQ)

## Script

### Basic logging in Kubernetes

> Everything a containerized application writes to stdout and stderr is handled and redirected somewhere by a container engine.

and

> By default, if a container restarts, the kubelet keeps one terminated container with its logs. If a pod is evicted from the node, all corresponding containers are also evicted, along with their logs.

*-Kubernetes-[Logging Architecture](https://kubernetes.io/docs/concepts/cluster-administration/logging/)*

Remind oneself that we can get these container logs with *kubectl logs*.

```plaintext
helm install logger
```

Watch tail of logs.

### Sidebar into command vs args

Ran into something that I missed, thought to share.

Docker containers can specify a default:

ENTRYPOINT: ["executable", "param1", "param2"]

CMD: ["executable","param1","param2"] 

CMD: ["param1","param2"] (as default parameters to ENTRYPOINT)

In k8s...

> When you override the default Entrypoint and Cmd, these rules apply:

* If you do not supply command or args for a Container, the defaults defined in the Docker image are used.

* If you supply a command but no args for a Container, only the supplied command is used. The default EntryPoint and the default Cmd defined in the Docker image are ignored.

* If you supply only args for a Container, the default Entrypoint defined in the Docker image is run with the args that you supplied.

* If you supply a command and args, the default Entrypoint and the default Cmd defined in the Docker image are ignored. Your command is run with your args.

*-Kubernetes-[Define a Command and Arguments for a Container](https://kubernetes.io/docs/tasks/inject-data-application/define-command-argument-container/)*

### Streaming Sidecar Container

Used if a container does not write its logs to STDOUT and STRERR. Example:

```plaintext
helm install dev sidecar
```

Leave sidecar running.

### Node-Level Logging

> An important consideration in node-level logging is implementing log rotation, so that logs don’t consume all available storage on the node. Kubernetes currently is not responsible for rotating logs, but rather a deployment tool should set up a solution to address that.

*-Kubernetes-[Logging Architecture](https://kubernetes.io/docs/concepts/cluster-administration/logging/)*

Could not find any documentation on how EKS configures the Nodes for log rotation; but it is easy enough to check.

Connect to a Node through the bastion host and examine the following configuration file.

```plaintext
cat /etc/docker/daemon.json
```

### Sidebar into fluentd

In many cases, including EKS, discussions around aggregating logs often include using Fluentd under the hood. Wanted to quickly demystify what it is and does.

> Let's get started with Fluentd! Fluentd is a fully free and fully open-source log collector that instantly enables you to have a 'Log Everything' architecture with 125+ types of systems.

![FluentD Architecture](fluentd-architecture.png)

### Cluster-Level Logging

While there other solutions exist, we will focus on cluster-level logging that builds upon the Node-level logging we saw.

Other solutions:

![Other Application](logging-from-application.png)

![Other Sidecar](logging-with-sidecar-agent.png)

Node agent solution:

![Node Agent](logging-with-node-agent.png)

AWS provides solution for managing metrics and logs from EKS; will focus on logs for now.

> Use CloudWatch Container Insights to collect, aggregate, and summarize metrics and logs from your containerized applications and microservices. Container Insights is available for Amazon Elastic Container Service, Amazon Elastic Kubernetes Service, and Kubernetes platforms on Amazon EC2. The metrics include utilization for resources such as CPU, memory, disk, and network. Container Insights also provides diagnostic information, such as container restart failures, to help you isolate issues and resolve them quickly. You can also set CloudWatch alarms on metrics that Container Insights collects.

*-AWS-[Using Container Insights](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/ContainerInsights.html)*

Offscreen, followed the quickstart.

```plaintext
kubectl get pods -n amazon-cloudwatch
```

Observe the log entries in CloudWatch:

* */aws/containerinsights/Cluster_Name/host*: os logging

* */aws/containerinsights/Cluster_Name/dataplane*: systemd logging

* */aws/containerinsights/Cluster_Name/application*: container logging

In particular, find our container
