# Prebuilt vcpkg binaries

Manually build reusable public C/C++ dependencies with a pinned vcpkg submodule.
All source downloads use public upstream locations. No private registry or SSH key is required.

## Build targets

| Workflow target | Runner | Target triplet | Host triplet | Compiler | Manifest |
| --- | --- | --- | --- | --- | --- |
| `x64-windows-latest` | `windows-latest` | `x64-windows` | `x64-windows` | Default MSVC in the image | Default |
| `x64-windows-v142` | `windows-2022` | `x64-windows-v142` | `x64-windows-v142` | MSVC v142 | Windows 7 |
| `x64-windows-static` | `windows-latest` | `x64-windows-static` | `x64-windows` | Default MSVC in the image | Default |
| `x64-linux` | `ubuntu-24.04` | `x64-linux` | `x64-linux` | Default GCC in the image | Default |

Windows jobs reuse preinstalled MSVC through `microsoft/setup-msbuild` and
`scripts/msvc-env.ps1`, which calls `vcvarsall.bat`; neither installs compilers. The v142 profile
uses `triplets/x64-windows-v142.cmake` to pin MSVC v142 and Windows 7 API flags.
Other profiles use vcpkg's built-in triplets without overrides.
Release and Debug libraries are built. The static Windows target requests static
libraries and the static MSVC CRT; individual ports can enforce their own linkage.
`latest` follows the toolset installed in the selected runner image rather than
pinning a compiler version. Linux packages target the runner's glibc environment.
The Windows 7 manifest and compiler flags do not replace runtime compatibility testing.

## Run manually

1. Open **Actions → Prebuild public dependencies → Run workflow**.
2. Select a target, or `all` to build all four targets.
3. Download the `prebuilt-<target>-<run id>` artifact after the job succeeds.

Only `workflow_dispatch` is enabled. Pushes, pull requests, releases, and schedules
do not start builds. The default selection builds one target. A run may take
several hours, especially when Qt and FFmpeg are not yet cached.

The workflow must be present on the repository's default branch for the manual
button to appear. Artifacts expire after 30 days. Completed binary packages are
cached even when a later port fails, so another manual run can reuse them.
Source archives and downloaded build tools are cached separately by OS and architecture.
Build trees and staging packages are cleaned; download archives are retained.
GitHub normally evicts caches after seven days without access, or when the
repository cache quota requires eviction. Artifact retention is independent.

## Packages

The manifests cover graphics, audio/video codecs, networking, logging,
serialization, Boost, development tools, and Qt 5. The default manifest also
contains an opt-in Qt 6 feature; the workflow builds its default Qt 5 feature.
The Windows 7 manifest keeps its separate Boost baseline and ZeroMQ compatibility
overlay. OpenSSL and FFmpeg are resolved from the official registry.

Additional public overlay ports are maintained in `overlay-ports/additional/`:

| Port | Upstream | Pinned source |
| --- | --- | --- |
| `gmssl` | [guanzhi/GmSSL](https://github.com/guanzhi/GmSSL) | `v3.2.0` |
| `ireader-sdk` | [ireader/sdk](https://github.com/ireader/sdk) | `e84a3d1a91cacdd8dedbbc931a2886b99bec4846` |
| `ireader-media-server` | [ireader/media-server](https://github.com/ireader/media-server) | `c0463893bc509e65bea9f4f76be68c1f89ccdfcf` |

Downloads are checked with SHA512. GmSSL includes a packaging patch for CMake
exports and installation paths. Its upstream tests are excluded from the binary
package. The ireader ports supply CMake integration and export installed include
paths. The media-server dependency enables MPEG support without default features.
The SDK overlay also enables the Linux platform branch and adapts its HTTP poll
callback to the upstream callback signature. Source licenses are included in each installed package's `share/<port>/copyright`.

## Use the output

Each artifact includes:

- `installed.7z` (Windows) / `installed.tar.xz` (Linux): the vcpkg installation tree, including headers, libraries,
  tools, CMake package files, and license files.
- `binary-cache.7z` (Windows) / `binary-cache.tar.xz` (Linux): ABI-keyed vcpkg binary packages for reuse.
- `SHA256SUMS`, `packages.txt`, `build-info.txt`, and the build log.
- The manifests and overlay files used by the build.

Extract the installed archive and configure a consumer with the matching triplet:

```sh
# Linux: tar -xJf installed.tar.xz
# Windows: 7z x installed.7z
cmake -S . -B build \
  -DCMAKE_TOOLCHAIN_FILE=/path/to/vcpkg/scripts/buildsystems/vcpkg.cmake \
  -DVCPKG_INSTALLED_DIR=/absolute/path/to/installed \
  -DVCPKG_TARGET_TRIPLET=x64-windows \
  -DVCPKG_MANIFEST_INSTALL=OFF
```

Alternatively, extract the binary-cache archive and set an absolute cache path:

```sh
# Linux: tar -xJf binary-cache.tar.xz
# Windows: 7z x binary-cache.7z
export VCPKG_BINARY_SOURCES='clear;files,/absolute/path/to/binary-cache,read'
```

In PowerShell, use `$env:VCPKG_BINARY_SOURCES = 'clear;files,C:/path/to/binary-cache,read'`.
Binary-cache restoration requires matching port contents, features, triplet,
compiler, and other ABI inputs. Use the same pinned submodule, manifests, and
overlays. For v142, pass `--overlay-triplets=/path/to/triplets` and use the
`x64-windows-v142` target and host triplets.
A different local compiler can cause vcpkg to rebuild packages.

## Local builds

```sh
git clone --recurse-submodules https://github.com/fnMrRice/prebuilt-vcpkg-binaries.git
cd prebuilt-vcpkg-binaries
# Windows: .\vcpkg\bootstrap-vcpkg.bat -disableMetrics
# Linux:
./vcpkg/bootstrap-vcpkg.sh -disableMetrics
bash scripts/build.sh x64-linux
```

On Windows, run the shell scripts with Git Bash after bootstrapping vcpkg.
Linux prerequisites for Ubuntu are listed in `scripts/linux-prerequisites.sh`.
Generated files stay in `.work/` and `artifacts/`.
