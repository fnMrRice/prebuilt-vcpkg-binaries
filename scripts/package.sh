#!/usr/bin/env bash
set -euo pipefail
root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
profile=${1:?Build profile is required}
work=${2:?Work directory is required}
qt_version=${3:-qt5}
triplet=${4:-${profile%-latest}}
archive_name=$triplet
if [[ "$qt_version" != none ]]; then archive_name+="-with-$qt_version"; fi
destination="$root/artifacts/$profile/$qt_version"
mkdir -p "$destination"
case "$profile" in
  x64-windows*) extension=7z ;;
  x64-linux) extension=tar.xz; export XZ_OPT=${XZ_OPT:-'-T2 -3'} ;;
  *) echo "Unknown build profile: $profile" >&2; exit 2 ;;
esac
for directory in installed binary-cache; do
  output_name=$archive_name
  if [[ "$directory" == binary-cache ]]; then output_name+="-binary-cache"; fi
  case "$extension" in
    7z) (cd "$work" && 7z a -t7z -mx=5 -mmt=2 "$destination/$output_name.$extension" "$directory") ;;
    tar.xz) tar -cJf "$destination/$output_name.$extension" -C "$work" "$directory" ;;
  esac
done
cp "$root/README.md" "$destination/README.md"
cp -R "$root/scripts" "$destination/"
cp -R "$root/manifests" "$root/overlay-ports" "$root/triplets" "$destination/"
(cd "$destination" && sha256sum "$archive_name.$extension" "$archive_name-binary-cache.$extension" > SHA256SUMS)
printf 'Artifacts: %s\n' "$destination"
