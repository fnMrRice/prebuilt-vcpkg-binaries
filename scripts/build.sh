#!/usr/bin/env bash
set -euo pipefail
root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
profile=${1:-x64-windows-latest}
case "$profile" in
  x64-windows-latest) triplet=x64-windows; host=x64-windows; manifest=default ;;
  x64-windows-v142) triplet=x64-windows-v142; host=x64-windows-v142; manifest=win7 ;;
  x64-windows-static) triplet=x64-windows-static; host=x64-windows; manifest=default ;;
  x64-linux) triplet=x64-linux; host=x64-linux; manifest=default ;;
  *) echo "Unknown build profile: $profile" >&2; exit 2 ;;
esac
native_path() {
  if command -v cygpath >/dev/null 2>&1; then cygpath -m "$1"; else printf '%s\n' "$1"; fi
}
work=${PREBUILT_WORK_DIR:-$root/.work/$profile}
mkdir -p "$work/binary-cache" "$work/installed" "$work/downloads" "$root/artifacts/$profile"
export VCPKG_ROOT=$(native_path "$root/vcpkg")
export VCPKG_DOWNLOADS=$(native_path "$work/downloads")
export VCPKG_BINARY_SOURCES="clear;files,$(native_path "$work/binary-cache"),readwrite"
export VCPKG_DISABLE_METRICS=1
export VCPKG_MAX_CONCURRENCY=${VCPKG_MAX_CONCURRENCY:-2}
vcpkg="$root/vcpkg/vcpkg"
if [[ "$triplet" == *windows* ]]; then vcpkg="$vcpkg.exe"; fi
if [[ ! -s "$vcpkg" ]]; then echo 'Bootstrap the vcpkg submodule before building.' >&2; exit 2; fi
args=(install "--triplet=$triplet" "--host-triplet=$host"
      "--x-manifest-root=$(native_path "$root/manifests/$manifest")"
      "--x-install-root=$(native_path "$work/installed")" --clean-buildtrees-after-build --clean-packages-after-build)
if [[ "$profile" == x64-windows-v142 ]]; then
  args+=("--overlay-triplets=$(native_path "$root/triplets")")
fi
printf 'Building %s with target %s and host %s\n' "$profile" "$triplet" "$host"
"$vcpkg" "${args[@]}" 2>&1 | tee "$root/artifacts/$profile/build.log"
"$vcpkg" list "--x-install-root=$(native_path "$work/installed")" > "$root/artifacts/$profile/packages.txt"
{
  printf 'Profile: %s\nTriplet: %s\nHost triplet: %s\n' "$profile" "$triplet" "$host"
  printf 'Repository commit: %s\n' "$(git -C "$root" rev-parse HEAD)"
  printf 'vcpkg commit: %s\n' "$(git -C "$root/vcpkg" rev-parse HEAD)"
  "$vcpkg" version
  cmake --version | head -n 1
} > "$root/artifacts/$profile/build-info.txt"
bash "$root/scripts/package.sh" "$profile" "$work"
