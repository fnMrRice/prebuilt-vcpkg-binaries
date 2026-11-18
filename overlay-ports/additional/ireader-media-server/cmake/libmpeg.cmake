include_guard(GLOBAL)
ireader_library(mpeg "${CMAKE_CURRENT_SOURCE_DIR}/libmpeg/include" libmpeg "${CMAKE_CURRENT_SOURCE_DIR}/libmpeg/source")
target_compile_definitions(mpeg PRIVATE MPEG_H26X_VERIFY MPEG_ZERO_PAYLOAD_LENGTH MPEG_DAHUA_AAC_FROM_G711 MPEG_KEDA_H265_FROM_H264)
