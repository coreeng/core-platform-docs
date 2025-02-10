+++
title = "Production Deployment"
weight = 4
chapter = false
pre = ""
+++

## How to use this on the pipeline?

These should be triggered by a cron on git actions, and the pipeline will look like:
{{< figure src="/images/p2p/prod.png" title="Production" >}}

## Usage

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
