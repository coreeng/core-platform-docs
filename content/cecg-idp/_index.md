+++
title = "CECG IDP"
weight = 1
chapter = false
pre = ""
+++

The CECG IDP is an implementation of a [Core Platform](/core-platform).

It currently implements the following features:

* Connected Kubernetes
  * [SSO](/core-platform/features/connected-kubernetes/feature-sso-integration/) via GSuite
* [Multi Tenant Kubernetes Access](/core-platform/features/multi-tenant-access/feature-tenant-kubernetes-access/) via Hierarchical Namespaces 
* [Corporate AD based RBAC](/core-platform/features/multi-tenant-access/feature-corporate-ad-based-rbac/) via GSuite Google Groups
* Tactical GitHub Actions based P2P

## Accessing the Cluster 

The CECG IDP is an entirely private cluster. The Kubernetes endpoint is not exposed to the Internet.

Access is via [Google IAP](https://cloud.google.com/iap) via a bastion host to all members of the Platform Readonly Group.


### Platform Readonly Group

The platform readonly group is used to specify which users in your organisation are authorised to generate a kubeconfig allowing them to execute kubectl commands against the cluster. This group does not authorise members to modify any resources in the cluster, as the name implies.
This group name is configurable, but we recommend something like platform-readonly@cecg.io and doesn’t need any further configuration. This group can contain users, groups and service accounts.


### Generating a kubeconf and connecting

First set up the SSH tunnel to the bastion host.  This will later be used as a proxy to the API server.

Where for the developer playground the BASTION_HOSTNAME is `sandbox-gcp-bastion`

```
LOCAL_PROXY_PORT=54238 ## can update if this port is used on your local machine
PROJECT_ID=reference-core-platform-q7d9 ## will change for real enviorments
BASTION_HOSTNAME=sandbox-gcp-bastion
gcloud beta compute ssh ${BASTION_HOSTNAME} \
    --tunnel-through-iap \
    --project ${PROJECT_ID} \
    --zone europe-west2-a -- \
    -L${LOCAL_PROXY_PORT}:127.0.0.1:3128 \
    -o ServerAliveInterval=4 \
    -o ServerAliveCountMax=6 -N -n -q

gcloud compute start-iap-tunnel ${BASTION_HOSTNAME} 3128 \
    --local-host-port localhost:${LOCAL_PROXY_PORT} \
    --project ${PROJECT_ID} \
    --zone europe-west2-a
```

To [access the cluster](https://cloud.google.com/kubernetes-engine/docs/how-to/cluster-access-for-kubectl) with kubectl, generate a kubeconfig file using gcloud.

For dev playground the CLUSTER_NAME is `sandbox-gcp`

```
# Install the gke-gcloud-auth-plugin binary (required)
gcloud components install gke-gcloud-auth-plugin

# Update the kubectl configuration
gcloud container clusters get-credentials ${CLUSTER_NAME} \
    --region=${COMPUTE_REGION}

# Update the kubectl configuration to use the bastion as a proxy
kubectl config set clusters.${CLUSTER_NAME}.proxy-url http://localhost:${LOCAL_PROXY_PORT}
```

## Tenancy

Tenants are organised via the Hierarchical Namespace Controller

* `cecg-system`: Internal IDP components
* `reference-applications`: Applications to show you how to use the platform
* `tenants` Your applications

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

### Adding a tenancy

Tenants are added by providing a yaml file to us. This will later be replaced by a repo in your Github Org where you manage all your tenants.

For example here's a built in tenant for the golang reference app:

```
name: golang 
parent: reference-applications
description: "IDP Reference Go Application"
contact-email: idp-reference-application@cecg.io
cost-centre: platform
repos:
  - https://github.com/coreeng/idp-reference-app-go
admin-group: platform-accelerator-admin@cecg.io
readonly-group: platform-readonly@cecg.io
```

And one we've added based on the google groups you created for us:

```
name: devops-playground
parent: tenants
description: "Intergo DevOps Playground"
contact-email: devops@intergotelecom.com
cost-centre: tenants
repos: []
admin-group: devops@intergotelecom.com
readonly-group: platform-readonly@intergotelecom.com
```

### Authorization (RBAC)



