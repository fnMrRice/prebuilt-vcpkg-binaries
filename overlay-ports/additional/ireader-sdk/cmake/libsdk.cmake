include_guard(GLOBAL)
ireader_library(sdk "${CMAKE_CURRENT_SOURCE_DIR}/include" ""
    "${CMAKE_CURRENT_SOURCE_DIR}/source/digest")
file(GLOB core_sources CONFIGURE_DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/source/*.c" "${CMAKE_CURRENT_SOURCE_DIR}/source/*.cpp")
file(GLOB string_sources CONFIGURE_DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/source/string/*.c")
file(GLOB algorithm_sources CONFIGURE_DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/algorithm/*.c")
target_sources(sdk PRIVATE ${core_sources} ${string_sources} ${algorithm_sources}
    source/port/ip-route.c source/port/sysdirlist.c source/port/systimer.c)
if(WIN32)
    target_sources(sdk PRIVATE source/port/file-watcher-win32.c source/port/serial-port-win32.c
        source/port/win32-async-pipe.c source/port/win32-backtrace.c source/port/win32-minidump.c)
    target_link_libraries(sdk PUBLIC ws2_32 iphlpapi winmm advapi32 dbghelp)
elseif(CMAKE_SYSTEM_NAME STREQUAL "Linux")
    target_sources(sdk PRIVATE source/port/file-watcher-linux.c source/port/serial-port-posix.c source/port/linux-async-pipe.c)
    target_link_libraries(sdk PUBLIC ${CMAKE_DL_LIBS} rt m)
endif()
target_link_libraries(sdk PUBLIC Threads::Threads)
install(FILES algorithm/algorithm.h DESTINATION include/ireader/sdk/algorithm)
