+++
title = "Path to Production"
weight = 1
chapter = false
pre = ""
+++

## Core Platform P2P

The common P2P enables you to focus on building your business logic and tests without
wasting time on CI/CD tooling setup.
All your custom logic should be added to your Makefile rather than directly in GitHub actions.


## Automatic GH Action authentication

As part of your [tenancy](../../app/tenancy) you define GitHub repos.

All of those repos get passwordless access to deploy to your namespaces and
any sub namespace you create.

### Requirements

In order to use this pipeline, you'll need to be a tenant in a CECG core platform.
Make sure you have these details:
- Project ID
- Project Number
- Tenant Name

Having these, you're set to start deploying!

{{% notice note %}}
Having both, project id and project number, at the same time is redundant, because one can be derived from the other.
But for historical reasons, both are present.
Having project number is required for authentication
using [google-github-actions/auth](https://github.com/google-github-actions/auth)
and having the project id is required for all the other operations.
Removing the project id (and deriving it from the project number) would require significant refactoring.
{{% /notice %}}

### How to use?

First, you need to configure your CI/CD 
to call our reusable pipelines by configuring your workflow files inside your repo in `./github/workflows`.

If you created an application from template, those workflow files will be preconfigured for you.

Read more details about each step:
- [Fast Feedback](./fast-feedback)
- [Extended Test](./extended-test)
- [Prod Deployment](./prod)

### Makefile

The pipelines assume you have a Makefile and that in that Makefile you have the following tasks:
```
.PHONY: p2p-build 
p2p-build: ## Build phase
    echo "##### EXECUTING P2P-BUILD #####"

.PHONY: p2p-functional 
p2p-functional: ## Execute functional tests
    echo "##### EXECUTING P2P-FUNCTIONAL #####"

.PHONY: p2p-nft
p2p-nft:  ## Execute functional tests
    echo "##### EXECUTING P2P-NFT #####"

.PHONY: p2p-extended-test
p2p-extended-test: ## Runs extended tests
    echo "##### EXECUTING P2P-EXTENDED-TEST #####"

.PHONY: p2p-prod
p2p-prod: ## Runs the service
    echo "##### EXECUTING P2P-PROD #####"

.PHONY: p2p-promote-to-extended-test
p2p-promote-to-extended-test: ## Promote service to extended test
    echo "##### EXECUTING P2P-PROMOTE-TO-EXTENDED-TEST #####"

.PHONY: p2p-promote-to-prod
p2p-promote-to-prod:  ## Promote service to prod
    echo "##### EXECUTING P2P-PROMOTE-TO-PROD #####"
```

These will be the entrypoints of the pipeline. You can then extend these to do your custom actions. 

### GitHub Variables

P2P pipelines expect some GitHub Variables to be configured.
You can configure it either automatically using `corectl` or manually.

#### Automatically
You can automatically set/update variables using `corectl`:
```bash
corectl p2p env sync <app-repository> <tenant-name>
```

#### Manually

Create your environments with the following variables:
* `BASE_DOMAIN` e.g. `gcp-dev.cecg.platform.cecg.io`
* `INTERNAL_SERVICES_DOMAIN` e.g. `gcp-dev-internal.cecg.platform.cecg.io`
* `DPLATFORM` environment name from platform-environments e.g. `dev`
* `PROJECT_ID` project id from platform environments e.g. `core-platform-efb3c84c`
* `PROJECT_NUMBER` project number for the project id above

{{< figure src="/images/p2p/git-environments.png" title="Git Environments" >}}


Usually you need at least two environments, e.g.

* `dev`
* `prod`

For an instance of the CECG Core Platform on GCP.

A single dev environment is enough for Fast Feedback.

Set the following repository variables (these may be set globally for your org):

* `FAST_FEEDBACK` to `{"include": [{"deploy_env": "dev"}]}`
* `EXTENDED_TEST` to `{"include": [{"deploy_env": "dev"}]}`
* `PROD` to `{"include": [{"deploy_env": "prod"}]}`

And specifically for your app set:

* `TENANT_NAME` as configured in your tenancy in platform environments
