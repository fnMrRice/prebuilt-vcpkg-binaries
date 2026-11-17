#!/usr/bin/env bash
set -euo pipefail
root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
profile=${1:?Build profile is required}
work=${2:?Work directory is required}
destination="$root/artifacts/$profile"
mkdir -p "$destination"
# Preserve Linux executable permissions and symlinks inside the tar archive.
tar -czf "$destination/installed.tar.gz" -C "$work" installed
tar -czf "$destination/binary-cache.tar.gz" -C "$work" binary-cache
cp "$root/README.md" "$destination/README.md"
cp -R "$root/scripts" "$destination/"
cp -R "$root/manifests" "$root/overlay-ports" "$root/triplets" "$destination/"
(cd "$destination" && sha256sum installed.tar.gz binary-cache.tar.gz > SHA256SUMS)
printf 'Artifacts: %s\n' "$destination"
