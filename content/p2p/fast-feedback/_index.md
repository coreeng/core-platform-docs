+++
title = "Quality Gate: Fast Feedback"
weight = 2
chapter = false
pre = ""
+++

Fast feedback gives engineers fast feedback on every change.
It is run on every PR and on every commit to main.

Implement the following Make targets:

* [p2p-build](./p2p-build)
* [p2p-functional](./p2p-functional)
* [p2p-nft](./p2p-nft)
* [p2p-integration](p2p-integration)
* [p2p-promote-to-extended-test](p2p-promote-to-extended-test)

## Usage

If you used corectl to create your application this workflow will already be in your repository.

```yaml
name: Fast Feedback

on:
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
