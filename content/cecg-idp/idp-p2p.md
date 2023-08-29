+++
title = "CECG IDP P2P"
weight = 1
chapter = false
pre = ""
+++

## CECG IDP P2P

At CECG we're using github actions to deploy our reference IDP application. We've defined a pipeline [here](https://github.com/coreeng/reusable-p2p).

This is what the shape of it lookes like:

`| Build | ` -> `| Functional | ` -> `| NFT | ` -> `| Dev | `


### Requirements
In order to use this pipeline, you'll need to be a tenant in a CECG core platform.
Make sure you have these details:
- Project ID
- Project Number
- Tenant Name

Having these, you're set to start deploying!

### How to use?
First, you need to configure your CI/CD to call our reusable pipiline by configuring your `p2p.yaml` inside your repo in `./github/workflows`

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
    uses: coreeng/reusable-p2p/.github/workflows/p2p.yaml@v0.0.1
    with:
      project-id: ${{ vars.PROJECT_ID }}
      project-number: ${{ vars.PROJECT_NUMBER }}
      tenant-name: ${{ vars.TENANT_NAME }}
```

Always check the latest version on the repository and update it in this job (eg. `coreeng/reusable-p2p/.github/workflows/p2p.yaml@v0.0.3`)

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
