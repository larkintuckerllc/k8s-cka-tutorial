# Application Lifecycle Management: Understand Deployments and How to Perform Rolling Update and Rollbacks

Back to [Certified Kubernetes Administrator (CKA) Tutorial](https://github.com/larkintuckerllc/k8s-cka-tutorial)

[![Application Lifecycle Management: Understand Deployments and How to Perform Rolling Update and Rollbacks](http://img.youtube.com/vi/BGfs_JGibV4/0.jpg)](https://youtu.be/BGfs_JGibV4)

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

Rather than giving an blow-by-blow, will do same scenario off screen and show final result.  Basically, will using the *helm" folder (same deployment as the we had before). The difference here is Helm is used to perform the changes, including the rollback.

OFF-SCREEN START

```plaintext
helm install dev helm
```

Create a revision; "image: ubuntu:20.04" and create annotation and upgrade:

```plaintext
helm upgrade dev helm
```

Create another revision; "image: ubuntu:bogus" and update the annotation "upgrade to bogus" and upgrade.

```plaintext
helm rollback dev
```

OFF-SCREEN END

Observe that Helm did actually initiate a K8S rollback.

```plaintext
helm history dev

kubectl rollout history deployment.v1.apps/example-dev
```

### Canary Deployment

> If you want to roll out releases to a subset of users or servers using the Deployment, you can create multiple Deployments, one for each release, following the canary pattern...

*-Kubernetes-[Deployments](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)*

Will not do here, but the trick is in the proper use of labels; specifically construct the Pod template labels such that:

* Each Pod template uses different labels to match them up with their Deployment

* Both Pod templates share a common label to allow one to group all the Pods

### Jobs

Here we tack on Jobs to round out the Controllers material.

If you recall, we can run a Pod with a *restartPolicy* of *OnFailure* where the Pod continually retries failed containers.  But what happens if the Pod itself is deleted (say Node it was on failed)?

> A Job creates one or more Pods and ensures that a specified number of them successfully terminate. As pods successfully complete, the Job tracks the successful completions. When a specified number of successful completions is reached, the task (ie, Job) is complete. Deleting a Job will clean up the Pods it created.
> A simple case is to create one Job object in order to reliably run one Pod to completion. The Job object will start a new Pod if the first Pod fails or is deleted (for example due to a node hardware failure or a node reboot).

*-Kubernetes-[Jobs - Run to Completion](https://kubernetes.io/docs/concepts/workloads/controllers/jobs-run-to-completion/)*

Notice in this example, we use a *restartPolicy* of *Never* to have the Job manage the restart.

```plaintext
helm install job-success
```

It looks like you have to use full YAML output to see conditions.

**note**: In addition to the Non-Parallel and Fixed-Completion-Count patterns, there is a Work-Queue pattern for Jobs.

> There are situations where you want to fail a Job after some amount of retries due to a logical error in configuration etc. To do so, set .spec.backoffLimit to specify the number of retries before considering a Job as failed. The back-off limit is set by default to 6. Failed Pods associated with the Job are recreated by the Job controller with an exponential back-off delay (10s, 20s, 40s …) capped at six minutes. 

*-Kubernetes-[Jobs - Run to Completion](https://kubernetes.io/docs/concepts/workloads/controllers/jobs-run-to-completion/)*

```plaintext
helm install job-failure
```

See failure in full YAML output.

### CronJob

> CronJobs are useful for creating periodic and recurring tasks, like running backups or sending emails. CronJobs can also schedule individual tasks for a specific time, such as scheduling a Job for when your cluster is likely to be idle.
> The CronJob is only responsible for creating Jobs that match its schedule, and the Job in turn is responsible for the management of the Pods it represents.

*-Kubernetes-[CronJobs](https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/)*

Not doing an example, but it simply involves a *schedule* in Cron format and a *jobTemplate* (what we just learned).
