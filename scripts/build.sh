#!/usr/bin/env bash
set -euo pipefail
root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
profile=${1:-x64-windows-latest}
qt_version=${2:-qt5}
case "$profile" in
  x64-windows-latest) triplet=x64-windows; host=x64-windows; manifest=default ;;
  x64-windows-v142) triplet=x64-windows-v142; host=x64-windows-v142; manifest=win7 ;;
  x64-windows-static) triplet=x64-windows-static; host=x64-windows; manifest=default ;;
  x64-windows-static-release) triplet=x64-windows-static-release; host=x64-windows; manifest=default ;;
  x64-linux) triplet=x64-linux; host=x64-linux; manifest=default ;;
  *) echo "Unknown build profile: $profile" >&2; exit 2 ;;
esac
case "$qt_version" in
  none|qt5) ;;
  qt6)
    if [[ "$profile" == x64-windows-v142 ]]; then
      echo 'Qt 6 is not supported by the Windows 7/v142 profile.' >&2
      exit 2
    fi
    manifest=qt6
    ;;
  *) echo "Unknown Qt version: $qt_version" >&2; exit 2 ;;
esac
native_path() {
  if command -v cygpath >/dev/null 2>&1; then cygpath -m "$1"; else printf '%s\n' "$1"; fi
}
work=${PREBUILT_WORK_DIR:-$root/.work/$profile/$qt_version}
destination="$root/artifacts/$profile/$qt_version"
mkdir -p "$work/binary-cache" "$work/installed" "$work/downloads" "$destination"
export VCPKG_ROOT=$(native_path "$root/vcpkg")
export VCPKG_DOWNLOADS=$(native_path "$work/downloads")
export VCPKG_BINARY_SOURCES="clear;files,$(native_path "$work/binary-cache"),readwrite"
# Keep compiler updates from invalidating otherwise matching binary packages.
export VCPKG_FEATURE_FLAGS=-compilertracking
export VCPKG_DISABLE_METRICS=1
export VCPKG_MAX_CONCURRENCY=${VCPKG_MAX_CONCURRENCY:-2}
vcpkg="$root/vcpkg/vcpkg"
if [[ "$triplet" == *windows* ]]; then vcpkg="$vcpkg.exe"; fi
if [[ ! -s "$vcpkg" ]]; then echo 'Bootstrap the vcpkg submodule before building.' >&2; exit 2; fi
args=(install "--triplet=$triplet" "--host-triplet=$host"
      "--x-manifest-root=$(native_path "$root/manifests/$manifest")"
      "--x-install-root=$(native_path "$work/installed")" --x-no-default-features --clean-buildtrees-after-build --clean-packages-after-build)
if [[ "$qt_version" != none ]]; then
  args+=("--x-feature=$qt_version")
fi
if [[ "$profile" == x64-windows-v142 ]]; then
  args+=("--overlay-triplets=$(native_path "$root/triplets")")
fi
printf 'Building %s (%s) with target %s and host %s\n' "$profile" "$qt_version" "$triplet" "$host"
{
  printf 'Compiler tracking: disabled (VCPKG_FEATURE_FLAGS=%s)\n' "$VCPKG_FEATURE_FLAGS"
  printf 'Binary cache archives available before install: %s\n' "$(find "$work/binary-cache" -type f -name '*.zip' | wc -l | tr -d '[:space:]')"
  "$vcpkg" "${args[@]}"
} 2>&1 | tee "$destination/build.log"
"$vcpkg" list "--x-install-root=$(native_path "$work/installed")" > "$destination/packages.txt"
{
  printf 'Profile: %s\nQt version: %s\nManifest: %s\nTriplet: %s\nHost triplet: %s\n' "$profile" "$qt_version" "$manifest" "$triplet" "$host"
  printf 'Repository commit: %s\n' "$(git -C "$root" rev-parse HEAD)"
  printf 'vcpkg commit: %s\n' "$(git -C "$root/vcpkg" rev-parse HEAD)"
  printf 'Compiler tracking: disabled\n'
  "$vcpkg" version
  cmake --version | head -n 1
} > "$destination/build-info.txt"
bash "$root/scripts/package.sh" "$profile" "$work" "$qt_version" "$triplet"
