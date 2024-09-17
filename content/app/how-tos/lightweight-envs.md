+++
title = "Create a lightweight environment"
weight = 1
chapter = false
pre = ""
+++

Once you have a [tenancy](/app/tenancy/) you can create as many lightweight environments as you like e.g. for
* Testing
* Experimentation

Lightweight environmens rely on the [Hierarchical Namespace](https://kubernetes.io/blog/2020/08/14/introducing-hierarchical-namespaces/) kubectl plugin.

```bash
kubectl hns tree myfirsttenancy
myfirsttenancy
├── [s] myfirsttenancy-dev
├── [s] myfirsttenancy-functional
└── [s] myfirsttenancy-nft

[s] indicates subnamespaces
```

> Note:
> those `myfirsttenancy-[dev|functional|nft]` namespaces are [lightweight environments](#creating-additional-lightweight-environments).
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
