include("${CURRENT_INSTALLED_DIR}/share/qt5/qt_port_functions.cmake")

# DirectComposition is unavailable on Windows 7.
list(APPEND CORE_OPTIONS -no-d3d12)

qt_submodule_installation(
    OUT_SOURCE_PATH SOURCE_PATH
    PATCHES
        linker-oom.diff
        fix-qmlimportscanner-debug-plugins.patch
    BUILD_OPTIONS
        ${CORE_OPTIONS}
)

if(NOT QT_UPDATE_VERSION)
  vcpkg_replace_string("${CURRENT_PACKAGES_DIR}/include/qt5/QtQml/${QT_MAJOR_MINOR_VER}.${QT_PATCH_VER}/QtQml/private/qqmljsparser_p.h" "${SOURCE_PATH}" "")
endif()
