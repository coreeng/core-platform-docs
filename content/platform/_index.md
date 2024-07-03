+++
title = "Platform Operations"
weight = 1
chapter = false
pre = ""
+++

## Accessing the Platform
This documentation guides platform users on accessing the CECG Kubernetes platform on Google Cloud Platform (GCP).

## Prerequisites

### Platform Readonly Group

The platform readonly group is used to specify which users in your organisation are authorised to generate a kubeconfig allowing them to execute kubectl commands against the cluster. This group DOES NOT authorise members to modify any resources in the cluster.

The group should be: platform-readonly@domain e.g. `platform-readonly@cecg.io` if your domain is `cecg.io`

### GKE Security Group

We leverage GKE’s native support for using Google Groups to support RBAC within Core Platform clusters (see [GKE Documentation](https://cloud.google.com/kubernetes-engine/docs/how-to/google-groups-rbac#console)). A requirement of this native support is a Google Group named `gke-security-groups@domain` to act as a top level group for nested team based groups.

This group should only contain other google groups as members, not users or service accounts (the user who creates the group will be an owner).

#### Group Member Visibility

The GKE + Google Groups native integration requires an additional configuration change to the `gke-security-groups` group. This group, and all nested groups within it **must** have their `Group Settings` -> `Who can view members` configuration set to `Group members`. As shown here:

{{< figure src="/images/connected-kubernetes/gcp-group-settings.png" title="GCP Group Settings" >}}

## Cluster Access

### Using `corectl`
```bash
corectl env connect <environment-name>
```

### Manually
* Start IAP Tunnel:

```bash
gcloud compute start-iap-tunnel ${BASTION_HOSTNAME} 3128 \
    --local-host-port localhost:${LOCAL_PROXY_PORT} \
    --project ${PROJECT_ID} \
    --zone ${BASTION_ZONE}
```

* Access the Cluster with kubectl:

```bash
# Install the gke-gcloud-auth-plugin binary (required)
gcloud components install gke-gcloud-auth-plugin

# Update kubectl configuration
gcloud container clusters get-credentials ${CLUSTER_NAME} \
    --project ${PROJECT_ID} \
    --region=${COMPUTE_REGION}

# Update kubectl configuration to use the bastion as a proxy
kubectl config set clusters."$(kubectl config current-context)".proxy-url http://localhost:${LOCAL_PROXY_PORT}

# Verify user access to resources
kubectl auth can-i get pods \
    --namespace=${NAMESPACE} \
    --as=${USER}@${DOMAIN} \
    --as-group=${GROUP}@${DOMAIN}
```

> :bulb: **Tip:** For a full example, check the Environments Repo.

## GCP Registry Access

* To access artifact registries, use the following command to configure Docker:

```bash
gcloud auth configure-docker ${GCP_REGION}-docker.pkg.dev
```

* Now, you have read and write access to `${GCP_REGION}-docker.pkg.dev/${PROJECT_ID}/tenant`.

