include_guard(GLOBAL)
ireader_library(http "${CMAKE_CURRENT_SOURCE_DIR}/libhttp/include" http "${CMAKE_CURRENT_SOURCE_DIR}/libhttp/source")
target_link_libraries(http PUBLIC sdk aio)
