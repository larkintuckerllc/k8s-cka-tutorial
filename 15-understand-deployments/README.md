# Application Lifecycle Management: Understand Deployments and How to Perform Rolling Update and Rollbacks

Back to [Certified Kubernetes Administrator (CKA) Tutorial](https://github.com/larkintuckerllc/k8s-cka-tutorial)

[![Application Lifecycle Management: Understand Deployments and How to Perform Rolling Update and Rollbacks](http://img.youtube.com/vi/XXXXX/0.jpg)](XXXXX)

## Script

> Sometimes, you may want to rollback a Deployment; for example, when the Deployment is not stable, such as crash looping. By default, all of the Deployment’s rollout history is kept in the system so that you can rollback anytime you want (you can change that by modifying revision history limit).
> Note: A Deployment’s revision is created when a Deployment’s rollout is triggered. This means that the new revision is created if and only if the Deployment’s Pod template (.spec.template) is changed, for example if you update the labels or container images of the template. Other updates, such as scaling the Deployment, do not create a Deployment revision, so that you can facilitate simultaneous manual- or auto-scaling. This means that when you roll back to an earlier revision, only the Deployment’s Pod template part is rolled back.

*-Kubernetes-[Deployments](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)*

```plaintext
kubectl apply -f no-helm
```

```plaintext
kubectl rollout history deployment.v1.apps/example-dev
```

kubernetes.io/change-cause
