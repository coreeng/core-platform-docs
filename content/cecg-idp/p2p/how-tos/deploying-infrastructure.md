+++
title = "Deploying Cloud Infrastructure from the P2P"
weight = 3
chapter = false
pre = ""
+++

## Authenticating to other GCP projects 

Out of the box the Cloud service account that your github actions impersonate
only has access to deploy to your namespaces in the platform.

Typically you'll also have other cloud infrastructure to deploy as part of your path
to production.

This infrastructure will be in your own cloud projects, rather than the cloud projects
where the platform is running.

### Granting access to the P2P service account to deploy infrastructure

1. Retrieve the name of your P2P service account in the environment you want to deploy to e.g. for the golang reference app:

```
TENANT_NAME=golang
kubectl get iamserviceaccount  -n $TENANT_NAME -o=jsonpath='{.status.email}' p2p-$TENANT_NAME
p2p-golang@core-platform-b83d2ca6.iam.gserviceaccount.com
```

The output should be the service account email starting with `p2p-`.

Once you have this you can, in your infrastructure project, assign permission to it so when
the pipeline next runs it can provision the infrastructure e.g. with terraform. This is only provisioning
that we recommend out side of the p2p as it is a chicken and egg problem.

When your make tasks are executed you will already be authenticated with gcloud so you don't need to do any of that setup.