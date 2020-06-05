# Logging/Monitoring: Understand How to Monitor All Cluster Components

Back to [Certified Kubernetes Administrator (CKA) Tutorial](https://github.com/larkintuckerllc/k8s-cka-tutorial)

Includes:

* Logging/Monitoring: Understand How to Monitor Applications

[![Logging/Monitoring: Understand How to Monitor All Cluster Components](http://img.youtube.com/vi/DGfDbCYDRXs/0.jpg)](https://youtu.be/DGfDbCYDRXs)

## Test Preparation: Relevant Kubernetes Documentation

None

## Script

### Metrics For The Kubernetes Control Plane

> System component metrics can give a better look into what is happening inside them. Metrics are particularly useful for building dashboards and alerts.

and

> Metrics in Kubernetes control plane are emitted in prometheus format and are human readable.

and

> In most cases metrics are available on /metrics endpoint of the HTTP server. For components that doesn’t expose endpoint by default it can be enabled using --bind-address flag.

* kube-controller-manager

* kube-proxy

* kube-apiserver

* kube-scheduler

* kubelet

For example, we can get the metrics for kube-apiserver fairly directly:

```plaintext
kubectl get --raw /metrics
```

For Kublet (and specifically the containers), we can get it indirectly through kube-apiserver:

```plaintext
kubectl get --raw /api/v1/nodes/ip-192-168-176-205.ec2.internal/proxy/metrics/cadvisor
```

For some other (sort-of) Control Plane element:

```plaintext
kubectl --namespace=kube-system port-forward deployment/coredns 9090:9153
```

**note**: For AWS, we cannot directly interact with the other Control Plane elements, e.g., kube-scheduler.

### Metrics Server

One confusing thing is the relationship between the Metrics Server and the various aformentioned */metrics* endpoints.

> The resource metrics pipeline provides a limited set of metrics related to cluster components such as the Horizontal Pod Autoscaler controller, as well as the kubectl top utility. These metrics are collected by the lightweight, short-term, in-memory metrics-server and are exposed via the metrics.k8s.io API.

and

> metrics-server discovers all nodes on the cluster and queries each node’s kubelet for CPU and memory usage. The kubelet acts as a bridge between the Kubernetes master and the nodes, managing the pods and containers running on a machine. The kubelet translates each pod into its constituent containers and fetches individual container usage statistics from the container runtime through the container runtime interface. The kubelet fetches this information from the integrated cAdvisor for the legacy Docker integration. It then exposes the aggregated pod resource usage statistics through the metrics-server Resource Metrics API. This API is served at /metrics/resource/v1beta1 on the kubelet’s authenticated and read-only ports.

*-Kubernetes-[Tools for Monitoring Resources](https://kubernetes.io/docs/tasks/debug-application-cluster/resource-usage-monitoring/)*

Key points:

* Metrics Server aggregates data from the Node API and exposes a summary API on kube-apiserver; replaces what used to be done by Heapster

* This summary API is used by the *kubectl top* command as well as the Horizontal Pod Autoscaler controller

* Other tools DO NOT use the aggregated Metrics Server API. The get their information more directly from the Control Plane metrics directly.

```plaintext
helm install dev stress-cpu
```

Leave running.

Notice the API endpoint exposed by Metrics Server.

```plaintext
kubectl get --raw /apis/metrics.k8s.io/v1beta1/namespaces/default/pods/stress-cpu-dev
```

As opposed to the raw data from Kublet:

```plaintext
kubectl get --raw /api/v1/nodes/ip-192-168-176-205.ec2.internal/proxy/metrics/cadvisor
```

### Container Metrics

> CPU is reported as the average usage, in CPU cores, over a period of time. This value is derived by taking a rate over a cumulative CPU counter provided by the kernel (in both Linux and Windows kernels).

and

> Memory is reported as the working set, in bytes, at the instant the metric was collected. In an ideal world, the “working set” is the amount of memory in-use that cannot be freed under memory pressure.

*-Kubernetes-[Resource metrics pipeline](https://kubernetes.io/docs/tasks/debug-application-cluster/resource-metrics-pipeline/)*

### CPU

Again the raw container metrics originate from Kublets */metrics* endpoint, but are aggregated into:

Metrics from Metrics Server:

```plaintext
kubectl top pod

kubectl top node
```

Metrics from AWS Container Insights.

Makes sense since we are using a t3-medium with 2 vCPU.

### Memory

Similarly for memory.

```plaintext
helm install dev stress-memory
```

Leave running to end.

```plaintext
kubectl top pod

kubectl top node
```

**note**: Not as stable as CPU.

Metrics from AWS Container Insights.

Makes sense since we are using a t3-medium with 4 Gi memory.

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

```plaintext
kubectl --namespace=prometheus port-forward deploy/prometheus-server 9090
```

Look at *container_memory_usage_bytes*.

Also, observe all the other metrics from the various Control Plane that we can see.

**note:** Finally, while outside the scope of this series, you can also create your own custom application metrics and expose them to Prometheus.
