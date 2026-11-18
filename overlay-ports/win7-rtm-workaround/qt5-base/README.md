# Qt 5 Windows 7 compatibility overlay

Based on the qt5-base port in vcpkg commit
`0df93a05b9de080129e653ec4776d7e14a1b2e4f`.

The additional `win7-file-id-info.patch` enables Qt's existing FILE_ID_INFO
compatibility declaration for MSVC when targeting pre-Windows 8 APIs.
The Windows SDK hides this type for a Windows 7 target. The original Qt guard
only included MinGW, which caused error C2065 in qfilesystemengine_win.cpp.
The existing GetFileInformationByHandleEx attempt and legacy file-ID fallback
remain intact. The patch follows the upstream mingw9 patch in the patch list.
