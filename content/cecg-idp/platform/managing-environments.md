+++
title = "Managing Platform Environments"
weight = 1
chapter = false
pre = ""
+++

# Environments

The platform by default comes with a single organisation made up of three environments:

* **pre-dev**: Stage new versions of the platform before releasing to application engineers
* **dev**: Used for all development enviornments, functional testing, integrated testing, performance testing
* **prod**: Production

## platform-cli

Your [Environments Repo]({{< param environmentRepo >}}) contains a script for entering the platform docker image:
Authenticate with gcloud then:

```
./dplatform-cli
Usage:
  ./dplatform-cli environment_name [release_version]

Valid environments:
  gcp-prod
  gcp-pre-dev
  gcp-dev
```

## Gcp init

The `gcp-init` tool comes bundled inside the platform docker image. From inside the image:

```
cd gcp-init
source .venv/bin/activiate
python gcp-init.py --help
```

## Creating an organisation

It is expected to have a single organisation, meaning one set of environments.

Before execute `dplatform-cli` we use any of the commands, we need to generate some Application Default Credentials (ADC):

```shell
gcloud auth application-default login
mv $HOME/.config/gcloud/application_default_credentials.json $HOME/.config/gcloud/Platform-user.json
```

This will generate JSON credentials for your user account, and move them to a file called `Platform-user.json` in the `gcloud` config directory. We'll use this file to authenticate as your user when running certain commands.

Before running `root-init`, we need to check some GCP permissions. Before we can initialize a "parent" (a GCP org or folder), we need the following:

  - `roles/viewer` on the parent
  - `roles/resourcemanager.folderCreator` on the parent
  - `roles/resourcemanager.projectCreator` on the parent

We can now run the `root-init` command from within the `dplatform-cli`:

```shell
PARENT_FOLDER=??? # e.g. folders/12345
BILLING_ACCOUNT=??? # e.g. 01BC90-344AF2-CED391
ENV_REPO=???  # e.g. e.g. {{< param github_org>}}/platform-environments
PLATFORM_ADMIN_GROUP=???
GOOGLE_APPLICATION_CREDENTIALS=$HOME/.config/gcloud/Platform-user.json \
python gcp-init.py root-init \
    --parent=$PARENT_FOLDER \
    --billing-account=$BILLING_ACCOUNT \
    --github-repos=$ENV_REPO \
    --impersonators=group:$PLATFORM_ADMIN_GROUP \
    --owners=group:$PLATFORM_ADMIN_GROUP
```

This script is **idempotent**, if you encounter Cloud API failures, you can generally re-run the command and it will only create the missing resources.

> ![WARNING]
> If the errors are that your user doesn't have permissions to do something, that probably won't be fixed by re-running

## Creating an environment

To be able to run the next step command (`gcp-init.py env-init ...`) we need to generate some new application credentials, allowing us to impersonate the `env-manager` service account from the previous step:

```shell
SA_EMAIL=$(jq -r .env_mgr_sa.email output-root_init.json)
gcloud auth application-default login --impersonate-service-account=$SA_EMAIL
mv $HOME/.config/gcloud/application_default_credentials.json $HOME/.config/gcloud/Platform-env-manager.json
```

This will generate JSON credentials for the service account, and move them to a file called `Platform-env-manager.json` in the `gcloud` config directory. We'll use this file to authenticate as the SA when running certain commands.

We can now extract some information from `output-root_init.json` to use as input to the `env-init` command:

```shell
ENV=??? # e.g. dev-2
PLATFORM_ADMIN_GROUP=???
ENV_REPO=???  # e.g. e.g. {{< param github_org>}}/platform-environments
BILLING_ACCOUNT=???
SHARED_FOLDER=$(jq -r .shared_folder.name output-root_init.json)
ENVIRONMENTS_FOLDER=$(jq -r .environments_folder.name output-root_init.json)
MANAGEMENT_FOLDER=$(jq -r .management_folder.name output-root_init.json)

GOOGLE_APPLICATION_CREDENTIALS=$HOME/.config/gcloud/Platform-env-manager.json \
python gcp-init.py env-init \
    --shared-folder=$SHARED_FOLDER \
    --environments-folder=$ENVIRONMENTS_FOLDER \
    --management-folder=$MANAGEMENT_FOLDER \
    --github-repos=$ENV_REPO \
    --impersonators=group:$PLATFORM_ADMIN_GROUP \
    --name=$ENV \
    --owners=group:$PLATFORM_ADMIN_GROUP \
    --billing-account=$BILLING_ACCOUNT
```

This will attempt to initialize an environment called `dev`, as before, the script is idempotent and can generally be re-ran in the face of errors until it has completed.

> ![WARNING]
> If the errors are that your SA doesn't have permissions to do something, that probably won't be fixed by re-running

### Manual Steps

#### Brand

The IAP Brand needs to be manually created before deploying the Developer Platform.
After running the environment creation. Get the project id under the new environments folder
then run:

```
PLATFORM_ADMIN_GROUP=???
PROJECT=???
gcloud iap oauth-brands create --application_title="Developer Platform" --support_email="$PLATFORM_ADMIN_GROUP" --project $PROJECT
```

> ![WARNING]
> The person executing this much be an owner of the $PLATFORM_ADMIN_GROUP

#### DNS Delegation

See [DNS Delegation](../dns) and [Identity Provider Login](../internal-services)





