include_guard(GLOBAL)

set(librtp_DIR ${CMAKE_CURRENT_SOURCE_DIR}/librtp)
set(librtp_INCLUDE_DIRECTORY ${librtp_DIR}/include)
set(librtp_SOURCE_DIRECTORIES ${librtp_DIR}/source ${librtp_DIR}/payload ${librtp_DIR}/rtpext)
set(librtp_TEST_DIRECTORY ${librtp_DIR}/test)

file(GLOB_RECURSE librtp_HEADER_FILES
        ${librtp_INCLUDE_DIRECTORY}/*.h
        ${librtp_INCLUDE_DIRECTORY}/*.hxx
        ${librtp_INCLUDE_DIRECTORY}/*.hpp
)
file(GLOB_RECURSE librtp_SOURCE_FILES
        ${librtp_DIR}/source/*.c
        ${librtp_DIR}/source/*.cxx
        ${librtp_DIR}/source/*.cpp
        ${librtp_DIR}/payload/*.c
        ${librtp_DIR}/payload/*.cxx
        ${librtp_DIR}/payload/*.cpp
        ${librtp_DIR}/rtpext/*.c
        ${librtp_DIR}/rtpext/*.cxx
        ${librtp_DIR}/rtpext/*.cpp
)

add_library(rtp ${librtp_HEADER_FILES} ${librtp_SOURCE_FILES})
target_include_directories(rtp PRIVATE ${librtp_INCLUDE_DIRECTORY})

list(APPEND IREADER_MEDIA_SERVER_EXPORT_LIBS rtp)
install(DIRECTORY ${librtp_INCLUDE_DIRECTORY}/ DESTINATION include/ireader/media-server/rtp)
