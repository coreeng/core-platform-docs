+++
title = "Accessing Cloud Infrastructure"
weight = 15
chapter = false
pre = ""
+++

Your applications can access Cloud Infrastructure in different Cloud Accounts.

Enable Cloud Access in your tenancy via adding the `cloudAccess` section at the top level:

```yaml
cloudAccess:
  - name: ca
    provider: gcp
    environment: all
    kubernetesServiceAccounts:
      - <your_namespace>/sa
```

* `name`: Use a short name for the cloud access, with letters and `-`s (32 character limit). For CloudSQL, this will be your IAM SA username.
* `provider`: only `gcp` is currently supported.
* `kubernetesServiceAccounts`: a list of kubernetes service accounts that will be allowed to access the cloud infrastructure in the format `namespace/name` e.g. the service account `sa` in the namespace `myfirsttenancy` using the P2P should have `myfirsttenancy-functional/sa`, `myfirsttenancy-nft/sa`, `myfirsttenancy/sa`, `myfirsttenancy/sa` and whatever other namespace you need.
* `environment` is be used to specify the environment in which this specific Cloud Access configuration will be deployed. To deploy it in all of the environments where the tenant is configured, you can use the keyword `all` as the environments value.

In your parent namespace (the one named after your tenancy run) run:

```shell
TENANT_NAME=myfirsttenancy # your tenant name
NAME=ca # replace this with the name you have configured under `cloud-access`
kubectl get iamserviceaccount  -n $TENANT_NAME -o jsonpath='{.items[0].status.email}' $TENANT_NAME-$NAME
```

For example, for the tenant name `myfirsttenancy` and the name `ca`:

```shell
kubectl -n myfirsttenancy get iamserviceaccount myfirsttenancy-ca -o jsonpath='{.status.email}'
myfirsttenancy-ca@{{ project-id }}.iam.gserviceaccount.com
```

This gives us an IAM Service Account that any permissions can be added to in your target Cloud Infra project.

```shell
myfirsttenancy-ca@{{ project-id }}.iam.gserviceaccount.com
```

This is your `CLOUD_SERVICE_ACCOUNT``

### Annotate Kubernetes Service Accounts

To be able to impersonate the above service account, annotate your service account with the

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: NAME #for the above examples this should be "sa" 
  annotations:
    iam.gke.io/gcp-service-account: CLOUD_SERVICE_ACCOUNT #for the above example this will be of the form myfirsttenancy-ca@{{ project-id }}.iam.gserviceaccount.com
```

{{% notice note %}}
You will need a service account in each of the namespaces the app will be deployed to, so if using the standard p2p, and helm it would make sense to configure this as a helm chart template with the app (the project ID should be parameterised if the app is deployed to multiple environments).  This will ensure it is created correctly for e.g. <app>-functional, <app>-nft etc. sub-namespaces 
{{% /notice %}}

Your pods should use this service account, then anytime they use a Google Cloud library they will assume the identity of the service account.
