# Set tenant and app name
P2P_TENANT_NAME ?= core-platform-docs
P2P_APP_NAME ?= core-platform-docs

# Download and include p2p makefile
$(shell curl -fsSL "https://raw.githubusercontent.com/coreeng/p2p/v1/p2p.mk" -o ".p2p.mk")
include .p2p.mk

# Define required p2p targets
p2p-build: build-app push-app
p2p-integration: deploy-integration
p2p-prod: deploy-prod



.PHONY: lint
lint: ## Run lint checks
	docker run --rm -i docker.io/hadolint/hadolint < Dockerfile
	docker run --rm -i -v $(PWD):/workdir davidanson/markdownlint-cli2:v0.17.2



.PHONY: build-app
build-app: lint ## Build app
	docker buildx build $(p2p_image_cache) --tag "$(p2p_image_tag)" --file Dockerfile .



.PHONY: push-app
push-app:
	docker image push "$(p2p_image_tag)"



.PHONY: deploy-%
deploy-%:
	helm upgrade --install "$(p2p_app_name)" helm-charts/core-platform-docs -n "$(p2p_namespace)" \
		--set subDomain="docs" \
		--set registry="$(p2p_registry)" \
		--set domain="$(BASE_DOMAIN)" \
		--set service.tag="$(p2p_version)" \
		--atomic



.PHONY: run-app
run-app: ## Run app
	docker run --rm --name "$(p2p_app_name)" \
		-p 8080:8080 \
		--volume ./:/site \
		-e LIVE_RELOAD=true \
		-e BASE_URL=http://localhost:8080 \
		"$(p2p_image_tag)"
