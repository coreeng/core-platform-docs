+++
title = "Production Deployment"
weight = 4
chapter = false
pre = ""
+++

Production deployment, by default once a day, takes the latest version that has passed [extended test](/p2p/extended-test/)
and deploys it to production.

Implement the following Make targets:

* [p2p-prod](/p2p/prod/p2p-prod/)

## Usage

If you've created your application with corectl from a software template the following workflow will be
already configured.

```yaml
name: Prod

on:
  workflow_dispatch:
  schedule:
    - cron: '35 5 * * 1,5'

permissions:
  contents: read
  id-token: write

jobs:
  get-latest-version:
    uses: coreeng/p2p/.github/workflows/p2p-get-latest-image-prod.yaml@v1
    with:
      image-name: knowledge-platform

  prod:
    needs: [get-latest-version]
    uses: coreeng/p2p/.github/workflows/p2p-workflow-prod.yaml@v1
    with:
      version: ${{ needs.get-latest-version.outputs.version }}
```

This task will get the latest version that's on the `prod` registry and execute the prod deployment task.

### FAQs

#### What if I don't have tests for one of the stages?

* Leave it as a no-op and as you want to increase your maturity and aim for Continuous Delivery you already have the place to run them
