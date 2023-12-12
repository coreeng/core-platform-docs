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

## Promotion
We want to ensure that we always use the same image. The promotion will consist in pulling the image that we want to promote and pushing to the new registry. 
Due to the limitations of github actions, you can't stay authenticated to 2 project registries at the same time. For that reason, in order to promote an image across projects, you'll need to switch between authentications.
We'll make the auth values available in environment variables
* `SOURCE_AUTH_OVERRIDE` will give you access to `SOURCE_REGISTRY`
* `DEST_AUTH_OVERRIDE` will give you acccess to `REGISTRY`

That way, to promote an image you will have osmething like
```
    export CLOUDSDK_AUTH_CREDENTIAL_FILE_OVERRIDE=$(SOURCE_AUTH_OVERRIDE)  # Set the cloudsdk env var with the source auth value
	gcloud auth configure-docker --quiet europe-west2-docker.pkg.dev # Configure registry
	docker pull $(SOURCE_REGISTRY)/$(source_repo_path)/$(image_name):${image_tag} # Pull image to be promoted
	export CLOUDSDK_AUTH_CREDENTIAL_FILE_OVERRIDE=$(DEST_AUTH_OVERRIDE) # Change the auth credentials to the destination registry
	docker push $(REGISTRY)/$(dest_repo_path)/$(image_name):${image_tag} # push images to be promoted
```