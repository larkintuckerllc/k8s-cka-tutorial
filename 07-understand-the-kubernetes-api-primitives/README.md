# Core Concepts: Understand the Kubernetes API Primitives

Back to [Certified Kubernetes Administrator (CKA) Tutorial](https://github.com/larkintuckerllc/k8s-cka-tutorial)

[![Core Concepts: Understand the Kubernetes API Primitives](http://img.youtube.com/vi/XXXXX/0.jpg)](XXXXX)

## Script

TODO

```plaintext
kubectl api-resources
```

### Metadata

TODO

Name
Namespace
UIDs

#### Labels

> Labels are key/value pairs that are attached to objects, such as pods. Labels are intended to be used to specify identifying attributes of objects that are meaningful and relevant to users, but do not directly imply semantics to the core system. Labels can be used to organize and to select subsets of objects. Labels can be attached to objects at creation time and subsequently added and modified at any time.
>Labels are key/value pairs. Valid label keys have two segments: an optional prefix and name, separated by a slash (/). The name segment is required and must be 63 characters or less, beginning and ending with an alphanumeric character ([a-z0-9A-Z]) with dashes (-), underscores (_), dots (.), and alphanumerics between. The prefix is optional. If specified, the prefix must be a DNS subdomain: a series of DNS labels separated by dots (.), not longer than 253 characters in total, followed by a slash (/).
>If the prefix is omitted, the label Key is presumed to be private to the user.

*-Kubernetes-[Labels and Selectors](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/)*

```plaintext
kubectl get node ip-192-168-190-200.ec2.internal -o yaml
```

TODO

![Recommended Lables](recommended-labels.jpg)

#### Annotations

> You can use Kubernetes annotations to attach arbitrary non-identifying metadata to objects. Clients such as tools and libraries can retrieve this metadata.

*-Kubernetes-[Annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/)

```plaintext
kubectl get node ip-192-168-190-200.ec2.internal -o yaml
```

### Data

TODO

> A Kubernetes object is a “record of intent”--once you create the object, the Kubernetes system will constantly work to ensure that object exists. By creating an object, you’re effectively telling the Kubernetes system what you want your cluster’s workload to look like; this is your cluster’s desired state.

*-Kubernetes-[Understanding Kubernetes Objects](https://kubernetes.io/docs/concepts/overview/working-with-objects/kubernetes-objects/)*

TODO

> Almost every Kubernetes object includes two nested object fields that govern the object’s configuration: the object spec and the object status. For objects that have a spec, you have to set this when you create the object, providing a description of the characteristics you want the resource to have: its desired state.
> The status describes the current state of the object, supplied and updated by the Kubernetes system and its components. The Kubernetes control plane continually and actively manages every object’s actual state to match the desired state you supplied.

*-Kubernetes-[Understanding Kubernetes Objects](https://kubernetes.io/docs/concepts/overview/working-with-objects/kubernetes-objects/)*

TODO: EXAMPLE

kubectl get node ip-192-168-190-200.ec2.internal -o yaml

TODO: COUNTER EXAMPLE

```plaintext
kubectl get cm example -o yaml

```

### Management Techniques

Warning: A Kubernetes object should be managed using only one technique. Mixing and matching techniques for the same object results in undefined behavior.

#### Imperative Commands

TODO

```plaintext
kubectl create deployment nginx --image nginx
```

#### Imperative Object Configuration

TODO

```plaintext
kubectl create -f nginx.yaml
```

delete

replace

#### Declarative object configuration

TODO

```plaintext
kubectl apply -f nginx.yaml
```

diff

apply
