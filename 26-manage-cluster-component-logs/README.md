# Logging/Monitoring: Manage Cluster Component Logs

Back to [Certified Kubernetes Administrator (CKA) Tutorial](https://github.com/larkintuckerllc/k8s-cka-tutorial)

Also includes:

* Troubleshooting: Troubleshoot control plane failure

* Troubleshooting: Troubleshoot worker node failure

[![Logging/Monitoring: Manage Cluster Component Logs](http://img.youtube.com/vi/X_1hJHBXbRk/0.jpg)](https://youtu.be/X_1hJHBXbRk)

## Test Preparation: Relevant Kubernetes Documentation

None

## Script

> There are two types of system components: those that run in a container and those that do not run in a container. For example:

and

> The Kubernetes scheduler and kube-proxy run in a container.
The kubelet and container runtime, for example Docker, do not run in containers.
On machines with systemd, the kubelet and container runtime write to journald. If systemd is not present, they write to .log files in the /var/log directory. System components inside containers always write to the /var/log directory, bypassing the default logging mechanism. They use the klog logging library. You can find the conventions for logging severity for those components in the development docs on logging.

*-Kubernetes-[Logging Architecture](https://kubernetes.io/docs/concepts/cluster-administration/logging/)*

### Node OS

OS log: */var/log/messages*

OS security log: */var/log/secure*

Look at CloudWatch entry at: */aws/containerinsights/Cluster_Name/host*

### Container Engine (Docker)

**note:** First, we can see the container logs directly using Docker.

```plaintext
docker logs XXXXX
```

We can see Docker Daemon logs.

```plaintext
journalctl -u docker.service -f
```

Look at CloudWatch entry at: */aws/containerinsights/Cluster_Name/dataplane*

### Kubelet

```plaintext
journalctl -u kubelet.service -f
```

Look at CloudWatch entry at: */aws/containerinsights/Cluster_Name/dataplane*

### kube-proxy (and other system Daemons)

While the K8s documents would suggest that the logging for *kube-proxy* would by-pass the normal container logging approach, it does appear to be the case for AWS eks.

Observe, that there is no */var/log/kube-proxy.log* on the Node but there is container logs:

```plaintext
kubectl logs kube-proxy-X
```

Look at CloudWatch entry at: */aws/containerinsights/Cluster_Name/host*

### Control Plane

The K8s documentation suggest that the control plane logging (on the Master Node) is in the following locations:

* /var/log/kube-apiserver.log

* /var/log/kube-scheduler.log

* /var/log/kube-controller-manager.log

But in the case of AWS EKS, the control plane does run on a host we have access to. It is however available in CloudWatch on a feature by feature basis.

Show configuration in AWS.

Show log in CloudWatch
