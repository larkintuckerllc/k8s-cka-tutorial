# Storage: Understand Kubernetes Storage Objects

Back to [Certified Kubernetes Administrator (CKA) Tutorial](https://github.com/larkintuckerllc/k8s-cka-tutorial)

[![Storage: Understand Kubernetes Storage Objects](http://img.youtube.com/vi/XXXXX/0.jpg)]()

## Script

### Volumes (Temporary)

```plaintext
helm install dev empty-dir
```

### Volumes (Persistent)

Here we are going to create an EBS volume in the same AZ as our SINGLE node. In the more general example, of having multiple nodes in different AZ, we are going have to figure out how to schedule Pods on the correct Node to access the EBS!

```plaintext
kubectl describe node
```

Create EBS, update application config, install:

```plaintext
helm install dev persistent
```

Verify by using *lsblk* and *df -h*.

### PersistentVolume and PersistentVolumeClaim

This is an example of static provisioning.

> A cluster administrator creates a number of PVs. They carry the details of the real storage, which is available for use by cluster users. They exist in the Kubernetes API and are available for consumption.

```plaintext
helm install dev persistent-volume
```

> Each PV gets its own set of access modes describing that specific PV’s capabilities.

The access modes are:

* *ReadWriteOnce* – the volume can be mounted as read-write by a single node

* *ReadOnlyMany* – the volume can be mounted read-only by many nodes

* *ReadWriteMany* – the volume can be mounted as read-write by many nodes

*-Kubernetes-[Persistent Volumes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/)*

```plaintext
helm install dev persistent-volume
```

```plaintext
kubectl get pv
kubectl get pvc
```

Verify by using *lsblk* and *df -h*.

> When a user is done with their volume, they can delete the PVC objects from the API that allows reclamation of the resource. The reclaim policy for a PersistentVolume tells the cluster what to do with the volume after it has been released of its claim. Currently, volumes can either be Retained, Recycled, or Deleted.

* *Retain*: The Retain reclaim policy allows for manual reclamation of the resource.

* *Recycled*: If supported by the underlying volume plugin, the Recycle reclaim policy performs a basic scrub (rm -rf /thevolume/*) on the volume and makes it available again for a new claim.

**note**: Not support by AWS EBS.

* *Deleted*: For volume plugins that support the Delete reclaim policy, deletion removes both the PersistentVolume object from Kubernetes, as well as the associated storage asset in the external infrastructure, such as an AWS EBS, GCE PD, Azure Disk, or Cinder volume.

Delete Pod and PVC and observe status of PV.

> A volume will be in one of the following phases:

* *Available* – a free resource that is not yet bound to a claim

* *Bound* – the volume is bound to a claim

* *Released* – the claim has been deleted, but the resource is not yet reclaimed by the cluster

* *Failed* – the volume has failed its automatic reclamation

*-Kubernetes-[Persistent Volumes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/)*

At this point, the admin needs to manually reclaim, e.g., deal with data on backing storage, and then delete (and possibly recreate PV).

Try to recreate PVC and Pod with helm *upgrade*. Observe problem.

**note**: About Namespaces.

First, PersistentVolumes are not namespaced but PVCs are:

> Pods access storage by using the claim as a volume. Claims must exist in the same namespace as the Pod using the claim. The cluster finds the claim in the Pod’s namespace and uses it to get the PersistentVolume backing the claim

*-Kubernetes-[Persistent Volumes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/)*

### StorageClass

> When none of the static PVs the administrator created match a user’s PersistentVolumeClaim, the cluster may try to dynamically provision a volume specially for the PVC. This provisioning is based on StorageClasses: the PVC must request a storage class and the administrator must have created and configured that class for dynamic provisioning to occur.

*-Kubernetes-[Persistent Volumes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/)*

