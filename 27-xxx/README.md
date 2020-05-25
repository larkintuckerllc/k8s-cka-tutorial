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

