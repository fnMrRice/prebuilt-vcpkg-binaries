message(STATUS "ireader-sdk uses static linkage")
set(VCPKG_LIBRARY_LINKAGE static)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO ireader/sdk
    REF e84a3d1a91cacdd8dedbbc931a2886b99bec4846
    SHA512 a575274bc26dc76071bfca7c24566124440012d8c81e5da9d558ccf8768ef171db0cc299ffacb0540f5751ab06b3b6eef60e9182aa358f4fecf77a7c95d26f6f
    HEAD_REF master
    PATCHES fix-poll-callback.patch fix-algorithm-includes.patch
)

file(COPY "${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt"
          "${CMAKE_CURRENT_LIST_DIR}/cmake"
     DESTINATION "${SOURCE_PATH}")

vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        aio BUILD_LIBRARY_AIO
        http BUILD_LIBRARY_HTTP
        ice BUILD_LIBRARY_ICE
)
vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS ${FEATURE_OPTIONS} -DBUILD_TESTING=OFF
)
vcpkg_cmake_install()
vcpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/ireader-sdk)
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
