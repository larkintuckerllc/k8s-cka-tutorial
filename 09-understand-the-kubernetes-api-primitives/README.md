# Core Concepts: Understand the Kubernetes API Primitives

Back to [Certified Kubernetes Administrator (CKA) Tutorial](https://github.com/larkintuckerllc/k8s-cka-tutorial)

[![Core Concepts: Understand the Kubernetes API Primitives](http://img.youtube.com/vi/QOhMPdu8eeE/0.jpg)](https://youtu.be/QOhMPdu8eeE)

## Script

### Kustomize

> Kustomize is a standalone tool to customize Kubernetes objects through a kustomization file.

*-Kubernetes-[Declarative Management of Kubernetes Objects Using Kustomize](https://kubernetes.io/docs/tasks/manage-kubernetes-objects/kustomization/)*

Somewhat overlaps with the functionality of Helm.

#### Setting Cross-Cutting Fields

> It is quite common to set cross-cutting fields for all Kubernetes resources in a project. Some use cases for setting cross-cutting fields

*-Kubernetes-[Declarative Management of Kubernetes Objects Using Kustomize](https://kubernetes.io/docs/tasks/manage-kubernetes-objects/kustomization/)*

Replicate the Name and Label example; looking at *project* folder.

```plaintext
kubectl kustomize project
```

Then apply:

```plaintext
kubectl apply -k project
```

#### Patching

> On top of Resources, one can apply different customizations by applying patches. Kustomize supports different patching mechanisms

*-Kubernetes-[Declarative Management of Kubernetes Objects Using Kustomize](https://kubernetes.io/docs/tasks/manage-kubernetes-objects/kustomization/)*

The use of the term "patch" implies (at least to me) that this feature is intended to allow for incremental updates to an application over time.

Examine *project-patch* folder:

```plaintext
kubectl kustomize project-patch
```

#### Bases and Overlays

> Kustomize has the concepts of bases and overlays. A base is a directory with a kustomization.yaml, which contains a set of resources and associated customization. A base could be either a local directory or a directory from a remote repo, as long as a kustomization.yaml is present inside. An overlay is a directory with a kustomization.yaml that refers to other kustomization directories as its bases.

*-Kubernetes-[Declarative Management of Kubernetes Objects Using Kustomize](https://kubernetes.io/docs/tasks/manage-kubernetes-objects/kustomization/)*

This feature appears to allow for different varients of an application; much like Helm Releases.

```plaintext
kubectl kustomze project-base/dev
```

```plaintext
kubectl kustomze project-base/prod
```
