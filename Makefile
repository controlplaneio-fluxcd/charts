# Makefile for building, testing, and publishing the ControlPlane Helm Charts.

SHELL = /usr/bin/env bash -o pipefail
.SHELLFLAGS = -ec

.PHONY: all
all: manifests lint ## Run all targets.

.PHONY: generate
generate: ## Update the CustomResourceDefinitions and App version for all charts.
	./scripts/flux-operator.sh

.PHONY: manifests
manifests: ## Generate schema and docs for all charts.
	./scripts/manifests.sh

.PHONY: lint
lint:  ## Run Helm linter against all charts.
	./scripts/lint.sh

.PHONY: package
package: ## Package all Helm charts into the dist directory.
	./scripts/package.sh

.PHONY: push
push: ## Push all Helm charts to the Helm repository.
	./scripts/push.sh

.PHONY: sign
sign: ## Sign all Helm charts on the Helm repository.
	./scripts/sign.sh

.PHONY: plugins
plugins: ## Install required Helm plugins.
	helm plugin install https://github.com/losisin/helm-values-schema-json.git

.PHONY: help
help: ## Display this help.
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
