message(STATUS "ireader-media-common uses static linkage")
set(VCPKG_LIBRARY_LINKAGE static)
vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO ireader/media-server
    REF c0463893bc509e65bea9f4f76be68c1f89ccdfcf
    SHA512 242f438d971a302d9c054666c68e410d368dd8c2de094077374759964d3abc810999f4a852c13c57a262fc1bcc0269ff5688aabb0513fb85588e02e205a365ff
    HEAD_REF master
)
file(COPY "${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt" "${CMAKE_CURRENT_LIST_DIR}/cmake" DESTINATION "${SOURCE_PATH}")
vcpkg_cmake_configure(SOURCE_PATH "${SOURCE_PATH}" OPTIONS ${FEATURE_OPTIONS} -DBUILD_TESTING=OFF)
vcpkg_cmake_install()
vcpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/ireader-media-common)
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
set(VCPKG_POLICY_EMPTY_INCLUDE_FOLDER enabled)
vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
