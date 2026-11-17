cmake_minimum_required(VERSION 3.29)

project(ireader-media-server VERSION 1.0.0 LANGUAGES C CXX)

option(BUILD_LIBRARY_DASH "Build library dash" ON)
option(BUILD_LIBRARY_FLV "Build library flv" ON)
option(BUILD_LIBRARY_HLS "Build library hls" ON)
option(BUILD_LIBRARY_MOV "Build library mov" ON)
option(BUILD_LIBRARY_MPEG "Build library mpeg" ON)
option(BUILD_LIBRARY_RTMP "Build library rtmp" ON)
option(BUILD_LIBRARY_RTP "Build library rtp" ON)
option(BUILD_LIBRARY_RTSP "Build library rtsp" ON)
option(BUILD_LIBRARY_SIP "Build library sip" ON)
option(BUILD_TESTING "Build tests" OFF)

if (WIN32)
    add_compile_definitions(OS_WINDOWS)
endif ()

if (BUILD_LIBRARY_DASH)
    include(cmake/libdash.cmake)
endif ()
if (BUILD_LIBRARY_FLV)
    include(cmake/libflv.cmake)
endif ()
if (BUILD_LIBRARY_HLS)
    include(cmake/libhls.cmake)
endif ()
if (BUILD_LIBRARY_MOV)
    include(cmake/libmov.cmake)
endif ()
if (BUILD_LIBRARY_MPEG)
    include(cmake/libmpeg.cmake)
endif ()
if (BUILD_LIBRARY_RTMP)
    include(cmake/librtmp.cmake)
endif ()
if (BUILD_LIBRARY_RTP)
    include(cmake/librtp.cmake)
endif ()
if (BUILD_LIBRARY_RTSP)
    include(cmake/librtsp.cmake)
endif ()
if (BUILD_LIBRARY_SIP)
    include(cmake/libsip.cmake)
endif ()

foreach(library IN LISTS IREADER_MEDIA_SERVER_EXPORT_LIBS)
    target_include_directories(${library} INTERFACE "$<INSTALL_INTERFACE:include>")
endforeach()

install(TARGETS ${IREADER_MEDIA_SERVER_EXPORT_LIBS}
        EXPORT ireader-media-server-config
        ARCHIVE DESTINATION lib
        LIBRARY DESTINATION lib
        RUNTIME DESTINATION bin
)
install(
        EXPORT ireader-media-server-config
        DESTINATION lib/cmake/ireader-media-server
        NAMESPACE ireader::media-server::
)
