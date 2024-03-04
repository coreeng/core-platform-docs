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

### Authentication
Since we're using a service account to configure the connectivity, we might as well use it for authentication.
There are a few things you need to do:
* On your database instance enable the flag `cloudsql_iam_authentication` (`cloudsql.iam_authentication` for postgres).
* Create a `CLOUD_IAM_SERVICE_ACCOUNT` user on your database.  This will create your username and on your configuration you'll set it excluding the `@<project_id>.iam.gserviceaccount.com`, so in the previous example it would be `myfirsttenancy-ca`
{{% notice note %}}
  Service Account users are created without any Database permissions by default, and in order to do that, you need to manually give it the permissions you need. 
{{% /notice %}}
In case you dont have any other built-in username, you can configure by renning something like:
```bash
USER_NAME="test_user"
PROJECT_ID="<PROJECT_ID>"

gcloud config set project $PROJECT_ID
gcloud sql users create $USER_NAME --host=% --instance=mysql-nft --password=test
gcloud sql connect mysql-nft  --user $USER_NAME 
# You'll be inside mysql CLI at this point
use reference-db;
GRANT ALL PRIVILEGES ON `reference-db`.* TO `myfirsttenancy-ca`@`%`;
```

This will:
* Create a user
* Allow the IP you're connecting from to temporarily access the database
* Grant all priviledges on the created database to the SA user on all hosts

After this, feel free to delete the `test_user` user, or store its details in your preferred SM.

#### Give permissions to your CLOUD_SERVICE_ACCOUNT

In your automation for your infrastructure cloud account, give whatever permissions are required to your CLOUD_SERVICE_ACCOUNT. 

For example, if you want it to access Cloud SQL it will need:
* `roles/cloudsql.client`
* `roles/cloudsql.instanceUser`
* `roles/serviceusage.serviceUsageConsumer`

The first 2 are to have cloudsql client permissions and the last one if to be able to use a service that doesn't not belong to the project.


### Billing
To be able to connect, you need to specify to the client which billing account to use, as by defualt it will try to use the one where the SA is configured, which in this case will be one of the platform environments, but you want it to use your own project. 
For terraform, you can add these 2 env vars:
```bash
export USER_PROJECT_OVERRIDE=true 
export GOOGLE_BILLING_PROJECT=$(YOU_PROJECT_ID)
```
For the application, something similar is required if you're using IAM SA auth. 
When creating a connector, you can specify by setting the quota project. In go, that will look like this:
```go
...
	d, err := cloudsqlconn.NewDialer(context.Background(), cloudsqlconn.WithIAMAuthN(), cloudsqlconn.WithQuotaProject(getBillingProject()))
...
```
Alternatively you can use the cloudsql proxy and pass this as an argument `--quota-project project`.

Google recommends using the the connectors whenever you can, but if it's not available for the language you're using, you can use the ClouSQLProxy https://github.com/GoogleCloudPlatform/cloud-sql-proxy

