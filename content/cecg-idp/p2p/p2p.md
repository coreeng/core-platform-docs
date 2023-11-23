+++
title = "Pipeline"
weight = 3
chapter = false
pre = ""
+++

## Developer Platform P2P

The common P2P enables you to focus on building your business logic and tests without
wasting time on CI/CD tooling setup.
All your custom logic should be added to your Makefile rather than directly in GitHub actions.

### Requirements

In order to use this pipeline, you'll need to be a tenant in a CECG core platform.
Make sure you have these details:
- Project ID
- Project Number
- Tenant Name

Having these, you're set to start deploying!

### How to use?

First, you need to configure your CI/CD to call our reusable pipiline by configuring your `p2p.yaml` inside your repo in `./github/workflows`

If you've started from a reference application this will already exist.

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
