#!/usr/bin/env bash
set -o errexit
set -o nounset

ROOT="${GITHUB_WORKSPACE}"
CHART_NAME="oca-repository"

VERSION_APP_PATH="./VERSION_APP"
VERSION_CHART_PATH="./VERSION_CHART"

make_version() {
  GIT_SHA=$(git log -1 --pretty=%H)
  SHORT_SHA=$(echo "$GIT_SHA" | cut -c1-8)

  VERSION_BASE_HASH=$(git log --follow -1 --pretty=%H VERSION)
  VERSION_BASE=$(cat VERSION)
  GIT_COUNT=$(git rev-list --count "$VERSION_BASE_HASH"..HEAD)

  BRANCH=${GITHUB_HEAD_REF:-${GITHUB_REF##*/}}  # branch name or tag

  # Format chart version like: 0.1.0+dev35-main-db1a9cc1
  VERSION_CHART="${VERSION_BASE}+dev${GIT_COUNT}-${BRANCH}-${SHORT_SHA}"

  echo -n "${VERSION_BASE}" > "${VERSION_APP_PATH}"   # app version stays base
  echo -n "${VERSION_CHART}" > "${VERSION_CHART_PATH}"
}

patch_chart_yaml() {
  CHART_PATH="./server/charts/${CHART_NAME}"
  VERSION_CHART=$(cat "${VERSION_CHART_PATH}")

  # Update only Chart.yaml (not values.yaml!)
  sed -i "s#^version:.*#version: ${VERSION_CHART}#" "${CHART_PATH}/Chart.yaml"
  sed -i "s#^appVersion:.*#appVersion: \"${VERSION_CHART}\"#" "${CHART_PATH}/Chart.yaml"
}

main() {
  cd "$ROOT"
  make_version
  patch_chart_yaml
}

main "$@"
