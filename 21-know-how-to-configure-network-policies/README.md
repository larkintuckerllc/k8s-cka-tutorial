# Security: Know How to Use Network Policies

Back to [Certified Kubernetes Administrator (CKA) Tutorial](https://github.com/larkintuckerllc/k8s-cka-tutorial)

[![Security: Know How to Use Network Policies](http://img.youtube.com/vi/XXXXX/0.jpg)]()

## Script

As you may have noticed so far, by default, any Pod can communicate to any other Pod (or be exposed externally, i.e., LoadBalancer). This is not consistent with the pattern of a secure multi-tier application.

To help understand the pattern, let us look at an example (first conceptually):

TODO: IMAGE

* *Logic (or Application) Tier*: Say a Flask application providing an API

* *Data Tier*: Say a Redis database storing the application's data

* Data Tier only accessible from Logic Tier; and limited to redis port

* Logic Tier generally accessible; and limited to http port

* For demonstration, put an Ubuntu Pod in the Logic Tier and another one elsewhere

So how do these tiers relate to K8s concepts?

Thinking about tiers as basically groupings of Pods, it is unsurprising that we use K8s labels and Namespaces to define these tiers. In this example, the tiers are defined by:

* *Logic Tier*: Pods with namespace: production with a label network/logic: true

* *Data Tier*: Pods with namespace: production with a label network/data: true

