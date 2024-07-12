+++
title = "Build - p2p-build"
weight = 1
chapter = false
pre = ""
+++

An example implementation from the golang reference application:

* Runs golang linting
* Builds the service into an image
* Pushes the image to the REGISTRY

The REGISTRY environment variable is set automatically by the common P2P based on the `PROJECT_ID` you've set when creating your initial P2P GitHub Action.


```
image_name = reference-app
image_tag = latest
tenant_name = golang

.PHONY: p2p-build
p2p-build: lint service-build service-push ## Builds the service image and pushes it to the registry
	docker run -v "$$(pwd)":/var/app ghcr.io/mgechev/revive:v1.3.2  -config /var/app/revive.toml -formatter stylish  ./var/app/cmd/service ./var/app/cmd/handler
	docker build --file Dockerfile --tag $(REGISTRY)/$(image_name):$(image_tag) .
	docker image push $(REGISTRY)/$(image_name):$(image_tag)
```

Tools for versioning will be added in a future version of the P2P.

## Executing p2p-build locally

You set the `REGISTRY` env var as follows:

`REGISTRY=europe-west2-docker.pkg.dev/${PROJECT_ID}/tenant/${TENANT}`

You can get the PROJECT_ID from your Environments Repo. 
Typically, for local development you'll want the dev `PROJECT_ID`.

