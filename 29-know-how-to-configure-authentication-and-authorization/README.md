# Security: Know How to Configure Authentication and Authorization

Back to [Certified Kubernetes Administrator (CKA) Tutorial](https://github.com/larkintuckerllc/k8s-cka-tutorial)

[![Security: Know How to Configure Authenication and Authorization](http://img.youtube.com/vi/a84w2maFWI4/0.jpg)](https://youtu.be/a84w2maFWI4)

## Test Preparation: Relevant Kubernetes Documentation

Search for *service account* to find [Configure Service Accounts for Pods](https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/).

## Script

### default ServiceAccount in default

> When you (a human) access the cluster (for example, using kubectl), you are authenticated by the apiserver as a particular User Account (currently this is usually admin, unless your cluster administrator has customized your cluster). Processes in containers inside pods can also contact the apiserver. When they do, they are authenticated as a particular Service Account (for example, default).

*-Kubernetes-[Configure Service Accounts for Pods](https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/)*

Let us look at this ServiceAccount that was created automatically when the *default* Namespace was created; notice that these are Namespaced objects:

```plaintext
kubectl describe sa default

kubectl get secret
```

You may have already seen this, but the *token* Secret has a bearer token that can be used to authenticate when making a REST API call to the K8s kube-apiserver.

Example:

* Get encoded token out of Secret with describe (already decoded)

* Get URL out of .kube/config

* curl URL

* curl --insecure URL

* curl --insecure -H "Authorization: bearer TOKEN" URL

* Observe account and lack of access

> Default RBAC policies grant scoped permissions to control-plane components, nodes, and controllers, but grant no permissions to service accounts outside the kube-system namespace (beyond discovery permissions given to all authenticated users).

and

> This allows you to grant particular roles to particular ServiceAccounts as needed. Fine-grained role bindings provide greater security, but require more effort to administrate. Broader grants can give unnecessary (and potentially escalating) API access to ServiceAccounts, but are easier to administrate.

*-Kubernetes-[Using RBAC Authorization](https://kubernetes.io/docs/reference/access-authn-authz/rbac/#service-account-permissions)*

### default ServiceAccount in Another Namespace

Let us now create / delete a Namespace and observe that the K8s Token Controller automatically creates / deletes the associated ServiceAccount and associated Secret.

```plaintext
kubectl create namespace test
```

Inspect SA and Secret

```plaintext
kubectl delete namespace test
```

### default ServiceAccount and Pods

> When you create a pod, if you do not specify a service account, it is automatically assigned the default service account in the same namespace.

*-Kubernetes-[Configure Service Accounts for Pods](https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/)*

```plaintext
helm install dev pod
```

Look at full YAML output for *serviceAccountName*. Then look deeper at the mounted volume from Secret.

Login to container and observe values in mounted volume.

This is what it means to be "authenticated to a ServiceAccount".

### Complete example

```plaintext
helm install dev service-account
```

```plaintext
curl -H "Authorization: bearer $(cat /var/run/secrets/kubernetes.io/serviceaccount/token)" --cacert /var/run/secrets/kubernetes.io/serviceaccount/ca.crt https://kubernetes.default/api/v1/namespaces/default/pods
```

### Token Rotation

> The kubelet will request and store the token on behalf of the pod, make the token available to the pod at a configurable file path, and refresh the token as it approaches expiration. Kubelet proactively rotates the token if it is older than 80% of its total TTL, or if the token is older than 24 hours.

and

> The application is responsible for reloading the token when it rotates. Periodic reloading (e.g. once every 5 minutes) is sufficient for most usecases.

*-Kubernetes-[Configure Service Accounts for Pods](https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/)*
