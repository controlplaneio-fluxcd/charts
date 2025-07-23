#!/usr/bin/env bash

# Copyright 2024 Stefan Prodan.
# SPDX-License-Identifier: AGPL-3.0

set -euo pipefail

REPOSITORY_ROOT=$(git rev-parse --show-toplevel)
REGISTRY="ghcr.io/controlplaneio-fluxcd/charts"

info() {
    echo '[INFO] ' "$@"
}

info "Generating README files"
helm-docs --chart-search-root=${REPOSITORY_ROOT}/charts --template-files=helmdocs.gotmpl
mkdir -p bin

for pkg in ${REPOSITORY_ROOT}/charts/*; do
  if [ -z "${pkg:-}" ]; then
    break
  fi
  info "Generating JSON schema for ${pkg}"
  helm schema -f ${pkg}/values.yaml -o ${pkg}/values.schema.json --draft 2019 2> ./bin/helm-schema.log
  cat ./bin/helm-schema.log
  if grep -q "Error" ./bin/helm-schema.log; then
    exit 1
  fi
done
