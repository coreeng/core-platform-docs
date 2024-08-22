+++
title = "Deploying Cloud Infrastructure from the P2P"
weight = 353
chapter = false
pre = "3. "
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
p2p-golang@{{ project-id }}.iam.gserviceaccount.com
```

This is your `CLOUD_SERVICE_ACCOUNT``

The output should be the service account email starting with `p2p-`.

Once you have this you can, in your infrastructure project, assign permission to it so when
the pipeline next runs it can provision the infrastructure e.g. with terraform. This is only provisioning
that we recommend out side of the p2p as it is a chicken and egg problem.

When your make tasks are executed you will already be authenticated with gcloud so you don't need to do any of that setup.

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


## P2P
Infrastructure code should implement the steps of the P2P. But who do these work?

### p2p-build

The build phase should package the whole infrastructure code in a docker image. That image should be versioned and pushed to the platform provided registry.
This image should have everything it needs to successfully deploy the infrastructure, meaning Terraform, Terragrunt, etc..

### p2p-function / p2p-nft

These steps should pull the image that was just pushed in the p2p-build. It then should do a `docker run` with passing different args.
```
docker-apply:
	mkdir -p ~/.config
	mkdir -p ~/.config/gcloud
	cat $(CLOUDSDK_AUTH_CREDENTIAL_FILE_OVERRIDE) >> ~/.config/gcloud/application_default_credentials.json
	
	docker run --rm \
	-e ENV=${ENV} \
	-e ENVIRONMENT=${environment} \
	-e TERRAFORM_ARGS="-auto-approve" \
	-v ~/.config/gcloud/:/root/.config/gcloud \
	-v "${PWD}/Makefile:/app/Makefile" \
	-v "${PWD}/environments/${environment}/config.yaml:/app/environments/${environment}/config.yaml" \
	$(REGISTRY)/${repo_path}/infra:$(VERSION) \
	make infra-apply
```

#### Docker Auth
On GithubActions, you'll be authenticated to the platform, so you can reuse those credential to run using docker.
The above `docker-apply` task will copy the credentials on the application_default_credentials.json and then mount that as a volume in the docker run, making the commands in the docker use those credentials.

```
...
cat $(CLOUDSDK_AUTH_CREDENTIAL_FILE_OVERRIDE) >> ~/.config/gcloud/application_default_credentials.json
...
```

### p2p-promote

This setup makes promotion work in a similar way to the application. It will simply promote the versioned docker artifact across different registry paths/registries as deploy to extended-test and prod the latest versions promoted to those environments.