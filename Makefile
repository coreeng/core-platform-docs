projectDir := $(realpath $(dir $(firstword $(MAKEFILE_LIST))))
os := $(shell uname)
VERSION ?= $(shell git rev-parse --short HEAD)
image_name = knowledge-platform
image_tag = latest
tenant_name = knowledge-platform

.PHONY: help-p2p
help-p2p:
	@grep -E '^[a-zA-Z1-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | grep p2p | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: help-all
help-all:
	@grep -E '^[a-zA-Z1-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

# P2P tasks

.PHONY: p2p-build
p2p-build: service-build service-push ## Builds the service image and pushes it to the registry

.PHONY: p2p-functional ## Noop for now
p2p-functional: 
	@echo noop

.PHONY: p2p-nft ## Noop for now
p2p-nft: 
	@echo noop

.PHONY: p2p-dev
p2p-dev: create-ns-dev 
	kubectl get pods -n knowledge-platform
	helm upgrade --install knowledge-platform helm-charts/knowledge-platform -n $(tenant_name)-dev --set registry=$(REGISTRY) --domain=$(BASE_URL) --atomic
	helm list -n $(tenant_name)-dev ## list installed charts in the given tenant namespace

.PHONY: create-ns-dev
create-ns-dev: ## Create namespace for dev
	awk -v NAME="$(tenant_name)" -v ENV="dev" '{ \
		sub(/{tenant_name}/, NAME);  \
		sub(/{env}/, ENV);  \
		print;  \
	}' resources/subns-anchor.yaml | kubectl apply -f - 	

# Docker tasks

.PHONY: service-build
service-build:
	docker build --file Dockerfile --tag $(REGISTRY)/$(image_name):$(image_tag) .
	
.PHONY: service-push
service-push: ## Push the service image
	docker image push $(REGISTRY)/$(image_name):$(image_tag)
