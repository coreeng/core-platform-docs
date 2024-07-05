projectDir := $(realpath $(dir $(firstword $(MAKEFILE_LIST))))
os := $(shell uname)
image_name = core-platform-docs
image_tag = $(VERSION)
tenant_name = docs
FAST_FEEDBACK_PATH = fast-feedback
EXTENDED_TEST_PATH = extended-test
PROD_PATH = prod

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
p2p-functional: create-ns-functional deploy-dev # Temporarily while the promotion step isn't authenticated and can't deploy there
	helm upgrade  --recreate-pods --install core-platform-docs helm-charts/core-platform-docs -n $(tenant_name)-functional --set registry=$(REGISTRY)/$(FAST_FEEDBACK_PATH) --set domain=$(BASE_DOMAIN) --set service.tag=$(image_tag) --set subDomain=docs-functional --atomic
	helm list -n $(tenant_name)-functional ## list installed charts in the given tenant namespace

.PHONY: p2p-nft ## Noop for now
p2p-nft: 
	@echo noop

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

.PHONY: p2p-promote-to-extended-test
p2p-promote-to-extended-test: source_repo_path=$(FAST_FEEDBACK_PATH)
p2p-promote-to-extended-test: dest_repo_path=$(EXTENDED_TEST_PATH)
p2p-promote-to-extended-test: p2p-promote-generic

.PHONY: p2p-promote-to-prod
p2p-promote-to-prod: source_repo_path=$(EXTENDED_TEST_PATH)
p2p-promote-to-prod: dest_repo_path=$(PROD_PATH)
p2p-promote-to-prod: p2p-promote-generic

.PHONY: deploy-dev
deploy-dev: create-ns-dev 
	helm upgrade  --recreate-pods --install core-platform-docs helm-charts/core-platform-docs -n $(tenant_name)-dev --set registry=$(REGISTRY)/$(FAST_FEEDBACK_PATH) --set domain=$(BASE_DOMAIN) --set service.tag=$(image_tag) --set subDomain=docs --atomic
	helm list -n $(tenant_name)-dev ## list installed charts in the given tenant namespace

.PHONY: p2p-prod
p2p-prod:  
	helm upgrade  --recreate-pods --install knowledge-platform helm-charts/knowledge-platform -n $(tenant_name) --set registry=$(REGISTRY)/$(PROD_PATH) --set domain=$(BASE_DOMAIN) --set service.tag=$(image_tag) --set subDomain=docs --atomic
	helm list -n $(tenant_name) ## list installed charts in the given tenant namespace

.PHONY: p2p-extended-test
p2p-extended-test:  ## Runs extended tests
	echo "### EXTENDED TESTS RUN ###"
	
.PHONY: create-ns-dev
create-ns-dev: ## Create namespace for dev
	awk -v NAME="$(tenant_name)" -v ENV="dev" '{ \
		sub(/{tenant_name}/, NAME);  \
		sub(/{env}/, ENV);  \
		print;  \
	}' resources/subns-anchor.yaml | kubectl apply -f - 	

.PHONY: create-ns-functional
create-ns-functional: ## Create namespace for functional tests
	awk -v NAME="$(tenant_name)" -v ENV="functional" '{ \
		sub(/{tenant_name}/, NAME);  \
		sub(/{env}/, ENV);  \
		print;  \
	}' resources/subns-anchor.yaml | kubectl apply -f - 	
# Docker tasks

.PHONY: service-build
service-build:
	docker build --file Dockerfile --tag $(REGISTRY)/$(FAST_FEEDBACK_PATH)/$(image_name):$(image_tag) .
	
.PHONY: service-push
service-push: ## Push the service image
	docker image push $(REGISTRY)/$(FAST_FEEDBACK_PATH)/$(image_name):$(image_tag)

.PHONY: run-local
run-local: ## Build and run docker container locally
	docker build . -t local-kp && \
	  docker run -p 8080:8080 \
	    --env LIVE_RELOAD=true\
	  	--env BASE_URL=http://localhost:8080\
	  	local-kp