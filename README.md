# OpenAPI spec for the Giant Swarm Control Plane API

This repository provides

- an OpenAPI [spec](/giantswarm/cp-api-spec/blob/master/pkg/spec/swagger.yaml) for the [Giant Swarm Control Plane API](https://docs.giantswarm.io/basics/api/#cp-k8s-api)
- the tooling to keep this spec up-to-date

## About the Control Plane API

The [Giant Swarm Control Plane API](https://docs.giantswarm.io/basics/api/#cp-k8s-api) is the Kubernetes API living in the control plane of a Giant Swarm installation. It is used to manage clusters and other resources.

The custom resources used in the Control Plane API are defined in the [giantswarm/apiextensions](https://github.com/giantswarm/apiextensions) repository. There is [reference documentation](https://docs.giantswarm.io/reference/cp-k8s-api/) for them in our docs.

## Tooling

To re-generate the spec in this repository based on a specific version of the `apiextensions` repo

1. Set the `APIEXTENSIONS_BRANCH` in the `Makefile` to either `master`, a tag, or a branch name.
2. Run `make generate`.
3. Find the updated spec in `pkg/spec/swagger.yaml`.
