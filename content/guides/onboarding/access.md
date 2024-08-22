+++
title = "Access Tenancy Namespaces"
weight = 300
chapter = false
pre = "1.1.2 "
+++



#### Prerequisite
- Configure [Core Platform CLI](../../../corectl).


## Accessing your namespaces



Once the PR you created in step [1.1](../tenancycli) or [1.2](../tenancymanually) is merged, everyone in the groups will have access to the namespaces created for that tenancy.

If you access the cluster from the local machine, you need to connect to the cluster.
The easiest way to do this is using `corectl`:
```bash
corectl env connect <env-name>
```

For example, to check a namespace for a tenancy named `myfirsttenancy`:
```bash
kubectl get namespace myfirsttenancy
NAME             STATUS   AGE
myfirsttenancy   Active   30s
```

With the [Hierarchical Namespace](https://kubernetes.io/blog/2020/08/14/introducing-hierarchical-namespaces/) kubectl plugin.
```bash
kubectl hns tree myfirsttenancy
myfirsttenancy
├── [s] myfirsttenancy-dev
├── [s] myfirsttenancy-functional
└── [s] myfirsttenancy-nft

[s] indicates subnamespaces
```

> Note:
> those `myfirsttenancy-[dev|funcitonal|nft]` namespaces are [lightweight environments](#creating-additional-lightweight-environments).
> You might not have those in the output if you didn't create them.

> Note: Instruction for installing the `hns` plugin for `kubectl` can be found [here](https://github.com/kubernetes-sigs/hierarchical-namespaces/releases)

## Creating additional lightweight environments

You have permission to create as many lightweight environments in your tenancy.

All reference apps create at least:

* functional - for stubbed functional tests 
* nft - for stubbed functional tests

Typically, all lightweight environments are created in your dev cluster and only
a single namespace per application is in production.

To create a lightweight environment, in your tenancy namespace create:


```
apiVersion: hnc.x-k8s.io/v1alpha2
kind: SubnamespaceAnchor
metadata:
  namespace: {tenant_name}
  name: your-lightweight-env
```