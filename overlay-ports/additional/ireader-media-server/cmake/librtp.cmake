include_guard(GLOBAL)
ireader_library(rtp "${CMAKE_CURRENT_SOURCE_DIR}/librtp/include" rtp "${CMAKE_CURRENT_SOURCE_DIR}/librtp/source" "${CMAKE_CURRENT_SOURCE_DIR}/librtp/payload" "${CMAKE_CURRENT_SOURCE_DIR}/librtp/rtpext")
target_link_libraries(rtp PUBLIC $<$<PLATFORM_ID:Windows>:advapi32> $<$<PLATFORM_ID:Linux>:m>)
