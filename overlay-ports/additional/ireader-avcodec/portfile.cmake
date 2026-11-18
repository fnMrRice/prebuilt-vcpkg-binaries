message(STATUS "ireader-avcodec uses static linkage")
set(VCPKG_LIBRARY_LINKAGE static)
vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO ireader/avcodec
    REF f5637e6dfec3291f5bd697c092da91586c4faba8
    SHA512 64263b98364642a4d3af0bb9e840843bf73ac41935e5b09510413479f4c2092867fa94012b86cf32b60035d4fd644a3521a81a8bb8085776f8ac9f5f166e1d7e
    HEAD_REF master
)
file(COPY "${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt" "${CMAKE_CURRENT_LIST_DIR}/cmake" DESTINATION "${SOURCE_PATH}")
vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        h264 BUILD_LIBRARY_H264
        h265 BUILD_LIBRARY_H265
        avcodec BUILD_LIBRARY_AVCODEC
        avbsf BUILD_LIBRARY_AVBSF
)
vcpkg_cmake_configure(SOURCE_PATH "${SOURCE_PATH}" OPTIONS ${FEATURE_OPTIONS} -DBUILD_TESTING=OFF)
vcpkg_cmake_install()
vcpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/ireader-avcodec)
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
set(VCPKG_POLICY_EMPTY_INCLUDE_FOLDER enabled)
vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
