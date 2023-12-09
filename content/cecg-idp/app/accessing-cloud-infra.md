+++
title = "Accessing Cloud Infrastructure"
weight = 9
chapter = false
pre = ""
+++

Your applications can access Cloud Infrastructure in different Cloud Accounts.

Enable Cloud Access in your tenancy via adding the `cloud-access` section at the top level:

```
cloud-access:
  - name: cloud-access
    provider: gcp
    kubernetes_service_accounts:
      - <your_tenanncy>/sa
```

* `name`: Use a short name for the cloud access, with letters and `-`s
* `provider`: only `gcp` supported
* `kubernetes_service_accounts`: a list of kubernetes service accounts that will be allowed to access the cloud ifnrastructure in the format `namespace/name` e.g. the service account `cat` in the namespace `myfirsttenancy` should be configured as `myfirsttenancy/cat`

In your parent namespace (the one named after your tenancy run) run:

```
TENANT_NAME=??? # your tenancy e.g. myfirsttenancy
NAME=cloud-access #replace this with the name you have configured under `cloud-access`
kubectl get iamserviceaccount  -n $TENANT_NAME -o jsonpath='{.items[0].status.email}' $TENANT_NAME-$NAME'
```

For example, for the tenant name `myfirsttenancy` and the name `cloud-access`:

```
kubectl -n myfirsttenancy get iamserviceaccount myfirsttenancy-cloud-access -o jsonpath='{.status.email}'
myfirsttenancy-cloud-access@core-platform-ab0596fc.iam.gserviceaccount.com
```

This gives us an IAM Service Account that any permissions can be added to in your target Cloud Infra project.

```
myfirsttenancy-cloud-access@core-platform-ab0596fc.iam.gserviceaccount.com
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

#### Give permissions to your CLOUD_SERVICE_ACCOUNT

In your automation for your infrastructure cloud account, give whatever permissions are required to your CLOUD_SERVICE_ACCOUNT. 

For example, if you want it to access Cloud SQL it will need at least `Cloud SQL Instance User` and granted access to your databases.