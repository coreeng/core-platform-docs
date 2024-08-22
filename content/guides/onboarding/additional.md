+++
title = "Create Additional Tenancy Namespaces"
weight = 400
chapter = false
pre = "1.1.3 "
+++


## Creating additional lightweight environments

Once the PR you created in step [1.1](../tenancycli) or [1.2](../tenancymanually) is merged, everyone in the groups will have permissions to create as many lightweight environments in your tenancy.


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
