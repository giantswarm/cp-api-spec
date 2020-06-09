all: generate

.PHONY: generate
generate:
	@$(MAKE) openapi-spec

.PHONY: openapi-spec
openapi-spec: build-spec-gen
	@echo "Generating OpenAPI spec"
	spec-gen/spec-gen
	cp swagger.yaml spec/swagger.yaml
	rm -rf swagger.yaml

build-spec-gen: spec-gen/go.mod
	@echo "Building OpenAPI spec generator"
	@cd spec-gen \
	&& go build
