+++
title = "Tenancy"
weight = 1
chapter = false
pre = ""
+++

## Tenancy

Tenants are organised via the Hierarchical Namespace Controller

* `cecg-system`: Internal components
* `reference-applications`: Applications to show you how to use the platform

The application teams can create tenancies under root or another top level folder e.g. tenants

```
❯ kubectl hns tree root
root
├── cecg-system
│   ├── platform-ingress
│   ├── platform-monitoring
│   └── platform-policy
├── reference-applications
│   └── knowledge-platform
│   └── golang
│       ├── [s] golang-functional
│       └── [s] golang-nft
└── tenants
    ├── cecg-playground
    └── devops-playground

[s] indicates subnamespaces
```





