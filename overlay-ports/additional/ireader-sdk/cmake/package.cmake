include(CMakePackageConfigHelpers)
set(IREADER_COMPONENTS)
foreach(component IN ITEMS sdk aio http ice)
    if(TARGET ${component} OR TARGET ireader::sdk::${component})
        list(APPEND IREADER_COMPONENTS ${component})
    endif()
endforeach()
configure_package_config_file("${CMAKE_CURRENT_SOURCE_DIR}/cmake/ireader-sdk-config.cmake.in"
    "${CMAKE_CURRENT_BINARY_DIR}/ireader-sdk-config.cmake"
    INSTALL_DESTINATION "lib/cmake/ireader-sdk")
if(IREADER_EXPORT_TARGETS)
    install(TARGETS ${IREADER_EXPORT_TARGETS} EXPORT ireader-sdk-targets
        ARCHIVE DESTINATION lib LIBRARY DESTINATION lib RUNTIME DESTINATION bin)
    install(EXPORT ireader-sdk-targets FILE ireader-sdk-targets.cmake
        DESTINATION "lib/cmake/ireader-sdk" NAMESPACE ireader::sdk::)
endif()
install(FILES "${CMAKE_CURRENT_BINARY_DIR}/ireader-sdk-config.cmake" DESTINATION "lib/cmake/ireader-sdk")
