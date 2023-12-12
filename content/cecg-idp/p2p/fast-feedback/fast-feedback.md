+++
title = "Fast Feedback"
weight = 1
chapter = false
pre = ""
+++

The aim of this pipeline shape is to provide fast feedback on the provided code. It will be used to quickly analyse a branch or a main code change.
We've defined a pipeline using github actions [here](https://github.com/coreeng/p2p).

What we propose looks like this:
{{< figure src="/images/p2p/fast-feedback.png" title="Fast Feedback" >}}

## Usage
```
push:
    branches:
      - main
  pull_request:
    branches:
      - main

permissions:
  contents: read
  id-token: write

// TODO UPDATE ME

  fastfeedback:
    uses: coreeng/p2p/.github/workflows/p2p-workflow-fastfeedback.yaml@v1
```

### GitHub Variables

#### Environments

Create your environments with the following variables:
* BASE_DOMAIN e.g. gcp-dev.cecg.platform.cecg.io
* DPLATFORM environment name from platform-environments e.g. gcp-dev
* PROJECT_ID project id from platform environments e.g. core-platform-efb3c84c
* PROJECT_NUMBER project number for the project id above

Usuaully you need at least two environments e.g.

* `gcp-dev`
* `gcp-prod`


For an instance of the CECG developer platform on GCP.

A single dev environment is enough for fastfeedback.

Set the following repository variables (these may be set globally for your org):

* `FAST_FEEDBACK` to {"include": [{"deploy_env": "gcp-dev"}]}
* `EXTENDED_TEST` to {"include": [{"deploy_env": "gcp-dev"}]}

And specifically for your app set:

* `TENANT_NAME` as configured in your tenancy in platform environments

### Make tasks

Available env vars for all envs:

* `REGISTRY` that you're authenticated to

Every task will have kubectl access as your tenant

#### p2p-build
#### p2p-functional
#### p2p-nft
#### p2p-build
#### p2p-promote-to-extended-test


## What version to use
On each build of the p2p pipeline we create 3 version
* vX - Tag with just the major version that's updated on each build.
* vX.X - Tag with the major and minor version. This too is updated on each build
* vX.X.X - Tag with the full semantic version. This is never updated and you can use this to pin a specific version.
