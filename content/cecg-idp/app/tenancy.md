+++
title = "Tenancy"
weight = 1
chapter = false
pre = ""
+++

A Tenancy is the unit of access to the developer platform. It contains readonly and admin group
and give you access to a namespace and a docker registry for images.
Once you have a tenancy you can add sub namespaces for all your application testing needs.


### Adding a tenancy

To add a tenancy raise a PR to the [Environments Repo]({{< param environmentRepo >}})

For example here's a built in tenant for the golang reference app:

Note that your tenancy name must be the same as the file name!

```
name: golang 
parent: reference-applications
description: "IDP Reference Go Application"
contact-email: idp-reference-application@{{< param email_org >}}
cost-centre: platform
environments:
  - gcp-dev
  - gcp-prod
repos:
  - https://github.com/{{< param github_org >}}/idp-reference-app-go
admin-group: platform-accelerator-admin@{{< param email_org >}}
readonly-group: platform-readonly@{{< param email_org >}}
cloud-access: []
```

* `environments` which of the environments in [Environments Repo]({{< param environmentRepo >}}) you wan tto deploy to 
* `admin-group` will get permission to do all actions in the created namespaces
* `readonly-group` will get ready only access to the created namespaces
* All `repos` GitHub actions will get permission to deploy to the created namespaces for implementing your application's [Path to Production](../p2p) aka CI/CD

Now you have a tenancy, you can deploy your first application by forking a [reference application](../reference-app)


## Accessing your namespaces

Once the above PR is merged everyone in the groups will have access to the namespaces created for that tenancy.

For example, the reference golang tenancy:

```
kubectl get namespace golang
NAME     STATUS   AGE
golang   Active   30s
```

With the [Hierarchical Namespace](https://kubernetes.io/blog/2020/08/14/introducing-hierarchical-namespaces/) kubectl plugin.

```
kubectl hns tree golang
golang
├── [s] golang-dev
├── [s] golang-functional
└── [s] golang-nft

[s] indicates subnamespaces
```

## Creating additional lightweight environments

You have permission to create as many lightweight environments in your tenancy.

All reference apps create at least:

* functional - for stubbed functional tests 
* nft - for stubbed functional tests

Typically all lightweight environments are created in your dev cluster and only
a single namespace per application is in production.

To create a lightweight environemnt, in your tenancy namespace create:


```
apiVersion: hnc.x-k8s.io/v1alpha2
kind: SubnamespaceAnchor
metadata:
  namespace: {tenant_name}
  name: your-lightweight-env
```





