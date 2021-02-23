APIEXTENSIONS_BRANCH := master

MODEL_GEN_FOLDER := pkg/model-gen
APIS_DIR := $(MODEL_GEN_FOLDER)/cache/pkg/apis

SPEC_FILE_NAME := swagger.yaml

BUILD_COLOR = ""
GEN_COLOR = ""
NO_COLOR = ""

ifneq (, $(shell command -v tput))
ifeq ($(shell test `tput colors` -ge 8 && echo "yes"), yes)
BUILD_COLOR = \033[0;34m
GEN_COLOR = \033[0;32m
NO_COLOR = \033[0m
endif
endif

all: generate

.PHONY: generate
generate:
	@$(MAKE) openapi-model
	@$(MAKE) openapi-spec

# Generate OpenAPI models.
.PHONY: openapi-model
openapi-model: openapi-model-gen-prereqs openapi-model-build-gen
	@echo "$(GEN_COLOR)Generating OpenAPI models $(NO_COLOR)"
	@for gv in $(shell find $(APIS_DIR) -maxdepth 2 -mindepth 2 | sed 's|pkg/model-gen/cache/pkg/apis/||') ; do \
		$(MODEL_GEN_FOLDER)/model-gen \
		--input-dirs "github.com/giantswarm/apiextensions/v3/pkg/apis/$$gv,github.com/giantswarm/apiextensions/v3/pkg/serialization,k8s.io/apimachinery/pkg/apis/meta/v1,k8s.io/apimachinery/pkg/api/resource,k8s.io/apimachinery/pkg/runtime,k8s.io/apimachinery/pkg/version,k8s.io/api/core/v1" \
		--output-package "$$gv" \
		--output-base pkg/apis \
		--go-header-file hack/boilerplate.go.txt ; \
	done
	rm -rf $(MODEL_GEN_FOLDER)/cache

# Handle OpenAPI model generator pre-requisites.
openapi-model-gen-prereqs:
	@echo "$(BUILD_COLOR)Caching apiextensions branch '$(APIEXTENSIONS_BRANCH)'$(NO_COLOR)"
	@go get github.com/giantswarm/apiextensions@$(APIEXTENSIONS_BRANCH)
	mkdir -p $(MODEL_GEN_FOLDER)/cache
	git clone \
	--single-branch \
	--branch $(APIEXTENSIONS_BRANCH) \
	https://github.com/giantswarm/apiextensions.git \
	$(MODEL_GEN_FOLDER)/cache

# Build OpenAPI model generator.
openapi-model-build-gen: $(MODEL_GEN_FOLDER)/go.mod
	@echo "$(BUILD_COLOR)Building OpenAPI model generator$(NO_COLOR)"
	cd $(MODEL_GEN_FOLDER) \
	&& go build -tags=tools -o model-gen k8s.io/code-generator/cmd/openapi-gen

# Generate OpenAPI spec.
.PHONY: openapi-spec
openapi-spec: openapi-spec-build-gen
	@echo "$(BUILD_COLOR)Generating OpenAPI spec$(NO_COLOR)"
	./cp-api-spec
	cp $(SPEC_FILE_NAME) pkg/spec/$(SPEC_FILE_NAME)
	rm -rf $(SPEC_FILE_NAME)

# Build OpenAPI spec generator.
openapi-spec-build-gen: go.mod
	@echo "$(BUILD_COLOR)Building OpenAPI spec generator$(NO_COLOR)"
	@echo "Using apiextensions branch '$(APIEXTENSIONS_BRANCH)'"
	@go get github.com/giantswarm/apiextensions/v3@$(APIEXTENSIONS_BRANCH)
	@go build
