# ControlPlane Helm Charts

This repository contains the Helm charts for the ControlPlane Flux CD projects.

## Flux Charts

- [flux-operator](charts/flux-operator/README.md)
- [flux-instance](charts/flux-instance/README.md)
- [flux-operator-mcp](charts/flux-operator-mcp/README.md)

## Vendored Charts

- `ghcr.io/controlplaneio-fluxcd/charts/metrics-server`
- `ghcr.io/controlplaneio-fluxcd/charts/external-dns`
- `ghcr.io/controlplaneio-fluxcd/charts/ingress-nginx`

The vendored charts are [synced](.github/workflows/vendor.yaml) from
the upstream Kubernetes HTTP/S Helm repositories on a daily basis.
