APIEXTENSIONS_BRANCH := add-openapi-spec-generator

APIS_DIR := "pkg/model-gen/cache/pkg/apis"

all: generate

.PHONY: generate
generate:
	@$(MAKE) openapi-model
	@$(MAKE) openapi-spec

.PHONY: openapi-model
openapi-model: openapi-model-gen-prereqs openapi-model-build-gen
	@for gv in $(shell find $(APIS_DIR) -maxdepth 2 -mindepth 2 | sed 's|pkg/model-gen/cache/pkg/apis/||') ; do \
		pkg/model-gen/model-gen \
		--input-dirs "github.com/giantswarm/apiextensions/pkg/apis/$$gv,github.com/giantswarm/apiextensions/pkg/serialization,k8s.io/apimachinery/pkg/apis/meta/v1,k8s.io/apimachinery/pkg/api/resource,k8s.io/apimachinery/pkg/runtime,k8s.io/apimachinery/pkg/version,k8s.io/api/core/v1" \
		--output-package "$$gv" \
		--output-base pkg/apis \
		--go-header-file hack/boilerplate.go.txt ; \
	done
	rm -rf pkg/model-gen/cache


openapi-model-gen-prereqs:
	@echo "Caching apiextensions branch '$(APIEXTENSIONS_BRANCH)'"
	mkdir -p pkg/model-gen/cache
	git clone \
	--single-branch \
	--branch $(APIEXTENSIONS_BRANCH) \
	https://github.com/giantswarm/apiextensions.git \
	pkg/model-gen/cache

openapi-model-build-gen: pkg/model-gen/go.mod
	@echo "Building OpenAPI model generator"
	cd pkg/model-gen \
	&& go build -tags=tools -o model-gen k8s.io/code-generator/cmd/openapi-gen

.PHONY: openapi-spec
openapi-spec: openapi-spec-build-gen
	@echo "Generating OpenAPI spec"
	./cp-api-spec
	cp swagger.yaml pkg/spec/swagger.yaml
	rm -rf swagger.yaml

openapi-spec-build-gen: go.mod
	@echo "Building OpenAPI spec generator"
	@echo "Using apiextensions branch '$(APIEXTENSIONS_BRANCH)'"
	@go get github.com/giantswarm/apiextensions@$(APIEXTENSIONS_BRANCH)
	@go build
