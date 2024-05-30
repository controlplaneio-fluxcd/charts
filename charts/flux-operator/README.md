# flux-operator

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: v0.1.0](https://img.shields.io/badge/AppVersion-v0.1.0-informational?style=flat-square)

A Helm chart for installing the Flux Operator.
The operator provides a declarative API for the installation and upgrade of the Flux distribution
and automates the patching for hotfixes and CVEs affecting the Flux controllers container images.

## Prerequisites

- Kubernetes 1.22+
- Helm 3.8.0+

## Installing the Chart

To install the chart with the release name `flux-operator`:

```console
helm install flux-operator oci://ghcr.io/controlplaneio-fluxcd/charts/flux-operator \
  --namespace flux-system \
  --create-namespace \
  --wait
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{"nodeAffinity":{"requiredDuringSchedulingIgnoredDuringExecution":{"nodeSelectorTerms":[{"matchExpressions":[{"key":"kubernetes.io/os","operator":"In","values":["linux"]}]}]}}}` | Pod affinity and anti-affinity settings. |
| commonAnnotations | object | `{}` | Common annotations to add to all deployed objects. |
| commonLabels | object | `{}` | Common labels to add to all deployed objects. |
| fullnameOverride | string | `""` |  |
| image | object | `{"pullSecrets":[],"repository":"ghcr.io/controlplaneio-fluxcd/flux-operator","tag":""}` | Container image settings. The image tag defaults to the chart appVersion. |
| installCRDs | bool | `true` | Install and upgrade the Flux Operator CRDs. |
| nameOverride | string | `""` |  |
| podSecurityContext | object | `{}` | Pod Security Context settings. |
| resources | object | `{"limits":{"cpu":"1000m","memory":"1Gi"},"requests":{"cpu":"100m","memory":"64Mi"}}` | Container resources requests and limits settings. |
| securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":true}` | Container Security Context settings. |
| tolerations | list | `[]` | Pod tolerations settings. |

## Source Code

* <https://github.com/controlplaneio-fluxcd/flux-operator>
* <https://github.com/controlplaneio-fluxcd/charts>
