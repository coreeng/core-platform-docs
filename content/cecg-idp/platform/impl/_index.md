+++
title = "Platform Implementation"
weight = 10
chapter = false
pre = ""
+++

Platform Implementation describes how thing work rather than how to use them. This section of the docs is for Platform Engineers wanting to contribute or understand how things work under the covers.

The current features have been implemented:

* Connected Kubernetes
  * [SSO](/core-platform/features/connected-kubernetes/feature-sso-integration/) via GSuite
* [Multi Tenant Kubernetes Access](/core-platform/features/multi-tenant-access/feature-tenant-kubernetes-access/) via Hierarchical Namespaces 
* [Corporate AD based RBAC](/core-platform/features/multi-tenant-access/feature-corporate-ad-based-rbac/) via GSuite Google Groups
* GitHub Actions based P2P
* [Ingress](/)
* [SSL](/)