# Security: Define Security Context

Back to [Certified Kubernetes Administrator (CKA) Tutorial](https://github.com/larkintuckerllc/k8s-cka-tutorial)

[![Security: Define Security Context](http://img.youtube.com/vi/tUbZco7ps3g/0.jpg)](https://youtu.be/tUbZco7ps3g)

## Script

### Basic securityContext

> A security context defines privilege and access control settings for a Pod or Container. Security context settings include, but are not limited to:

* Discretionary Access Control: Permission to access an object, like a file, is based on user ID (UID) and group ID (GID).

*-Kubernetes-[Configure a Security Context for a Pod or Container](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/)*

The actual list of settings is fairly extensive.

Let us with the default Pod behavior:

```plaintext
helm install dev none
```

Use *id* and *ps aux* commands to observe UID and GID. Create file in */tmp* to validate.

Let us lock down the user and group:

```plaintext
helm install dev basic
```

Look at example of *user-group-fs.yaml*.

**note**: The user and group *securityContext* options can be applied at the Pod or Container level.

Notice the settings:

> AllowPrivilegeEscalation controls whether a process can gain more privileges than its parent process. This bool directly controls if the no_new_privs flag will be set on the container process.

and

> readOnlyRootFilesystem: Mounts the container’s root filesystem as read-only.

*-Kubernetes-[Configure a Security Context for a Pod or Container](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/)*

Repeat checking user and group.

Look at example of *user-group-fs-pod.yaml*.

Create file in mounted volume to confirm behavior.

**note:**  There is a separate concept of provileged mode.

> Any container in a Pod can enable privileged mode, using the privileged flag on the security context of the container spec. This is useful for containers that want to use Linux capabilities like manipulating the network stack and accessing devices. Processes within the container get almost the same privileges that are available to processes outside a container.

*-Kubernetes-[Pods](https://kubernetes.io/docs/concepts/workloads/pods/pod/)*

### capabilities

> For the purpose of performing permission checks, traditional UNIX
       implementations distinguish two categories of processes: privileged
       processes (whose effective user ID is 0, referred to as superuser or
       root), and unprivileged processes (whose effective UID is nonzero).
       Privileged processes bypass all kernel permission checks, while
       unprivileged processes are subject to full permission checking based
       on the process's credentials (usually: effective UID, effective GID,
       and supplementary group list).

and

 > Starting with kernel 2.2, Linux divides the privileges traditionally
       associated with superuser into distinct units, known as capabilities,
       which can be independently enabled and disabled.  Capabilities are a
       per-thread attribute.

-Linux Man-[capabilities](https://www.man7.org/linux/man-pages/man7/capabilities.7.html)

First, containers define what capabilities they run with.

```plaintext
helm install dev none
```

Install *apt-get install libcap2-bin*  and run *capsh --print*. Notice *chown* capability.

Create file */tmp/test* and chown it to *nobody*.

Can override with *add* and *drop*:

```plaintext
helm install dev cap
```

Notice cannot chown file.

### Pod Security Policy

> A Pod Security Policy is a cluster-level resource that controls security sensitive aspects of the pod specification. The PodSecurityPolicy objects define a set of conditions that a pod must run with in order to be accepted into the system, as well as defaults for the related fields.

and

> Pod security policy control is implemented as an optional (but recommended) admission controller. PodSecurityPolicies are enforced by enabling the admission controller, but doing so without authorizing any policies will prevent any pods from being created in the cluster.

and

> When a PodSecurityPolicy resource is created, it does nothing. In order to use it, the requesting user or target pod’s service account must be authorized to use the policy, by allowing the use verb on the policy.

and

> Most Kubernetes pods are not created directly by users. Instead, they are typically created indirectly as part of a Deployment, ReplicaSet, or other templated controller via the controller manager. Granting the controller access to the policy would grant access for all pods created by that controller, so the preferred method for authorizing policies is to grant access to the pod’s service account (see example).

*-Kubernetes-[Pod Security Policies](https://kubernetes.io/docs/concepts/policy/pod-security-policy/)*

> Amazon EKS clusters with Kubernetes version 1.13 and higher have a default pod security policy named eks.privileged. This policy has no restriction on what kind of pod can be accepted into the system, which is equivalent to running Kubernetes with the PodSecurityPolicy controller disabled.

*-AWS-[Pod security policy](https://docs.aws.amazon.com/eks/latest/userguide/pod-security-policy.html)*

```plaintext
kubectl get psp

kubectl describe psp eks.privileged

kubectl describe clusterrole eks:podsecuritypolicy:privileged

 kubectl describe clusterrolebinding eks:podsecuritypolicy:authenticated
```

### Locking Down Default

First, we need to preserve privileged for other Namespaces.

```plaintext
helm install psp-system psp-system
```

Next need to delete cluster-wide privileged binding:

```plaintext
kubectl delete  clusterrolebinding eks:podsecuritypolicy:authenticated
```

Now we can validate that we have a problem:

```plaintext
helm install dev deployment
```

We fix the problem:

```plaintext
helm install psp-default psp-default
```

We validate success:

```plaintext
helm install dev deployment
```

and validate failure:

```plaintext
helm install dev deployment-priv
```
