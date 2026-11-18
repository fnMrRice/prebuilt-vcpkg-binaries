# Qt 5 Declarative Windows 7 compatibility overlay

Based on the qt5-declarative port in vcpkg commit
`8f0be20f53767f13f27aea63d64d98990965fb1d`.

The upstream Windows default features enable the optional Direct3D 12 scene graph
backend. It uses DirectComposition interfaces such as IDCompositionDevice,
IDCompositionTarget, and IDCompositionVisual, which are unavailable for a Windows
7 API target. This caused C2065 and related compiler errors in qsgd3d12engine.

This overlay removes the d3d12 feature, keeps platform-default-features as a
compatible no-op, and configures Declarative with -no-d3d12. Qt Quick's normal
rendering path remains available. The upstream linker-memory and debug
qmlimportscanner packaging patches are preserved. Only the Windows 7 manifest
includes this overlay; modern Windows builds use the official port.
