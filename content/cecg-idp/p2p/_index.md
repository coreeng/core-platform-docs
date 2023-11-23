+++
title = "Path to Production"
weight = 1
chapter = false
pre = ""
+++

The Path to Production is the contract for deploying to the developer platform.

## Automatic GH Action authentication

As part of your [tenancy](../../app/tenancy) you define GitHub repos.

All of those repos will get passwordless access to deploy to your namespaces and
any sub namespace you create.


## Importing the common P2P


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

It is recommend to set the variables above in your action variables.