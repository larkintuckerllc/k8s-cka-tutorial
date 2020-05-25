# TODO

Back to [Certified Kubernetes Administrator (CKA) Tutorial](https://github.com/larkintuckerllc/k8s-cka-tutorial)

[![TODO](http://img.youtube.com/vi/XXXXX/0.jpg)]()

## Script

### Metrics Sources and Sinks

One thing that confused me was the relationship between Metrics Server, the Metrics API, and tools for aggregating metrics (Prometheus or AWS Container Insights).

> The resource metrics pipeline provides a limited set of metrics related to cluster components such as the Horizontal Pod Autoscaler controller, as well as the kubectl top utility. These metrics are collected by the lightweight, short-term, in-memory metrics-server and are exposed via the metrics.k8s.io API.

and

> metrics-server discovers all nodes on the cluster and queries each node’s kubelet for CPU and memory usage. The kubelet acts as a bridge between the Kubernetes master and the nodes, managing the pods and containers running on a machine. The kubelet translates each pod into its constituent containers and fetches individual container usage statistics from the container runtime through the container runtime interface. The kubelet fetches this information from the integrated cAdvisor for the legacy Docker integration. It then exposes the aggregated pod resource usage statistics through the metrics-server Resource Metrics API. This API is served at /metrics/resource/v1beta1 on the kubelet’s authenticated and read-only ports.

*-Kubernetes-[Tools for Monitoring Resources](https://kubernetes.io/docs/tasks/debug-application-cluster/resource-usage-monitoring/)*

Key points:

* Kublet exposes metric data gathered from Container Engine on an API on each Node

* Metrics Server aggregates data from the Node API and exposes a summary API on kube-apiserver; replaces what used to be done by Heapster

* The summary API is used by the *kubectl top* command as well as the Horizontal Pod Autoscaler controller

* Other tools DO NOT use the aggregated Metrics Server API. It is unclear if they use the Kublet API or directly inquire the Container Engine

### Metrics

> CPU is reported as the average usage, in CPU cores, over a period of time. This value is derived by taking a rate over a cumulative CPU counter provided by the kernel (in both Linux and Windows kernels).

and

> Memory is reported as the working set, in bytes, at the instant the metric was collected. In an ideal world, the “working set” is the amount of memory in-use that cannot be freed under memory pressure.

*-Kubernetes-[Resource metrics pipeline](https://kubernetes.io/docs/tasks/debug-application-cluster/resource-metrics-pipeline/)*

### CPU

**note:** Metrics collection interval is 1 minute (minimum of 15 seconds).

> metrics_collection_interval – In the kubernetes section, you can specify how often the agent collects metrics. The default is 60 seconds. The default cadvisor collection interval in kubelet is 15 seconds, so don't set this value to less than 15 seconds.

*-AWS-[Set Up the CloudWatch Agent to Collect Cluster Metrics](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Container-Insights-setup-metrics.html)*

```plaintext
helm install dev stress-cpu
```

Metrics from Metrics Server:

```plaintext
kubectl top pod

kubectl top node
```

Makes sense since we are using a t3-medium with 2 vCPU.

Metrics from AWS Container Insights.

### Memory

```plaintext
helm install dev stress-memory
```

```plaintext
kubectl top pod

kubectl top node
```

**note**: Not as stable as CPU.

Makes sense since we are using a t3-medium with 4 Gi memory.

Metrics from AWS Container Insights.

### Dashboard

We can see this same data using the [Kubernetes Dashboard](https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/).

Installed off-screen.

See both Node and Pod utilization.

### Prometheus

When it comes to monitoring application, Prometheus often comes up.

> Prometheus is an open-source systems monitoring and alerting toolkit originally built at SoundCloud. Since its inception in 2012, many companies and organizations have adopted Prometheus, and the project has a very active developer and user community. It is now a standalone open source project and maintained independently of any company.

![Prometheus Architecture](architecture.png)

*-Prometheus-[Overview](https://prometheus.io/docs/introduction/overview/)*

**note**: Ran into a EKS limit when installing Prometheus; [Max Pods](https://github.com/awslabs/amazon-eks-ami/blob/master/files/eni-max-pods.txt)

Just a quick dip into Prometheus; details are out of scope.

[Control plane metrics with Prometheus](https://docs.aws.amazon.com/eks/latest/userguide/prometheus.html)
