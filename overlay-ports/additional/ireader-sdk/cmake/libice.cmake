include_guard(GLOBAL)
ireader_library(ice "${CMAKE_CURRENT_SOURCE_DIR}/libice/include" ice "${CMAKE_CURRENT_SOURCE_DIR}/libice/src")
target_link_libraries(ice PUBLIC sdk)
