+++
title = "Quality Gate: Fast Feedback"
weight = 11
chapter = false
pre = ""
+++


The aim of this pipeline shape is to provide fast feedback on the provided code. It will be used to quickly analyse a branch or a main code change.
We've defined a pipeline using github actions [here](https://github.com/coreeng/p2p).

What we propose looks like this:
{{< mermaid >}}
sequenceDiagram
actor User
User->>+Git: push to branch
Git->>+Git: build image
Git->>+Dev Registry: Push image to '/test'    
Git->>+Dev k8s: Deploy to Functional + Run tests
Git->>+Dev k8s: Deploy to NFT + Run tests
Git->>+Dev k8s: Deploy to Integration + Run tests
alt only when the branch is main
Git->>+Dev Registry: Promote image from '/test' to '/extended-test'
end
{{< /mermaid >}}

{{% notice warning %}}
Currently Integration tests (`p2p-integration` target) is optional. The workflow will skip this step when no `p2p-integration` target is found in Makefile. 
This is introduced as a temporary measure to avoid breaking changes. It will be removed in the future releases. Makefile target `p2p-integration` will be mandatory.
{{% /notice %}}

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

### Make tasks

Available env vars for all envs:

* `REGISTRY` that you're authenticated to

Every task will have kubectl access as your tenant

#### p2p-build
#### p2p-functional
#### p2p-integration
#### p2p-nft
#### p2p-build
#### p2p-promote-to-extended-test


## What version to use
On each build of the p2p pipeline it will create a vX tag with just the major version that's updated on each build.

## Promotion
We want to ensure that we always use the same image. The promotion will consist in pulling the image that we want to promote and pushing to the new registry. 
Due to the limitations of github actions, you can't stay authenticated to two project registries at the same time. For that reason, in order to promote an image across projects, you'll need to switch between authentications.
We'll make the auth values available in environment variables
* `SOURCE_AUTH_OVERRIDE` will give you access to `SOURCE_REGISTRY`
* `DEST_AUTH_OVERRIDE` will give you acccess to `REGISTRY`

That way, to promote an image you will have smething like
```
    export CLOUDSDK_AUTH_CREDENTIAL_FILE_OVERRIDE=$(SOURCE_AUTH_OVERRIDE)  # Set the cloudsdk env var with the source auth value
	gcloud auth configure-docker --quiet europe-west2-docker.pkg.dev # Configure registry
	docker pull $(SOURCE_REGISTRY)/$(source_repo_path)/$(image_name):${image_tag} # Pull image to be promoted
	export CLOUDSDK_AUTH_CREDENTIAL_FILE_OVERRIDE=$(DEST_AUTH_OVERRIDE) # Change the auth credentials to the destination registry
	docker push $(REGISTRY)/$(dest_repo_path)/$(image_name):${image_tag} # push images to be promoted
```
