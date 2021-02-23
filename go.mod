module github.com/giantswarm/cp-api-spec

go 1.16

require (
	github.com/giantswarm/apiextensions v0.4.13 // indirect
	github.com/giantswarm/apiextensions/v3 v3.19.0
	github.com/giantswarm/microerror v0.3.0
	github.com/go-openapi/spec v0.20.3
	k8s.io/apimachinery v0.18.9
	k8s.io/apiserver v0.18.9
	k8s.io/kube-openapi v0.0.0-20200410145947-61e04a5be9a6
	sigs.k8s.io/yaml v1.2.0
)

replace (
	sigs.k8s.io/cluster-api v0.3.13 => github.com/giantswarm/cluster-api v0.3.13-gs
	sigs.k8s.io/cluster-api-provider-azure v0.4.11 => github.com/giantswarm/cluster-api-provider-azure v0.4.12-gsalpha3
	sigs.k8s.io/structured-merge-diff => sigs.k8s.io/structured-merge-diff v1.0.1
)
