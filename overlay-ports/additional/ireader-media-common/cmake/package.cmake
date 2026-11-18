include(CMakePackageConfigHelpers)
set(IREADER_COMPONENTS)
foreach(component IN ITEMS flv metadata)
    if(TARGET ${component} OR TARGET ireader::media-server::${component})
        list(APPEND IREADER_COMPONENTS ${component})
    endif()
endforeach()
configure_package_config_file("${CMAKE_CURRENT_SOURCE_DIR}/cmake/ireader-media-common-config.cmake.in"
    "${CMAKE_CURRENT_BINARY_DIR}/ireader-media-common-config.cmake"
    INSTALL_DESTINATION "lib/cmake/ireader-media-common")
if(IREADER_EXPORT_TARGETS)
    install(TARGETS ${IREADER_EXPORT_TARGETS} EXPORT ireader-media-common-targets
        ARCHIVE DESTINATION lib LIBRARY DESTINATION lib RUNTIME DESTINATION bin)
    install(EXPORT ireader-media-common-targets FILE ireader-media-common-targets.cmake
        DESTINATION "lib/cmake/ireader-media-common" NAMESPACE ireader::media-server::)
endif()
install(FILES "${CMAKE_CURRENT_BINARY_DIR}/ireader-media-common-config.cmake" DESTINATION "lib/cmake/ireader-media-common")
