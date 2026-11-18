include(CMakePackageConfigHelpers)
set(IREADER_COMPONENTS)
foreach(component IN ITEMS dash flv hls mkv mov mpeg rtmp rtp rtsp sip)
    if(TARGET ${component} OR TARGET ireader::media-server::${component})
        list(APPEND IREADER_COMPONENTS ${component})
    endif()
endforeach()
configure_package_config_file("${CMAKE_CURRENT_SOURCE_DIR}/cmake/ireader-media-server-config.cmake.in"
    "${CMAKE_CURRENT_BINARY_DIR}/ireader-media-server-config.cmake"
    INSTALL_DESTINATION "lib/cmake/ireader-media-server")
if(IREADER_EXPORT_TARGETS)
    install(TARGETS ${IREADER_EXPORT_TARGETS} EXPORT ireader-media-server-targets
        ARCHIVE DESTINATION lib LIBRARY DESTINATION lib RUNTIME DESTINATION bin)
    install(EXPORT ireader-media-server-targets FILE ireader-media-server-targets.cmake
        DESTINATION "lib/cmake/ireader-media-server" NAMESPACE ireader::media-server::)
endif()
install(FILES "${CMAKE_CURRENT_BINARY_DIR}/ireader-media-server-config.cmake" DESTINATION "lib/cmake/ireader-media-server")
