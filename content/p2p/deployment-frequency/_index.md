+++
title = "Deployment Frequency"
weight = 100
chapter = false
pre = ""
+++

The Core Platform P2P can be configured to deploy your application in one of three modes:

* *Right away:* Fast feedback runs right away, followed by extended test, followed by production deployment. 
* *On a schedule:* Fast feedback runs right away, extended test and production run on a schedule.
* *Manually:* Fast feedback runs right away, extended test and production are manually triggered.

Or a hybrid of one of the above e.g. Fast feedback and extended test run right away, production is manually triggered.

## Right away

Create a single CD.yaml workflow file in your repo in `./github/workflows` with the following content:

```yaml
name: Continuous Deployment

on:
  workflow_dispatch:
  push:
    branches:
      - main
  pull_request:
    branches:
      - main

permissions:
  contents: write
  id-token: write

jobs:
  version:
    uses: coreeng/p2p/.github/workflows/p2p-version.yaml@v1
    secrets:
      git-token: ${{ secrets.GITHUB_TOKEN }} 

  fastfeedback:
    needs: [version]
    uses: coreeng/p2p/.github/workflows/p2p-workflow-fastfeedback.yaml@v1
    with:
      version: ${{ needs.version.outputs.version }}

  extended-test:
    needs: [version, fastfeedback]
    uses: coreeng/p2p/.github/workflows/p2p-workflow-extended-test.yaml@v1
    with:
      version: ${{ needs.version.outputs.version }}

  prod:
    needs: [version, extended-test]
    uses: coreeng/p2p/.github/workflows/p2p-workflow-prod.yaml@v1
    with:
      version: ${{ needs.version.outputs.version }}
```


## Schedule

This is the configuration all templates come with where:
* Fast feedback runs for every commit to main
* Extended test runs once a day, on the latest version that passed fastfeedback
* Production runs once a day, on the latest version that passed extended test

Create three workflows in your repo in `./github/workflows` with the following content:

### Fast Feedback

```yaml
name: Fast Feedback

on:
  workflow_dispatch:
  push:
    branches:
      - main
  pull_request:
    branches:
      - main

permissions:
  contents: write
  id-token: write

jobs:
  version:
    uses: coreeng/p2p/.github/workflows/p2p-version.yaml@v1
    secrets:
      git-token: ${{ secrets.GITHUB_TOKEN }}
    
  fastfeedback:
    needs: [version]
    uses: coreeng/p2p/.github/workflows/p2p-workflow-fastfeedback.yaml@v1
    with:
     version: ${{ needs.version.outputs.version }}
```

### Extended Test

```yaml
name: Extended Test

on:
  workflow_dispatch:
  schedule:
    - cron: '0 22 * * *'

permissions:
  contents: read
  id-token: write

jobs:
  get-latest-version:
    uses: coreeng/p2p/.github/workflows/p2p-get-latest-image-extended-test.yaml@v1
    with:
      image-name: go-reference-app

  extendedtests:
    needs: [get-latest-version]
    uses: coreeng/p2p/.github/workflows/p2p-workflow-extended-test.yaml@v1
    with:
      version: ${{ needs.get-latest-version.outputs.version }}
```

### Prod 

```yaml
name: Prod

on:
  workflow_dispatch:
  schedule:
    - cron: '30 5 * * 1,5'

permissions:
  contents: read
  id-token: write

jobs:
  get-latest-version:
    uses: coreeng/p2p/.github/workflows/p2p-get-latest-image-prod.yaml@v1
    with:
      image-name: go-reference-app

  prod:
    needs: [get-latest-version]
    uses: coreeng/p2p/.github/workflows/p2p-workflow-prod.yaml@v1
    with:
      version: ${{ needs.get-latest-version.outputs.version }}
```


## Manually

For manually, create the same workflows as scheduled but remove the `schedule`. The manual trigger is available in the Actions tab in your repo.