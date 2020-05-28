# Scheduling: Understand How Resource Limits Can Affect Pod Scheduling

Back to [Certified Kubernetes Administrator (CKA) Tutorial](https://github.com/larkintuckerllc/k8s-cka-tutorial)

[![Scheduling: Understand How Resource Limits Can Affect Pod Scheduling](http://img.youtube.com/vi/XXXXX/0.jpg)]()

## Script

### Requests and Limits Combinations

```plaintext
helm install dev combinations
```

Describe this as "generous"; observe in Node describe:

* Backwards => Invalid Pod Defn

* None => No Changes

* No Limit => No Changes

* Both => No Changes

* No Request => Request Set to Limit
