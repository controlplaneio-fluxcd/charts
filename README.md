# Flux Operator Helm Charts

This repository contains the Helm charts for [Flux Operator](https://fluxoperator.dev) and its components.

## Flux Charts

- [flux-operator](charts/flux-operator/README.md)
- [flux-instance](charts/flux-instance/README.md)
- [flux-operator-mcp](charts/flux-operator-mcp/README.md)

The charts are signed with `cosign` and published
as OCI artifacts to the following registries:

- `ghcr.io/controlplaneio-fluxcd/charts`
- `quay.io/fluxoperator/charts`

## Vendored Charts

- `ghcr.io/controlplaneio-fluxcd/charts/metrics-server`
- `ghcr.io/controlplaneio-fluxcd/charts/external-dns`
- `ghcr.io/controlplaneio-fluxcd/charts/ingress-nginx`
- `ghcr.io/controlplaneio-fluxcd/charts/dex`

The vendored charts are [synced](.github/workflows/vendor.yaml) from
the upstream HTTP/S Helm repositories on a daily basis.

## Contributing

We welcome contributions to the Flux Operator project via GitHub pull requests.
Please see the [CONTRIBUTING](CONTRIBUTING.md)
guide for details on how to set up your development environment and start contributing to the project.

## License

The Flux Operator and its Helm charts are open-source licensed under the
[AGPL-3.0 license](https://github.com/controlplaneio-fluxcd/flux-operator/blob/main/LICENSE).
