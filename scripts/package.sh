#!/usr/bin/env bash
set -euo pipefail
root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
profile=${1:?Build profile is required}
work=${2:?Work directory is required}
destination="$root/artifacts/$profile"
mkdir -p "$destination"
case "$profile" in
  x64-windows*)
    extension=7z
    for directory in installed binary-cache; do
      (cd "$work" && 7z a -t7z -mx=5 -mmt=2 "$destination/$directory.$extension" "$directory")
    done
    ;;
  x64-linux)
    extension=tar.xz
    export XZ_OPT=${XZ_OPT:-'-T2 -3'}
    for directory in installed binary-cache; do
      tar -cJf "$destination/$directory.$extension" -C "$work" "$directory"
    done
    ;;
  *) echo "Unknown build profile: $profile" >&2; exit 2 ;;
esac
cp "$root/README.md" "$destination/README.md"
cp -R "$root/scripts" "$destination/"
cp -R "$root/manifests" "$root/overlay-ports" "$root/triplets" "$destination/"
(cd "$destination" && sha256sum "installed.$extension" "binary-cache.$extension" > SHA256SUMS)
printf 'Artifacts: %s\n' "$destination"
