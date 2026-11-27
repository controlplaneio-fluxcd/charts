#!/usr/bin/env bash

# Copyright 2024 Stefan Prodan.
# SPDX-License-Identifier: AGPL-3.0

set -euo pipefail

REPOSITORY_ROOT=$(git rev-parse --show-toplevel)
REGISTRY="ghcr.io/controlplaneio-fluxcd/charts"

info() {
    echo '[INFO] ' "$@"
}

info "Running helm lint for all charts"
helm lint ${REPOSITORY_ROOT}/charts/*

for pkg in ${REPOSITORY_ROOT}/charts/*; do
  if [ -z "${pkg:-}" ]; then
    break
  fi
  chartName=${pkg##*/}
  info "Running helm template and flux-schema for ${chartName}"
  helm template ${chartName} --include-crds ${pkg} | flux-schema validate --verbose

  # Values files under <chart>/ci/ must render and validate, except
  # *.fail.yaml files which must fail with the text of their first line:
  # '# fail: <substring>'.
  for values in ${pkg}/ci/*.yaml; do
    [ -e "${values}" ] || continue
    caseName=${values##*/}
    if [[ "${caseName}" == *.fail.yaml ]]; then
      info "Running helm template expecting a failure for ${chartName} with ${caseName}"
      expected=$(head -n 1 "${values}" | sed -n 's/^# fail: //p')
      if [ -z "${expected}" ]; then
        echo "${values}: the first line must be '# fail: <substring>'" >&2
        exit 1
      fi
      if output=$(helm template ${chartName} ${pkg} -f "${values}" 2>&1); then
        echo "${values}: helm template succeeded, expected a failure" >&2
        exit 1
      fi
      if ! grep -qF -- "${expected}" <<< "${output}"; then
        echo "${values}: helm template failed without '${expected}':" >&2
        echo "${output}" >&2
        exit 1
      fi
    else
      info "Running helm template and flux-schema for ${chartName} with ${caseName}"
      helm template ${chartName} --include-crds ${pkg} -f "${values}" | flux-schema validate --verbose --schema-location default --schema-location ecosystem
    fi
  done
done
