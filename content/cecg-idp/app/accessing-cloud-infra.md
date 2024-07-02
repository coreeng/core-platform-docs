+++
title = "Accessing Cloud Infrastructure"
weight = 10
chapter = false
pre = ""
+++

Your applications can access Cloud Infrastructure in different Cloud Accounts.

Enable Cloud Access in your tenancy via adding the `cloud-access` section at the top level:

```
cloud-access:
  - name: ca
    provider: gcp
    kubernetesServiceAccounts:
      - <your_namespace>/sa
```

* `name`: Use a short name for the cloud access, with letters and `-`s. For CloudSQL, this will be your IAM SA user name which has a max limit of 32 chars, just have that in mind when naming to ensure 
* `provider`: only `gcp` supported
* `kubernetesServiceAccounts`: a list of kubernetes service accounts that will be allowed to access the cloud ifnrastructure in the format `namespace/name` e.g. the service account `cat` in the namespace `myfirsttenancy` using the P2P should have `myfirsttenancy-functional/cat`, `myfirsttenancy-nft/cat`, `myfirsttenancy-prod/cat` and whatever other namespace you need.

In your parent namespace (the one named after your tenancy run) run:

```
TENANT_NAME=??? # your tenancy e.g. myfirsttenancy
NAME=ca #replace this with the name you have configured under `cloud-access`
kubectl get iamserviceaccount  -n $TENANT_NAME -o jsonpath='{.items[0].status.email}' $TENANT_NAME-$NAME'
```

For example, for the tenant name `myfirsttenancy` and the name `ca`:

```
kubectl -n myfirsttenancy get iamserviceaccount myfirsttenancy-ca -o jsonpath='{.status.email}'
myfirsttenancy-ca@core-platform-ab0596fc.iam.gserviceaccount.com
```

This gives us an IAM Service Account that any permissions can be added to in your target Cloud Infra project.

```
myfirsttenancy-ca@core-platform-ab0596fc.iam.gserviceaccount.com
```

This is your `CLOUD_SERVICE_ACCOUNT``

### Annotate Kubernetes Service Accounts

To be able to impersonate the above service account, annotate your service account with the

```
apiVersion: v1
kind: ServiceAccount
metadata:
  name: NAME
  annotations:
    iam.gke.io/gcp-service-account: CLOUD_SERVICE_ACCOUNT
```

Your pods should use this service account, then anytime they use a Google Cloud library they will assume the identity of the service account.
