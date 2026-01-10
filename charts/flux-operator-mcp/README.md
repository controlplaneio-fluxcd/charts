# flux-operator-mcp

![Version: 0.38.1](https://img.shields.io/badge/Version-0.38.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: v0.38.1](https://img.shields.io/badge/AppVersion-v0.38.1-informational?style=flat-square)

The [Flux MCP Server](https://github.com/controlplaneio-fluxcd/flux-operator/tree/main/cmd/mcp)
connects AI assistants to Kubernetes clusters running Flux Operator, enabling seamless interaction
through natural language. It serves as a bridge between AI tools and GitOps pipelines,
allowing you to analyze deployment across environments, troubleshoot issues,
and perform operations using conversational prompts.

## Prerequisites

- Kubernetes 1.30+
- Helm 3.8+

## Installing the Chart

To install the MCP Server in the `flux-system` namespace:

```console
helm install flux-operator-mcp oci://ghcr.io/controlplaneio-fluxcd/charts/flux-operator-mcp \
  --namespace flux-system \
  --wait
```

To allow MCP clients to connect to the server from other namespaces:

```console
helm install flux-operator-mcp oci://ghcr.io/controlplaneio-fluxcd/charts/flux-operator-mcp \
  --set networkPolicy.ingress.namespaces[0]=some-namespace \
  --set networkPolicy.ingress.namespaces[1]=other-namespace \
  --namespace flux-system
```

## Connecting to the MCP Server

To connect to the server, start port forwarding with:

```shell
kubectl port-forward -n flux-system svc/flux-operator-mcp 9090:9090
```

Add the following configuration to your AI assistant to connect to the MCP Server:

```json
{
  "mcp": {
    "servers": {
      "flux-operator-mcp": {
        "type": "sse",
        "url": "http://localhost:9090/sse"
      }
    }
  }
}
```

For the streamable HTTP transport, set the Helm value `transport` to `http`
(defaults to `sse`) and use the following AI assistant configuration:

```json
{
  "mcp": {
    "servers": {
      "flux-operator-mcp": {
        "type": "http",
        "url": "http://localhost:9090/mcp"
      }
    }
  }
}
```

For more information, please refer to the [Flux MCP Server documentation](https://fluxoperator.dev/docs/mcp/install/).

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{"nodeAffinity":{"requiredDuringSchedulingIgnoredDuringExecution":{"nodeSelectorTerms":[{"matchExpressions":[{"key":"kubernetes.io/os","operator":"In","values":["linux"]}]}]}}}` | Pod affinity and anti-affinity settings. |
| apiPriority | object | `{"enabled":false,"level":"workload-high"}` | Kubernetes [API priority and fairness](https://kubernetes.io/docs/concepts/cluster-administration/flow-control/) settings. |
| commonAnnotations | object | `{}` | Common annotations to add to all deployed objects including pods. |
| commonLabels | object | `{}` | Common labels to add to all deployed objects including pods. |
| extraArgs | list | `[]` | Container extra arguments. |
| extraEnvs | list | `[]` | Container extra environment variables. |
| fullnameOverride | string | `""` |  |
| httpRoute | object | `{"annotations":{},"enabled":false,"hostnames":[],"parentRefs":[]}` | Gateway API HTTPRoute settings. |
| image | object | `{"imagePullPolicy":"IfNotPresent","pullSecrets":[],"repository":"ghcr.io/controlplaneio-fluxcd/flux-operator-mcp","tag":""}` | Container image settings. The image tag defaults to the chart appVersion. |
| ingress | object | `{"annotations":{},"className":"","enabled":false,"hosts":[],"tls":[]}` | Ingress settings. |
| livenessProbe | object | `{"tcpSocket":{"port":"http"}}` | Container liveness probe settings. |
| nameOverride | string | `""` |  |
| networkPolicy | object | `{"create":true,"ingress":{"namespaces":[]}}` | Network policy settings. |
| nodeSelector | object | `{}` | Pod Node Selector settings. |
| podSecurityContext | object | `{}` | Pod security context settings. |
| priorityClassName | string | `""` | Pod priority class name. |
| rbac.create | bool | `true` | Grant the cluster-admin role to the flux-operator-mcp service account |
| readinessProbe | object | `{"tcpSocket":{"port":"http"}}` | Container readiness probe settings. |
| readonly | bool | `false` | Run the server in readonly mode by disabling the MCP tools that can modify the cluster state. |
| resources | object | `{"limits":{"cpu":"1000m","memory":"1Gi"},"requests":{"cpu":"10m","memory":"64Mi"}}` | Container resources requests and limits settings. |
| securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":true,"runAsNonRoot":true,"seccompProfile":{"type":"RuntimeDefault"}}` | Container security context settings. The default is compliant with the pod security restricted profile. |
| serviceAccount | object | `{"automount":true,"create":true,"name":""}` | Pod service account settings. The name of the service account defaults to the release name. |
| tolerations | list | `[]` | Pod tolerations settings. |
| transport | string | `"sse"` | MCP server transport. Either 'sse' for server-sent events, or 'http' for streamable HTTP. |

## Source Code

* <https://github.com/controlplaneio-fluxcd/flux-operator>
* <https://github.com/controlplaneio-fluxcd/charts>
