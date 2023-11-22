+++
title = "Path to Production"
weight = 3
chapter = false
pre = ""
+++

## Developer Platform P2P

At CECG we're using github actions to deploy our reference IDP application. We've defined a pipeline [here](https://github.com/coreeng/p2p).

This is what the shape of it lookes like:
### Fast Feedback

`| Build | ` -> `| Functional | ` -> `| NFT | ` -> `| Extended-Test promotion |`

### Extended Tests

`| Run Extended Tests | ` -> `| Promote to Prod | `

{{< figure src="/images/p2p/extended-tests.png" title="Extended Tests" >}}

### Production

`| Prod deployment | `

{{< figure src="/images/p2p/prod.png" title="Production" >}}


Each phase can define a `pre-targets` and `post-targets` step. This will be makefile tasks that will be called before each stage. This would allow you for example to have gatings before promoting.

### Requirements

In order to use this pipeline, you'll need to be a tenant in a CECG core platform.
Make sure you have these details:
- Dev Project ID
- Prod Project ID
- Dev Project Number
- Prod Project Number
- Dev Environment
- Prod Environment
- Tenant Name
This should be setup with the env vars:
* PROD_DOMAIN
* DEV_DOMAIN
* PROD_PROJECT_ID
* DEV_PROJECT_ID
* PROD_ENV
* DEV_ENV
* PROD_PROJECT_NUMBER
* DEV_PROJECT_NUMBER

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

  increment-version:
    uses: coreeng/p2p/.github/workflows/increment-version.yaml@v0.18.0
    secrets:
      git-token: ${{ secrets.GITHUB_TOKEN }}
    with:
      dry-run: ${{ github.ref != 'refs/heads/main' }}

  p2p:
    uses: coreeng/p2p/.github/workflows/p2p.yaml@v0.18.0
    needs: increment-version
    secrets:
      env_vars: |
        DOMAIN=${{ vars.DOMAIN }}
        ENVIRONMENT=${{ vars.DEV_ENV }}
        TAG_VERSION=${{ needs.increment-version.outputs.version }}
    with:
      dev-env-name: ${{ vars.DEV_ENV }}
      dev-project-id: ${{ vars.DEV_PROJECT_ID }}
      dev-project-number: ${{ vars.DEV_PROJECT_NUMBER }}
      tenant-name: ${{ vars.TENANT_NAME }}
```

This will be your fast feedback that all PRs will and merges to main will run. On main runs, the `increment-version` job will also generate a new version and create a tag. If not main branch, it will just output the next version but not create a tag. You can use that to append the githash and have unique versions on your PR runs.

After that you can setup your `extended-tests.yaml`


```
name: Extended Tests
on:
  schedule:
    - cron: '0 22 * * 1-5'

permissions:
  contents: read
  id-token: write

jobs:

  p2p:
    uses: coreeng/p2p/.github/workflows/extended-tests.yaml@promote
    secrets:
      env_vars: |
        DOMAIN=${{ vars.DOMAIN }}
        DEV_ENVIRONMENT=${{ vars.DEV_ENV }}
        PROD_ENVIRONMENT=${{ vars.PRD_ENV }}
    with:
      dev-env-name: ${{ vars.DEV_ENV }}
      prod-env-name: ${{ vars.PROD_ENV }}
      dev-project-id: ${{ vars.DEV_PROJECT_ID }}
      prod-project-id: ${{ vars.PROD_PROJECT_ID }}
      dev-project-number: ${{ vars.DEV_PROJECT_NUMBER }}
      prod-project-number: ${{ vars.PROD_PROJECT_NUMBER }}
      tenant-name: ${{ vars.TENANT_NAME }}
```

This will run on a cron and should use the latest image that was promoted to extended-tests repo.
You can get from artifact registry the latest tag with the command `@VERSION=$(shell gcloud container images list-tags $(REGISTRY_DEV)/extended-test/$(image_name) --limit=1 --format=json | jq -r '.[0].tags[0]')`

The promotion stages are `<dev>/test` -> `<dev>/extended-test` -> `<prod>/release`.

For the promotion job, it can be defined like:

```
name: Production

on:
  workflow_dispatch: # This forces the job to only be triggered manually

permissions:
  contents: read
  id-token: write

jobs:

  p2p:
    uses: coreeng/p2p/.github/workflows/prod.yaml@v0.18.0
    secrets:
      env_vars: |
        DOMAIN=${{ vars.DOMAIN }}
        ENVIRONMENT=${{ vars.PROD_ENV }}
        TAG_VERSION=${{ needs.increment-version.outputs.version }}
    with:
      prod-env-name: ${{ vars.PROD_ENV }}
      prod-project-id: ${{ vars.PROD_PROJECT_ID }}
      prod-project-number: ${{ vars.PROD_PROJECT_NUMBER }}
      tenant-name: ${{ vars.TENANT_NAME }}
```
This should also pull the latest image that was promoted to `<prod>/release` and deploy it to production.

For each promotion stage there will be a `p2p-prepare-promotion-<environment>`. This will be used to pull images from dev to promote to prod on the `p2p-prepare-promotion-<environment>`.
The need for this came because there was no easy way to be authenticated to both dev and prod GCP registries at the same time without having to switch manually.

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

.PHONY: p2p-promote-extended-tests
p2p-promote-extended-tests: ## Promote to extended-tests phase
	echo "##### EXECUTING P2P-PROMOTE-EXTENDED-TESTS #####"

.PHONY: p2p-prepare-promotion-extended-tests
p2p-prepare-promotion-extended-tests: ## Optional task to repare promotion to extended tests
	echo "##### EXECUTING P2P-PREPARE-PROMOTION-EXTENDED-TESTS #####"

.PHONY: p2p-promote-prod
p2p-promote-prod: ## Promote to prod phase
	echo "##### EXECUTING P2P-PROMOTE-PROD #####"

.PHONY: p2p-prepare-promotion-prod
p2p-prepare-promotion-prod: ## Optional task to repare promotion to production
	echo "##### EXECUTING P2P-PREPARE-PROMOTION-PROD #####"

.PHONY: p2p-extended-tests
p2p-extended-tests: ## Run Extended Tests
	echo "##### EXECUTING P2P-EXTENDED-TESTS #####"

.PHONY: p2p-prod
p2p-prod: ## Deploys to production
	echo "##### EXECUTING P2P-PROD #####"

```

These will be the entrypoints of the pipeline. You can then extend these to do your custom actions. 
