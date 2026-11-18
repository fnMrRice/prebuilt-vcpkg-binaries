#!/usr/bin/env bash
set -euo pipefail
root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
cd "$root"
configs=(manifests/*/vcpkg-configuration.json)
for config in "${configs[@]}"; do
  jq -e '."default-registry".kind == "builtin"' "$config" >/dev/null
done
previous=$(git -C vcpkg rev-parse HEAD)
git -C vcpkg fetch --depth=1 origin refs/heads/master
baseline=$(git -C vcpkg rev-parse FETCH_HEAD)
git -C vcpkg cat-file -e "$baseline:versions/baseline.json"
git -C vcpkg checkout --detach "$baseline"
for config in "${configs[@]}"; do
  updated=$(jq --arg baseline "$baseline" '."default-registry".baseline = $baseline' "$config")
  printf '%s\n' "$updated" > "$config"
done
printf 'vcpkg: %s -> %s\n' "$previous" "$baseline"
git diff --check
