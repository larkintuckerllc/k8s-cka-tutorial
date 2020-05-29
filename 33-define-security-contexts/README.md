# Security: Define Security Context

Back to [Certified Kubernetes Administrator (CKA) Tutorial](https://github.com/larkintuckerllc/k8s-cka-tutorial)

[![Security: Define Security Context](http://img.youtube.com/vi/XXXXX/0.jpg)]()

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
