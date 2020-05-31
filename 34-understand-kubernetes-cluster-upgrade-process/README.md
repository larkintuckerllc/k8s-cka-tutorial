# Cluster Maintenance: Understand Kubernetes Cluster Upgrade Process

Back to [Certified Kubernetes Administrator (CKA) Tutorial](https://github.com/larkintuckerllc/k8s-cka-tutorial)

Also includes:

* Cluster Maintenance: Implement Backup and Restore Methodologies

[![Cluster Maintenance: Understand Kubernetes Cluster Upgrade Process](http://img.youtube.com/vi/XXXXX/0.jpg)]()

## Script

First, we can tell the current versions of both the Cluster and the Nodes using:

```plaintext
kubectl version

kubectl get nodes
```

### EKS

AWS EKS provides a turn-key upgrade process that requires little to no explanation.

> When a new Kubernetes version is available in Amazon EKS, you can update your cluster to the latest version.

*-AWS-[Updating an Amazon EKS cluster Kubernetes version}(https://docs.aws.amazon.com/eks/latest/userguide/update-cluster.html#1-16-prequisites)*

### Backup and Restore Strategies

It is more instructive to explore upgrading the Cluster that we installed with *kubeadm* and the first thing that we need to do is consider our backup and restore strategy.

> Make sure to back up any important components, such as app-level state stored in a database. kubeadm upgrade does not touch your workloads, only components internal to Kubernetes, but backups are always a best practice.

*-Kubernetes-[Upgrading kubeadm clusters](https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-upgrade/)*

**note**: It is interesting to observe that backup and restore are not mentioned in the AWS EKS documentation.

After a bit of searching, one recommended approach is to ensure that the K8s configuration is captured in configuration files stored in source control that get deployed through a continous integration process (allows for storing secret data outside of source control).

Another is to backup the database directly:

> All Kubernetes objects are stored on etcd. Periodically backing up the etcd cluster data is important to recover Kubernetes clusters under disaster scenarios, such as losing all master nodes. The snapshot file contains all the Kubernetes states and critical information. In order to keep the sensitive Kubernetes data safe, encrypt the snapshot files.

and

> Backing up an etcd cluster can be accomplished in two ways: etcd built-in snapshot and volume snapshop

*-Kubernetes-[Operating etcd clusters for Kubernetes](https://kubernetes.io/docs/tasks/administer-cluster/configure-upgrade-etcd/)*

**note:** We will not cover taking a volume snapshot.

**note**: Could not find any documentation on using *etcdctl* with EKS; even getting it to work with our *kubeadm* installed Cluster was tricky.

Download (and then uncompress):

```plaintext
wget https://github.com/etcd-io/etcd/releases/download/v3.4.9/etcd-v3.4.9-linux-amd64.tar.gz
```

Need to run as root (for certs):

Validate connectivity. Explain certificates.

```plaintext
ETCDCTL_API=3 \
  /home/ubuntu/etcd-v3.4.9-linux-amd64/etcdctl \
  --cacert /etc/kubernetes/pki/etcd/ca.crt \
  --cert /etc/kubernetes/pki/apiserver-etcd-client.crt \
  --key /etc/kubernetes/pki/apiserver-etcd-client.key \
  --debug \
  --endpoints https://127.0.0.1:2379 \
  endpoint status
```

Take a snapshot:

```plaintext
ETCDCTL_API=3 \
  /home/ubuntu/etcd-v3.4.9-linux-amd64/etcdctl \
  --cacert /etc/kubernetes/pki/etcd/ca.crt \
  --cert /etc/kubernetes/pki/apiserver-etcd-client.crt \
  --key /etc/kubernetes/pki/apiserver-etcd-client.key \
  --debug \
  --endpoints https://127.0.0.1:2379 \
  snapshot save snapshotdb
```

Verify:

```plaintext
ETCDCTL_API=3 \
  /home/ubuntu/etcd-v3.4.9-linux-amd64/etcdctl \
  --write-out=table snapshot status snapshotdb
```

This file can be used to restore the database using the *etcdctl* CLI tool.

### Upgrading kubeadm Clusters

Instructions are detailed:

> This page explains how to upgrade a Kubernetes cluster created with kubeadm from version 1.17.x to version 1.18.x, and from version 1.18.x to 1.18.y (where y > x).

*-Kubernetes-[Upgrading kubeadm clusters](https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-upgrade/)*

Will summarize steps:

Determine available versions

Upgrade *kubeadm*

Drain Control Plane Node (master); show:

```plaintext
kubectl drain ip-172-31-32-241 --ignore-daemonsets
```

Notice new taint too.

Plan upgrade; show:

```plaintext
kubadmn upgrade plan
```

Gives options to actually do upgrade.

**note:** Will have to consider upgrades of other addons; including Pod Networking CNI addon.

Uncordon master:

```plaintext
kubectl uncordon ip-172-31-32-241
```

Notice taints.

Upgrade additional Control Plane Nodes using same process; but different final command.

Update kubectl and kublet on all control plane nodes; includes restarting kublet.

For each Worker Node pretty much the same as the secondary control plane nodes.

**note**: Upgrade does create some temp files should the upgrade fail and you have to manually restore files.

Also, remember that upgrade process updates the TLS certificates that expire yearly; so regular updates addreses the need to update them.
