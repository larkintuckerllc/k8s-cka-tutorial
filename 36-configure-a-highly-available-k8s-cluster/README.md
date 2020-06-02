# Installation, Configuration & Validation: Configure a Highly-Available Kubernetes Cluster

Back to [Certified Kubernetes Administrator (CKA) Tutorial](https://github.com/larkintuckerllc/k8s-cka-tutorial)

[![Installation, Configuration & Validation: Configure a Highly-Available Kubernetes Cluster](http://img.youtube.com/vi/qYGn3tyFejY/0.jpg)](https://youtu.be/qYGn3tyFejY)

## Script

**note:** It is not clear what the three "end-to-end" topics in the installation section relate to.  I ended up concluding that they where about troubleshooting and as such are covered in other section.


**note:** Also this the last video in this series.

Ended up following the instructions (stacked) provided in [Creating Highly Available clusters with kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/high-availability/) with the following observations:

* Because had to create a number of Nodes, ended up creating one up to the point where kubeadm was installed and made an image

* When creating the AWS load balancer, had to trick it by providing SSH as the health check endpoint; plan would be to revert to actual checkpoint once installed

* Documention mentions it as an aside, but as use Calico for Pod Networking, required using the *--pod-network-cidr 192.168.0.0/16* option

* Documentation neglected to mention that you had to configure kubectl (like in the single Control Plane example)

Show final result.
