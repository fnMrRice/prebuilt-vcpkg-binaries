vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO guanzhi/GmSSL
    REF "v${VERSION}"
    SHA512 350a744626162cd0994b8369155f4d8f2a6cea0f002464384b1972e49321ea1c6c74834d561f874147fdf942784430b11aa2a61bb9632f469a26548319321017
    HEAD_REF master
    PATCHES package.patch
)
string(COMPARE EQUAL "${VCPKG_LIBRARY_LINKAGE}" "dynamic" BUILD_SHARED)
vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS -DBUILD_SHARED_LIBS=${BUILD_SHARED}
)
vcpkg_cmake_install()
vcpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/gmssl)
vcpkg_copy_tools(TOOL_NAMES gmssl AUTO_CLEAN)
vcpkg_copy_pdbs()
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
