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

