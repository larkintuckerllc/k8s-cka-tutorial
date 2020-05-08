# Security: Know How to Configure Authentication and Authorization

Back to [Certified Kubernetes Administrator (CKA) Tutorial](https://github.com/larkintuckerllc/k8s-cka-tutorial)

[![Security: Know How to Configure Authenication and Authorization](http://img.youtube.com/vi/dPX0Gbt4qh0/0.jpg)](https://youtu.be/dPX0Gbt4qh0)

## Script

### Sidebar into ConfigMaps

We will use a simple type of Kubernetes object to explore authorization:

> A ConfigMap is an API object used to store non-confidential data in key-value pairs.

*-Kubernetes-[ConfigMaps](https://kubernetes.io/docs/concepts/configuration/configmap/)*

Let us see a number of patterns of key (string) and value (also string) pairs:

```plaintext
kubectl apply -f example-cm.yaml
````

### AWS IAM Setup

This example, uses three IAM users:

* *suzi.administrator*: Suzi's user when she is performing administrative tasks

* *suzi*: Suzi's user when she is performing development tasks

* *dave*: Dave's user; he only performs development tasks

### AWS Cluster Administrator Work; fred.administrator

In our imagined example, the company is organized into teams, e.g, team *a* and associated Namespace:

```plaintext
Team a
- admin
  - suzi.administrator
- developer
  - suzi
  - dave
```

* *admin* can do most anything in associated Namespace, including managing authorization

* *developers* can view anything in associated Namespace

Create Namespace *a*:

```plaintext
kubectl create namespace a
```

Bind *admin* ClusterRole to *a:admin* group:

```plaintext
kubectl apply -f a-admin.yaml
```

Bind *view* ClusterRole to *a:developer* group:

```plaintext
kubectl apply -f a-developer.yaml
```

### "HR" Work; fred.administrator

In our example, employees are centrally assigned to teams, e.g., *a*, as administrators or developers.

kubectl edit configmap/aws-auth -n kube-system

```plaintext
  mapUsers: |
    - userarn: arn:aws:iam::143287522423:user/suzi.administrator
      username: suzi.administrator
      groups:
        - a:admin
    - userarn: arn:aws:iam::143287522423:user/suzi
      username: suzi
      groups:
        - a:developer
    - userarn: arn:aws:iam::143287522423:user/dave
      username: dave
      groups:
        - a:developer
```

### Sidebar into Role

> An RBAC Role or ClusterRole contains rules that represent a set of permissions. Permissions are purely additive (there are no “deny” rules).
> A Role always sets permissions within a particular namespace; when you create a Role, you have to specify the namespace it belongs in.

*-Kubernetes-[Using RBAC Authorization](https://kubernetes.io/docs/reference/access-authn-authz/rbac/)*

Because Roles are Namespaced, *suzi.administrator* can manage Roles in the *a* Namespace; not true for ClusterRoles.

### Team A Administrator Work; suzi.administrator

Notice no access to *default* Namespace:

```plaintext
kubectl get cm -n default
```

Access *a* Namespace:

```plaintext
kubectl get cm -n a
```

Create ConfigMap:

```plaintext
kubectl apply -f a-fruit-cm.yaml
```

Create *fruit:edit* Role

```plaintext
kubectl apply -f a-fruit-role.yaml
````

Bind *fruit:edit* Role to *suzi* user:

```plaintext
kubectl apply -f a-fruit-rolebinding.yaml
````

**note:** Suzi cannot define new groups as that would require ability to edit a ConfigMap in the *kube-system* Namespace to assign them to users.

### suzi Work

Cannot delete *fruit* ConfigMap:

```plaintext
kubectl delete cm fruit -n a
```

But can edit it:

```plaintext
kubectl edit cm fruit -n a
```

### dave Work

Can get *fruit* ConfigMap:

```plaintext
kubectl get cm fruit -n a
```

Cannot edit it:

```plaintext
kubectl edit cm fruit -n a
```
