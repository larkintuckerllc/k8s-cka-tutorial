
TODO:

> Kubernetes objects are persistent entities in the Kubernetes system. Kubernetes uses these entities to represent the state of your cluster.

*-Kubernetes-[Understanding Kubernetes Objects](https://kubernetes.io/docs/concepts/overview/working-with-objects/kubernetes-objects/)*

> Each object in your cluster has a Name that is unique for that type of resource. Every Kubernetes object also has a UID that is unique across your whole cluster.

*-Kubernetes-[Object Names and IDs](https://kubernetes.io/docs/concepts/overview/working-with-objects/names/)*

> Namespaces are intended for use in environments with many users spread across multiple teams, or projects. For clusters with a few to tens of users, you should not need to create or think about namespaces at all. Start using namespaces when you need the features they provide.
> Namespaces provide a scope for names. Names of resources need to be unique within a namespace, but not across namespaces. Namespaces can not be nested inside one another and each Kubernetes resource can only be in one namespace.

*-Kubernetes-[Namespaces](https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/)*

**note**: TODO SYSTEM NS

TODO: ADDONS

## Script

5. XXXXX

```plaintext
kubectl get all --all-namespaces
```

6. XXXXX

```
kubectl api-resources --verbs=list -o name | xargs -n 1 kubectl get -o custom-columns=NAMESPACE:.metadata.namespace,NAME:.metadata.name --all-namespaces
```
