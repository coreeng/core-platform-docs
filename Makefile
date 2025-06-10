# Set tenant and app name
P2P_TENANT_NAME ?= core-platform-docs
P2P_APP_NAME ?= core-platform-docs

# Download and include p2p makefile
$(shell curl -fsSL "https://raw.githubusercontent.com/coreeng/p2p/v1/p2p.mk" -o ".p2p.mk")
include .p2p.mk

# Define required p2p targets
p2p-build:         build-app           push-app
p2p-functional:    build-functional    push-functional    deploy-functional    run-functional
p2p-nft:           build-nft           push-nft           deploy-nft           run-nft
p2p-integration:   build-integration   push-integration   deploy-integration   run-integration
p2p-extended-test: build-extended-test push-extended-test deploy-extended-test run-extended-test
p2p-prod:                                                 deploy-prod



.PHONY: lint-config
lint-config: ## Run config lint checks
	docker run --rm --mount type=bind,source=./p2p/config,target=/data docker.io/cytopia/yamllint -s .

.PHONY: lint-dockerfile
lint-dockerfile: ## Run dockerfile lint checks
	docker run --rm -i docker.io/hadolint/hadolint < p2p/tests/functional/Dockerfile
	docker run --rm -i docker.io/hadolint/hadolint < p2p/tests/nft/Dockerfile
	docker run --rm -i docker.io/hadolint/hadolint < p2p/tests/integration/Dockerfile
	docker run --rm -i docker.io/hadolint/hadolint < p2p/tests/extended/Dockerfile
	docker run --rm -i docker.io/hadolint/hadolint < Dockerfile

.PHONY: lint-app
lint-app: ## Run app lint checks
	@echo "WARNING: $@ not implemented"

.PHONY: lint
lint: lint-config lint-dockerfile lint-app ## Run all lint checks



.PHONY: build-app
build-app: lint ## Build app
	docker buildx build $(p2p_image_cache) --tag "$(p2p_image_tag)" .

.PHONY: build-functional
build-functional:
	docker buildx build $(p2p_image_cache) --tag "$(p2p_image_tag)" p2p/tests/functional/

.PHONY: build-nft
build-nft:
	docker buildx build $(p2p_image_cache) --tag "$(p2p_image_tag)" p2p/tests/nft/

.PHONY: build-integration
build-integration:
	docker buildx build $(p2p_image_cache) --tag "$(p2p_image_tag)" p2p/tests/integration/

.PHONY: build-extended-test
build-extended-test:
	docker buildx build $(p2p_image_cache) --tag "$(p2p_image_tag)" p2p/tests/extended/

.PHONY: build-%
build-%:
	@echo "WARNING: $@ not implemented"



.PHONY: push-%
push-%:
	docker image push "$(p2p_image_tag)"



.PHONY: deploy-%
deploy-%:
	helm repo add core-platform-assets https://coreeng.github.io/core-platform-assets

	envsubst < p2p/config/$*.yaml | \
	helm upgrade --install "$(p2p_app_name)" core-platform-assets/core-platform-app -n "$(p2p_namespace)" \
		-f p2p/config/common.yaml \
		-f - \
		--set nameOverride="$(p2p_app_name)" \
		--set tenantName="$(p2p_tenant_name)" \
		--set image.repository="$(p2p_registry)/$(p2p_app_name)" \
		--set image.tag="$(p2p_version)" \
		--set ingress.appUrlSuffix="$(p2p_app_url_suffix)" \
		--set ingress.domain="$(BASE_DOMAIN)" \
		--atomic



.PHONY: run-app
run-app: ## Run app
	docker run --rm -p 3000:3000 --name "$(p2p_app_name)" "$(p2p_image_tag)"

.PHONY: run-functional
run-functional:
	bash p2p/scripts/helm-test.sh functional "$(p2p_namespace)" "$(p2p_app_name)" true

.PHONY: run-nft
run-nft:
	bash p2p/scripts/helm-test.sh nft "$(p2p_namespace)" "$(p2p_app_name)" true

.PHONY: run-integration
run-integration:
	bash p2p/scripts/helm-test.sh integration "$(p2p_namespace)" "$(p2p_app_name)" false

.PHONY: run-extended-test
run-extended-test:
	bash p2p/scripts/helm-test.sh extended "$(p2p_namespace)" "$(p2p_app_name)" false

.PHONY: run-%
run-%:
	@echo "WARNING: $@ not implemented"
