+++
title = "Path to Production"
weight = 1
chapter = false
pre = ""
+++

## Developer Platform P2P

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

First, you need to configure your CI/CD to call our reusable pipeline by configuring your `p2p.yaml` inside your repo in `./github/workflows`

If you've started from a reference application, this will already exist.

```
name: P2P
on:
  pull_request:
    branches:
      - main
  push:
    branches:
      - main

permissions:
  contents: read
  id-token: write

jobs:
  p2p:
    uses: coreeng/p2p/.github/workflows/p2p.yaml@main
    secrets:
      env_vars: |
        ENVIRONMENT=${{ vars.ENV }}
        BASE_URL=${{ vars.BASE_URL }}
    with:
      env-name: ${{ vars.ENV }}
      project-id: ${{ vars.PROJECT_ID }}
      project-number: ${{ vars.PROJECT_NUMBER }}
      tenant-name: ${{ vars.TENANT_NAME }}
```

### Makefile

The pipeline assumes you have a Makefile and that in that Makefile you have the following tasks:
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

.PHONY: p2p-dev
p2p-dev:  ## Deploys to dev environment
	echo "##### EXECUTING P2P-DEV #####"
```

These will be the entrypoints of the pipeline. You can then extend these to do your custom actions. 
