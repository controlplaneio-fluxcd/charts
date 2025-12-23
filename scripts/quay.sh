#!/usr/bin/env bash

# Copyright 2025 Stefan Prodan.
# SPDX-License-Identifier: AGPL-3.0

set -euo pipefail

REPO="controlplaneio-fluxcd/flux-operator"
SOURCE_ORG="ghcr.io/controlplaneio-fluxcd/"
DST_ORG="quay.io/fluxoperatordev/"

info() {
    echo '[INFO] ' "$@"
}

fatal() {
    echo '[ERROR] ' "$@" >&2
    exit 1
}

# Check if gh is installed
if ! command -v gh &> /dev/null; then
    fatal "gh CLI is not installed. Install it from: https://cli.github.com/"
fi

# Check if crane is installed
if ! command -v crane &> /dev/null; then
    fatal "crane CLI is not installed. Install it with: go install github.com/google/go-containerregistry/cmd/crane@latest"
fi

# Check if flux is installed
if ! command -v flux &> /dev/null; then
    fatal "flux CLI is not installed. Install it from: https://fluxcd.io/flux/installation/"
fi

# Check if cosign is installed
if ! command -v cosign &> /dev/null; then
    fatal "cosign CLI is not installed. Install it from: https://docs.sigstore.dev/cosign/system_config/installation/"
fi

# Get the latest release version
info "Fetching latest release from ${REPO}"
VERSION=$(gh release view --repo "${REPO}" --json tagName -q '.tagName')

if [[ -z "${VERSION}" ]]; then
    fatal "Failed to fetch latest release version"
fi

# Validate version format
if [[ ! "${VERSION}" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    fatal "Invalid version format: ${VERSION}. Expected: v<major>.<minor>.<patch>"
fi

info "Syncing Flux Operator ${VERSION} from ${SOURCE_ORG} to ${DST_ORG}"

# Sync Flux Operator container images
FO_IMAGES=(
    "flux-operator:${VERSION}"
    "flux-operator:${VERSION}-ubi"
    "flux-operator-cli:${VERSION}"
    "flux-operator-mcp:${VERSION}"
    "flux-operator-manifests:${VERSION}"
)

for IMAGE in "${FO_IMAGES[@]}"; do
    info "Copying ${IMAGE}"
    crane copy --no-clobber "${SOURCE_ORG}${IMAGE}" "${DST_ORG}${IMAGE}" || true
    cosign copy --only=sig "${SOURCE_ORG}${IMAGE}" "${DST_ORG}${IMAGE}" || true
    info "Fetching digest for ${IMAGE}"
    crane digest "${DST_ORG}${IMAGE}"
done

# Chart version without 'v' prefix
CHART_VERSION="${VERSION#v}"

# Sync Helm charts
FO_CHARTS=(
    "charts/flux-operator:${CHART_VERSION}"
    "charts/flux-instance:${CHART_VERSION}"
    "charts/flux-operator-mcp:${CHART_VERSION}"
)

for CHART in "${FO_CHARTS[@]}"; do
    info "Copying ${CHART}"
    crane copy --no-clobber "${SOURCE_ORG}${CHART}" "${DST_ORG}${CHART}" || true
    cosign copy --only=sig "${SOURCE_ORG}${CHART}" "${DST_ORG}${CHART}" || true
    info "Fetching digest for ${CHART}"
    crane digest "${DST_ORG}${CHART}"
done

# Sync Flux controller images
info "Extracting Flux controller images"
FLUX_IMAGES=$(flux install --export --components-extra=image-reflector-controller,image-automation-controller,source-watcher | grep 'ghcr.io/' | awk '{print $2}')

for IMAGE in ${FLUX_IMAGES}; do
    IMAGE_NAME_TAG="${IMAGE#ghcr.io/fluxcd/}"
    info "Copying ${IMAGE_NAME_TAG}"
    crane copy --no-clobber "${IMAGE}" "${DST_ORG}${IMAGE_NAME_TAG}" || true
    cosign copy --only=sig "${IMAGE}" "${DST_ORG}${IMAGE_NAME_TAG}" || true
    info "Fetching digest for ${IMAGE_NAME_TAG}"
    crane digest "${DST_ORG}${IMAGE_NAME_TAG}"
done

info "Sync to ${DST_ORG} completed"
