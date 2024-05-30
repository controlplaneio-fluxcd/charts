#!/usr/bin/env bash

# Copyright 2024 Stefan Prodan.
# SPDX-License-Identifier: AGPL-3.0

set -euo pipefail

REPOSITORY_ROOT=$(git rev-parse --show-toplevel)
REGISTRY="ghcr.io/controlplaneio-fluxcd/charts"

for pkg in ${REPOSITORY_ROOT}/dist/*; do
  if [ -z "${pkg:-}" ]; then
    break
  fi
  helm push "${pkg}" oci://${REGISTRY}
done
