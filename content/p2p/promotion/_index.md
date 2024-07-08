+++
title = "Promotion"
weight = 2
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

```
.PHONY: p2p-promote-generic
p2p-promote-generic:  ## Generic promote functionality
	@echo "$(red) Retagging version ${image_tag} from $(SOURCE_REGISTRY) to $(REGISTRY)"
	export CLOUDSDK_AUTH_CREDENTIAL_FILE_OVERRIDE=$(SOURCE_AUTH_OVERRIDE) ; \
	gcloud auth configure-docker --quiet europe-west2-docker.pkg.dev; \
	docker pull $(SOURCE_REGISTRY)/$(source_repo_path)/$(image_name):${image_tag} ; \
	docker tag $(SOURCE_REGISTRY)/$(source_repo_path)/$(image_name):${image_tag} $(REGISTRY)/$(dest_repo_path)/$(image_name):${image_tag}
	@echo "$(red) Pushing version ${image_tag}"
	export CLOUDSDK_AUTH_CREDENTIAL_FILE_OVERRIDE=$(DEST_AUTH_OVERRIDE) ; \
	docker push $(REGISTRY)/$(dest_repo_path)/$(image_name):${image_tag}
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

For lower environments these may be the same registry so the `source_repo_path` and `dest_repo_path` are included


The steps are:

* After Fastfeedback on the main branch `p2p-promote-to-extended-test` is executed where the default implementation for all applications is:
 
```
.PHONY: p2p-promote-to-extended-test
p2p-promote-to-extended-test: source_repo_path=$(FAST_FEEDBACK_PATH)
p2p-promote-to-extended-test: dest_repo_path=$(EXTENDED_TEST_PATH)
p2p-promote-to-extended-test:  p2p-promote-generic
```

* After extended test the `p2p-promote-to-prod` is executed where the default implementation for all applications is:

```
.PHONY: p2p-promote-to-prod
p2p-promote-to-prod:  source_repo_path=$(EXTENDED_TEST_PATH)
p2p-promote-to-prod:  dest_repo_path=$(PROD_PATH)
p2p-promote-to-prod:  p2p-promote-generic
```
