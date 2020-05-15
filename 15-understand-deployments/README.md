# Application Lifecycle Management: Understand Deployments and How to Perform Rolling Update and Rollbacks

Back to [Certified Kubernetes Administrator (CKA) Tutorial](https://github.com/larkintuckerllc/k8s-cka-tutorial)

[![Application Lifecycle Management: Understand Deployments and How to Perform Rolling Update and Rollbacks](http://img.youtube.com/vi/XXXXX/0.jpg)](XXXXX)

## Script

> Sometimes, you may want to rollback a Deployment; for example, when the Deployment is not stable, such as crash looping. By default, all of the Deployment’s rollout history is kept in the system so that you can rollback anytime you want (you can change that by modifying revision history limit).
> Note: A Deployment’s revision is created when a Deployment’s rollout is triggered. This means that the new revision is created if and only if the Deployment’s Pod template (.spec.template) is changed, for example if you update the labels or container images of the template. Other updates, such as scaling the Deployment, do not create a Deployment revision, so that you can facilitate simultaneous manual- or auto-scaling. This means that when you roll back to an earlier revision, only the Deployment’s Pod template part is rolled back.

*-Kubernetes-[Deployments](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)*

Observations:

* Default is 10 revisions in history

### Without Helm

As there is a conceptual overlap between a Helm Chart Release Revision and a K8s Deployment Revision, let us explore K8s Deployment Revisions without using Helm.

We first create the Deployment:

```plaintext
kubectl apply -f no-helm
```

We observe the rollout history:

```plaintext
kubectl rollout history deployment.v1.apps/example-dev
```

We can get details on a particular revision with:

```plaintext
kubectl rollout history deployment.v1.apps/example-dev --revision=1
```

Notice the empty, change-cause entry.

Let us create a new revision. We update the deployment with version 20.04 of Ubuntu and add the following annotation; used when creating the revision.

```plaintext
kubernetes.io/change-cause: 'upgrade to 20.04'
```

and apply:

```plaintext
kubectl apply -f no-helm
```

We can watch the rollout with:

```plaintext
kubectl rollout status deployment example-dev --watch
```

And see the updated history with:

```plaintext
kubectl rollout history deployment.v1.apps/example-dev
```

Create another revision; "image: ubuntu:bogus" and update the annotation "upgrade to bogus" and apply.

See the updated history with:

```plaintext
kubectl rollout history deployment.v1.apps/example-dev
```

Observe that only one is "up-to-date"; here is a clue that there is a problem; Also observe the conditions:

```plaintext
kubectl get deployment
kubectl describe deployment
```

We can then troubleshoot the Pod:

```plaintext
kubectl get all
kubectl describe pod XXXX
```

We can then rollback:

```plaintext
kubectl rollout undo deployment.v1.apps/example-dev
```

**note:** Can specifiy a *--to-revision=X* option

```plaintext
kubectl rollout history deployment.v1.apps/example-dev
```

### With Helm

The punchline here is that Helm's Release Revisions "play well" with K8s Deployment Revisions.

```plaintext
helm install dev helm
```

We observe the rollout history.

Create a revision; "image: ubuntu:20.04" and create annotation and upgrade:

```plaintext
helm upgrade dev helm
```

And observe the updated rollout history.

Create another revision; "image: ubuntu:bogus" and update the annotation "upgrade to bogus" and upgrade.

Instead of using K8s to rollback, we will use Helm.

```plaintext
helm history dev

helm rollback dev

helm history dev
```

We observe that Helm did the right thing:

```plaintext
kubectl rollout history deployment.v1.apps/example-dev
```

### Canary Deployment

> If you want to roll out releases to a subset of users or servers using the Deployment, you can create multiple Deployments, one for each release, following the canary pattern...

*-Kubernetes-[Deployments](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)*

TODO
