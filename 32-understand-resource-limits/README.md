# Scheduling: Understand How Resource Limits Can Affect Pod Scheduling

Back to [Certified Kubernetes Administrator (CKA) Tutorial](https://github.com/larkintuckerllc/k8s-cka-tutorial)

[![Scheduling: Understand How Resource Limits Can Affect Pod Scheduling](http://img.youtube.com/vi/XXXXX/0.jpg)]()

## Script

### Requests and Limits Combinations

```plaintext
helm install dev combinations
```

Guessing general rules:

* Request <= Limit

* Maximum Limit Defaults to Infinity (0)

* (Limit) No Limit No Default: Maximum

* (Request) No Request and Limit: Limit

* (Request) No Request and No Limit: Complicated

(Request) No Request and No Limit:

* No Default No Max: Zero (0)

![combinations](combinations.png)

### LimitRange Min-Max

```plaintext
helm install dev min-max
```

(Request) No Request and No Limit

* No Default Max: Max

![min-max](min-max.png)

### LimitRange Default

```plaintext
helm install dev default
```

Guessing general rules:

* (Limit) No Limit Default: Default

(Request) No Request and No Limit:

* Default: Default

![default](default.png)
