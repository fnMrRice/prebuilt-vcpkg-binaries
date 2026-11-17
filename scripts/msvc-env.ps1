param(
    [string]$Toolset = $env:REQUESTED_TOOLSET
)
$ErrorActionPreference = 'Stop'
if ($Toolset -and $Toolset -notmatch '^\d+\.\d+$') {
    throw "Invalid MSVC toolset version: $Toolset"
}
$vswhere = Join-Path ${env:ProgramFiles(x86)} 'Microsoft Visual Studio/Installer/vswhere.exe'
$installation = & $vswhere -latest -products '*' -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath
if ($LASTEXITCODE -ne 0 -or -not $installation) { throw 'No Visual Studio C++ installation was found.' }
$vcvars = Join-Path $installation 'VC/Auxiliary/Build/vcvarsall.bat'
$before = @{}
Get-ChildItem Env: | ForEach-Object { $before[$_.Name] = $_.Value }
$command = 'call "' + $vcvars + '" amd64'
if ($Toolset) { $command += ' -vcvars_ver=' + $Toolset }
$variables = & $env:ComSpec /d /s /c "$command >nul && set"
if ($LASTEXITCODE -ne 0) { throw "MSVC environment initialization failed: $LASTEXITCODE" }
foreach ($line in $variables) {
    if ($line -notmatch '^([^=]+)=(.*)$') { continue }
    $name, $value = $Matches[1], $Matches[2]
    if ($name -match '^(GITHUB_|RUNNER_|NODE_OPTIONS$)') { continue }
    Set-Item -LiteralPath "Env:$name" -Value $value
    if ($env:GITHUB_ENV -and $before[$name] -cne $value) {
        Add-Content -LiteralPath $env:GITHUB_ENV -Value "$name=$value" -Encoding utf8
    }
}
if (-not $env:VCToolsVersion) { throw 'MSVC environment was not initialized.' }
if ($Toolset -and $env:VCToolsVersion -notlike "$Toolset.*") {
    throw "Expected MSVC $Toolset, got $env:VCToolsVersion"
}
$env:VCPKG_VISUAL_STUDIO_PATH = $installation
if ($env:GITHUB_ENV) {
    Add-Content -LiteralPath $env:GITHUB_ENV -Value "VCPKG_VISUAL_STUDIO_PATH=$installation" -Encoding utf8
}
Write-Output "Visual Studio: $installation; MSVC: $env:VCToolsVersion"
