+++
title = "Onboarding Tenancy"
weight = 100
chapter = false
pre = "1. "
+++

The Core Platform is a multi-tenant platform where each tenant gets their own segregated environments and P2P.


{{% notice info %}}
If you already have a tenancy you can jump to [Deploy a new Application](../deployapp) to deploy a new application.
{{% /notice %}}

## What is a tenant? 

A Tenancy is the unit of access to the Core Platform.
It contains a readonly and admin group and gives CI/CD actors
(GitHub Actions) access to a namespace and a docker registry for images.
Once you have a tenancy, you can add sub namespaces for all your application testing needs.

Tenants are organized in the tree structure. 
For each tenant, we create a [hierarchical namespace](https://github.com/kubernetes-sigs/hierarchical-namespaces).
It helps to organize resources and access.
Examples:
- share of resource quotas
- control access with network policies (give access to a tenant and all its children)
- share prometheus instance for tenant children

## Ways to create Tenancy
There are two ways to create a new tenancy:

- #### [Create a Tenancy using the CLI.](./tenancycli)
- #### [Create Tenancy Manually.](./tenancymanually)