.PHONY: openapi-spec
openapi-spec: build-model-gen
	@echo "Generating OpenAPI spec"
	spec-gen/spec-gen
	cp swagger.yaml spec/swagger.yaml
	rm -rf swagger.yaml

build-model-gen: spec-gen/go.mod
	@echo "Building OpenAPI spec generator"
	@cd spec-gen \
	&& go build
