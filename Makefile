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



.PHONY: lint
lint: ## Run lint checks
	docker run --rm -i docker.io/hadolint/hadolint < Dockerfile
	docker run --rm -i docker.io/hadolint/hadolint < functional/Dockerfile
	docker run --rm -i docker.io/hadolint/hadolint < nft/Dockerfile
	docker run --rm -i docker.io/hadolint/hadolint < integration/Dockerfile
	docker run --rm -i docker.io/hadolint/hadolint < extended/Dockerfile



.PHONY: build-app
build-app: lint ## Build app
	docker buildx build $(p2p_image_cache) --tag "$(p2p_image_tag)" --file Dockerfile .

.PHONY: build-functional
build-functional:
	docker buildx build $(p2p_image_cache) --tag "$(p2p_image_tag)" --file functional/Dockerfile .

.PHONY: build-nft
build-nft:
	docker buildx build $(p2p_image_cache) --tag "$(p2p_image_tag)" --file nft/Dockerfile .

.PHONY: build-integration
build-integration:
	docker buildx build $(p2p_image_cache) --tag "$(p2p_image_tag)" --file integration/Dockerfile .

.PHONY: build-extended-test
build-extended-test:
	docker buildx build $(p2p_image_cache) --tag "$(p2p_image_tag)" --file extended/Dockerfile .



.PHONY: push-%
push-%:
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
	docker run --rm -p 3000:3000 --name "$(p2p_app_name)" "$(p2p_image_tag)"

.PHONY: run-functional
run-functional:
	bash scripts/helm-test.sh functional "$(p2p_namespace)" "$(p2p_app_name)" true

.PHONY: run-nft
run-nft:
	bash scripts/helm-test.sh nft "$(p2p_namespace)" "$(p2p_app_name)" true

.PHONY: run-integration
run-integration:
	bash scripts/helm-test.sh integration "$(p2p_namespace)" "$(p2p_app_name)" false

.PHONY: run-extended-test
run-extended-test:
#	bash scripts/extended-test.sh extended "$(p2p_namespace)" "$(p2p_app_name)" true 15m
	@echo "WARNING: extended test not implemented"
	kubectl -n "$(p2p_namespace)" scale --replicas=0 deployments,statefulsets --all