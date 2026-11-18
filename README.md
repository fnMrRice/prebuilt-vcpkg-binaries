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

The prebuild workflow only enables `workflow_dispatch`. Pushes, pull requests,
releases, and schedules do not start builds. The default selection builds one target.
A run may take
several hours, especially when Qt and FFmpeg are not yet cached.

The workflow must be present on the repository's default branch for the manual
button to appear. Artifacts expire after 30 days. Completed binary packages are
cached even when a later port fails, so another manual run can reuse them.
Source archives and downloaded build tools are cached separately by OS and architecture.
Build trees and staging packages are cleaned; download archives are retained.
GitHub normally evicts caches after seven days without access, or when the
repository cache quota requires eviction. Artifact retention is independent.

## Monthly dependency updates

**Update vcpkg baseline** runs on the first day of every month at 09:17 Hong Kong
time (01:17 UTC), and can also be started manually from Actions. It checks out the
repository's default branch, advances the vcpkg submodule to the latest upstream
`master` commit, and sets both manifests' public default-registry baselines to the
same commit. Changes are committed directly to the default branch; an unchanged
baseline produces no commit.

The updater preserves the separate Windows 7 Boost registry baseline, explicit
package overrides, and all overlay source pins and patches. It does not compile
packages or start the prebuild workflow. No additional token secret is required;
the job uses `GITHUB_TOKEN` with `contents: write`. Branch protection must allow
this workflow to push to the default branch.

## Packages

The manifests cover graphics, audio/video codecs, networking, logging,
serialization, Boost, development tools, and Qt 5. The default manifest also
contains an opt-in Qt 6 feature; the workflow builds its default Qt 5 feature.
The Windows 7 manifest keeps its separate Boost baseline, ZeroMQ compatibility
overlay, and a Qt 5 FILE_ID_INFO declaration fix for MSVC Win7 targets. OpenSSL and FFmpeg are resolved from the official registry.

Additional public overlay ports are maintained in `overlay-ports/additional/`:

| Port | Upstream | Pinned source |
| --- | --- | --- |
| `gmssl` | [guanzhi/GmSSL](https://github.com/guanzhi/GmSSL) | `v3.2.0` |
| `ireader-avcodec` | [ireader/avcodec](https://github.com/ireader/avcodec) | `f5637e6dfec3291f5bd697c092da91586c4faba8` |
| `ireader-media-common` | [ireader/media-server](https://github.com/ireader/media-server) | `c0463893bc509e65bea9f4f76be68c1f89ccdfcf` |
| `ireader-sdk` | [ireader/sdk](https://github.com/ireader/sdk) | `e84a3d1a91cacdd8dedbbc931a2886b99bec4846` |
| `ireader-media-server` | [ireader/media-server](https://github.com/ireader/media-server) | `c0463893bc509e65bea9f4f76be68c1f89ccdfcf` |

Downloads are checked with SHA512. GmSSL includes a packaging patch for CMake
exports and installation paths. Its upstream tests are excluded from the binary
package. The ireader ports supply CMake integration and export installed include
paths. The media-server dependency enables MPEG support without default features.
The SDK overlay also enables the Linux platform branch and adapts its HTTP poll
callback to the upstream callback signature. Source licenses are included in each installed package's `share/<port>/copyright`.

### ireader modules

| Port | Components/features |
| --- | --- |
| `ireader-sdk` | Core `sdk`, optional `aio`, `http`, `ice` |
| `ireader-avcodec` | `h264`, `h265`, `avcodec`, `avbsf` |
| `ireader-media-server` | `dash`, `flv`, `hls`, `mkv`, `mov`, `mpeg`, `rtmp`, `rtp`, `rtsp`, `sip` |
| `ireader-media-common` | Shared FLV library and codec metadata |

Feature dependencies automatically enable required modules. The shared port avoids
an upstream AVBSF/RTSP dependency cycle while retaining `ireader::media-server::flv`.
`ireader-avcodec` includes the four portable libraries built by the upstream
root Makefile. External encoder backends and the separate `avplayer`, `ffutils`,
and platform renderer projects are not enabled implicitly. The codec archive is
named `ireader-avcodec` to coexist with FFmpeg's `avcodec` archive.

Installed targets propagate their include directories, platform definitions,
system libraries, and package dependencies. Required CMake components are checked:

```cmake
find_package(ireader-sdk CONFIG REQUIRED COMPONENTS aio http)
find_package(ireader-media-server CONFIG REQUIRED COMPONENTS rtsp mkv)
target_link_libraries(app PRIVATE ireader::sdk::http ireader::media-server::rtsp)
```

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
The build script exports `VCPKG_FEATURE_FLAGS=-compilertracking` for all profiles,
including host dependencies. Compiler executable hashes are excluded from package
ABIs. Packages built with different compiler versions can therefore be reused;
the consumer must use a compiler compatible with those binaries.

When consuming the binary cache, use the same setting:

```sh
export VCPKG_FEATURE_FLAGS=-compilertracking
```

In PowerShell, use `$env:VCPKG_FEATURE_FLAGS = '-compilertracking'`.
For CMake manifest integration, set this environment variable before configuring.

Binary-cache restoration still requires matching port contents, features, triplet,
helper scripts, tool versions, and dependency ABIs. Use the same pinned submodule,
manifests, and overlays. For v142, pass `--overlay-triplets=/path/to/triplets` and
use the `x64-windows-v142` target and host triplets. Switching compiler tracking
off changes package ABIs, so packages cached with tracking enabled normally need
one rebuild. Updating vcpkg ports, scripts, or ABI calculation rules can also
invalidate packages independently of compiler tracking.

The build log records how many binary-cache archives were present before install.
vcpkg then reports how many packages it restored; restoring a GitHub Actions cache
archive alone does not guarantee that its package ABIs match.

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
