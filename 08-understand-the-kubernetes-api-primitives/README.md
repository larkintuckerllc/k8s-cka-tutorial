# Core Concepts: Understand the Kubernetes API Primitives

Back to [Certified Kubernetes Administrator (CKA) Tutorial](https://github.com/larkintuckerllc/k8s-cka-tutorial)

**Addendum:** You may have observed that Helm is not specifically mentioned in the CKA syllabus.  At the same time, the basics of it were covered in the CKA prep-course I took and is sometimes a topic in job interviews. Finally, it is a handy mechanism to manage K8s resources.

[![Core Concepts: Understand the Kubernetes API Primitives](http://img.youtube.com/vi/QOhMPdu8eeE/0.jpg)](https://youtu.be/QOhMPdu8eeE)

## Test Preparation: Relevant Kubernetes Documentation

None

## Script

### Helm

> Helm helps you manage Kubernetes applications — Helm Charts help you define, install, and upgrade even the most complex Kubernetes application.

*-Helm-[Helm](https://helm.sh/)*

Install Helm as per [documentation](https://helm.sh/docs/intro/install/).

> A Chart is a Helm package. It contains all of the resource definitions necessary to run an application, tool, or service inside of a Kubernetes cluster. Think of it like the Kubernetes equivalent of a Homebrew formula, an Apt dpkg, or a Yum RPM file.
> A Repository is the place where charts can be collected and shared. It's like Perl's CPAN archive or the Fedora Package Database, but for Kubernetes packages.
> A Release is an instance of a chart running in a Kubernetes cluster. One chart can often be installed many times into the same cluster. And each time it is installed, a new release is created. Consider a MySQL chart. If you want two databases running in your cluster, you can install that chart twice. Each one will have its own release, which will in turn have its own release name.

*-Helm-[Using Helm](https://helm.sh/docs/intro/using_helm/)*

If we were to do something like this using *kubectl*, we would be creating copies of folders and making mass changes in them to avoid naming conflicts.

**note:** We are not going to use Helm's repository feature.

Let us start by creating a Helm Chart.

```plaintext
helm create project
```

Clean out sample configuration:

1. Clean out *templates* folder

2. Remove everything from *values.yaml*

3. Review *Chart.yaml*; set *appVersion* to match *version*

Copy in *example.yaml* to *templates* folder; inspect.

Lint project:

```plaintext
helm lint project
```

See what installing it will do:

```plaintext
helm install project project --dry-run --debug
```

Basically, creates a Kubernetes configuration file in a particular order.

> // InstallOrder is the order in which manifests should be installed (by Kind).
> // Those occurring earlier in the list get installed before those occurring later in the list.

*-Helm-[kind-sorter.go](https://github.com/helm/helm/blob/release-3.0/pkg/releaseutil/kind_sorter.go)-*

We install:

```plaintext
helm install project project
```

We inspect; noticing:

* labels

* annotation; in particular no last known configuration

```plaintext
kubectl get cm example -o yaml
```

But there is a Release with information about last known configuration:

```plaintext
helm list
helm status project
helm get all project
kubectl get secret
```

Let us upgrade; remove *a* and add *c*:

**note:**: Am not updating the *version* or *appVersion* in these examples for expediency.

No diff here:

```plaintext
helm upgrade project project --dry-run --debug
````

Install [Helm Diff plugin](https://github.com/databus23/helm-diff).

```plaintext
helm diff upgrade project project
```

Upgrade:

```plaintext
helm upgrade project project
```

We inspect:

```plaintext
kubectl get cm example -o yaml
```

We can see history:

```plaintext
helm history project
```

We can diff a rollback:

```plaintext
helm diff rollback project 1
```

We can rollback:

```plaintext
helm rollback project
```

We inspect:

```plaintext
kubectl get cm example -o yaml
```

Because Helm maintains a concept of a Revision, you can even remove objects by removing the configuration file. Walk through example of using *example2*.

One of the powerful Helm features is variables. 

Review K8s [recommended labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/common-labels/):

Create the labels and update name. Do upgrade diff and upgrade.

Install second instance of *project*, e.g., *project2*. List out CM.

Finally, we can uninstall:

```plaintext
helm uninstall project
helm uninstall project2
```

**note:** In our example, we worked in the *default* namespaces, but much like Namespaced K8s objects, the revisions, i.e., Secrets, are namespaced.  Use the option *--namespace* to change.
