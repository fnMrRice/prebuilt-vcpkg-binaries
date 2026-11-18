include(CMakePackageConfigHelpers)
set(IREADER_COMPONENTS)
foreach(component IN ITEMS h264 h265 avcodec avbsf)
    if(TARGET ${component} OR TARGET ireader::avcodec::${component})
        list(APPEND IREADER_COMPONENTS ${component})
    endif()
endforeach()
configure_package_config_file("${CMAKE_CURRENT_SOURCE_DIR}/cmake/ireader-avcodec-config.cmake.in"
    "${CMAKE_CURRENT_BINARY_DIR}/ireader-avcodec-config.cmake"
    INSTALL_DESTINATION "lib/cmake/ireader-avcodec")
if(IREADER_EXPORT_TARGETS)
    install(TARGETS ${IREADER_EXPORT_TARGETS} EXPORT ireader-avcodec-targets
        ARCHIVE DESTINATION lib LIBRARY DESTINATION lib RUNTIME DESTINATION bin)
    install(EXPORT ireader-avcodec-targets FILE ireader-avcodec-targets.cmake
        DESTINATION "lib/cmake/ireader-avcodec" NAMESPACE ireader::avcodec::)
endif()
install(FILES "${CMAKE_CURRENT_BINARY_DIR}/ireader-avcodec-config.cmake" DESTINATION "lib/cmake/ireader-avcodec")
