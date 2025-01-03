#!/usr/bin/env bash

# Copyright 2024 Stefan Prodan.
# SPDX-License-Identifier: AGPL-3.0

set -euo pipefail

REPOSITORY_ROOT=$(git rev-parse --show-toplevel)
REGISTRY="ghcr.io/controlplaneio-fluxcd/charts"

for chartDir in ${REPOSITORY_ROOT}/charts/*; do
  if [ -z "${chartDir:-}" ]; then
    break
  fi
  chart=$(basename ${chartDir})
  mkdir -p ${REPOSITORY_ROOT}/dist/${chart}
  helm package ${chartDir} -d ${REPOSITORY_ROOT}/dist/${chart}
done
