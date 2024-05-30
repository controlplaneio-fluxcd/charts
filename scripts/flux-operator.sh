#!/usr/bin/env bash

# Copyright 2024 Stefan Prodan.
# SPDX-License-Identifier: AGPL-3.0

set -euo pipefail

REPOSITORY_ROOT=$(git rev-parse --show-toplevel)
CHART_DIR="${REPOSITORY_ROOT}/charts/flux-operator"
CRD_URL="https://github.com/controlplaneio-fluxcd/flux-operator/config/crd"
VERSION=$(gh release view --repo controlplaneio-fluxcd/flux-operator --json tagName -q '.tagName')

info() {
    echo '[INFO] ' "$@"
}

fatal() {
    echo '[ERROR] ' "$@" >&2
    exit 1
}

TEMPDIR=$(mktemp -d tmp.generate.XXXXX)

delete_temp_dir() {
    if [ -d "${TEMPDIR}" ]; then
        rm -r "${TEMPDIR}"
    fi
}
trap delete_temp_dir EXIT

cat <<EOF > "${TEMPDIR}/labels.yaml"
apiVersion: builtin
kind: LabelTransformer
metadata:
  name: labels
labels:
  app.kubernetes.io/name: "{{ .Chart.Name }}"
  app.kubernetes.io/instance: "{{ .Release.Name }}"
  app.kubernetes.io/managed-by: "{{ .Release.Service }}"
  app.kubernetes.io/version: "{{ .Chart.AppVersion }}"
  helm.sh/chart: "{{ .Chart.Name }}-{{ .Chart.Version | replace \"+\" \"_\" }}"
fieldSpecs:
- path: metadata/labels
  create: true
EOF

cat <<EOF > "${TEMPDIR}/annotations.yaml"
apiVersion: builtin
kind: AnnotationsTransformer
metadata:
  name: annotations
annotations:
  helm.sh/resource-policy: keep
fieldSpecs:
- path: metadata/annotations
  create: true
EOF

cat <<EOF > "${TEMPDIR}/kustomization.yaml"
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
- ${CRD_URL}?ref=${VERSION}
transformers:
- labels.yaml
- annotations.yaml
EOF

# Generate CRDs
echo "{{- if and .Values.installCRDs }}" > "${CHART_DIR}/templates/crds.yaml"
kubectl kustomize "${TEMPDIR}" >> "${CHART_DIR}/templates/crds.yaml"
echo "{{- end }}" >> "${CHART_DIR}/templates/crds.yaml"

info "CRDs generated for Flux Operator ${VERSION}"

# Patch app version
export APP_VERSION=${VERSION}
yq eval '.appVersion=env(APP_VERSION)' -i "${CHART_DIR}/Chart.yaml"
export CHART_VERSION=${VERSION#v}
yq eval '.version=env(CHART_VERSION)' -i "${CHART_DIR}/Chart.yaml"

info "Chart.yaml updated to version ${CHART_VERSION}"
