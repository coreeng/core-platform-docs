+++
title = "Promotion"
weight = 10
chapter = false
pre = ""
+++

Promotion is the process of marking an immutable, versioned artifact as being ready for deployment to the next class of environment.

## What is used to promote?

The two main mechanisms for promotion are:

* Tests e.g. functional or non-functional tests
* Stability in an environment e.g. run a longer soak tests in a stage environment and check alerts or canary deployments

Both are possible with the Core Platform P2P. The reference steps all show how to do test based promotion, future reference
apps will show alert based promotion in later environments.

## Promotion Mechanism

The Core Platform uses Container Registry artifact copying as the promotion mechanism.

All reference applications and skeletons come with a helper task to do this:

```makefile
.PHONY: p2p-promote-generic
p2p-promote-generic:  ## Generic promote functionality
    corectl p2p promote $(image_name):${image_tag} \
        --source-stage $(source_repo_path) \
        --dest-registry $(REGISTRY) \
        --dest-stage $(dest_repo_path)
```

The task:

* Authenticates with the `source` registry
* Pulls the image to be promoted
* Tags the image with the `destination` registry
* Authenticates with the `destination` registry
* Pushes the image to the `destination` registry

The P2P sets all the variables:

* SOURCE_REGISTRY
* REGISTRY for the destination registry
* SOURCE_AUTH_OVERRIDE
* DEST_AUTH_OVERRIDE

`corectl p2p promote` defaults to environment variables set by P2P, so you don't need to set them explicitly.

Here is the full list of flags:

```bash
corectl p2p promote -h
Promotes image from source to destination registry. Only GCP is supported for now

Usage:
  corectl p2p promote <image_with_tag> [flags]

Flags:
      --dest-auth-override string     optional, defaults to environment variable: DEST_AUTH_OVERRIDE
      --dest-registry string          required, defaults to environment variable: DEST_REGISTRY
      --dest-stage string             required, defaults to environment variable: DEST_STAGE
  -h, --help                          help for promote
      --source-auth-override string   optional, defaults to environment variable: SOURCE_AUTH_OVERRIDE
      --source-registry string        required, defaults to environment variable: SOURCE_REGISTRY
      --source-stage string           required, defaults to environment variable: SOURCE_STAGE
```

For lower environments these may be the same registry so the `source_repo_path` and `dest_repo_path` are included

The steps are:

* After Fastfeedback on the main branch `p2p-promote-to-extended-test` is executed where the default implementation for all applications is:

```makefile
.PHONY: p2p-promote-to-extended-test
p2p-promote-to-extended-test: source_repo_path=$(FAST_FEEDBACK_PATH)
p2p-promote-to-extended-test: dest_repo_path=$(EXTENDED_TEST_PATH)
p2p-promote-to-extended-test:  p2p-promote-generic
```

* After extended test the `p2p-promote-to-prod` is executed where the default implementation for all applications is:

```makefile
.PHONY: p2p-promote-to-prod
p2p-promote-to-prod:  source_repo_path=$(EXTENDED_TEST_PATH)
p2p-promote-to-prod:  dest_repo_path=$(PROD_PATH)
p2p-promote-to-prod:  p2p-promote-generic
```
