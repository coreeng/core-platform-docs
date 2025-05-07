# Connect to CloudSQL

With CloudSQL you can configure the connectivity and the authentication via IAM Service Accounts. For connectivity, please follow the setup [access cloud infrastructure](/reference/accessing-cloud-infra)

## Auth

Having a service account configured, we now need to tell the application running to use it. This can be done one of two ways

- [CloudSQL Proxy](https://github.com/GoogleCloudPlatform/cloud-sql-proxy)
- [CloudSQL connector library](https://cloud.google.com/sql/docs/mysql/connect-connectors)

Google recommends using the the connectors whenever you can, but if it's not available for the language you're using, you can use the CloudSQLProxy.

There are a few things you need to have in mind:

- On your database instance enable the flag `cloudsql_iam_authentication` (`cloudsql.iam_authentication` for postgres).
- Create a `CLOUD_IAM_SERVICE_ACCOUNT` user on your database. This will create your username and on your configuration you'll set it excluding the `@<project_id>.iam.gserviceaccount.com`, so in the previous example it would be `myfirsttenancy-ca`
  {{% notice note %}}
  Service Account users are created without any Database permissions by default, and in order to do that, you need to manually give it the permissions you need.
  {{% /notice %}}
  In case you dont have any other built-in username, you can configure by running something like:

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

- Create a user
- Allow the IP you're connecting from to temporarily access the database
- Grant all privileges on the created database to the SA user on all hosts

After this, feel free to delete the `test_user` user, or store its details in your preferred SM.

### Give permissions to your CLOUD_SERVICE_ACCOUNT

In your automation for your infrastructure cloud account, give whatever permissions are required to your CLOUD_SERVICE_ACCOUNT.

For example, if you want it to access Cloud SQL it will need:

- `roles/cloudsql.client`
- `roles/cloudsql.instanceUser`
- `roles/serviceusage.serviceUsageConsumer`

The first 2 are to have cloudsql client permissions and the last one is to be able to use a service that doesn't not belong to the project.

### Billing

To be able to connect, you need to specify to the client which billing account to use, as by default it will try to use the one where the SA is configured, which in this case will be one of the platform environments, but you want it to use your own project.
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
