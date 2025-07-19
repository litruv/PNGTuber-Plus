@echo off
setlocal

echo Building PNGTuber Plus for Windows (CI Environment)...

rem Create build directory
if not exist "build\windows" mkdir "build\windows"

rem Templates should already be installed by the GitHub Actions workflow
set TEMPLATE_DIR=C:\WINDOWS\ServiceProfiles\NetworkService\AppData\Roaming\Godot\export_templates\4.4.1.stable
echo Checking for export templates at: %TEMPLATE_DIR%

if exist "%TEMPLATE_DIR%" (
    echo Export templates found.
    dir "%TEMPLATE_DIR%"
) else (
    echo ERROR: Export templates not found at %TEMPLATE_DIR%
    echo This should have been handled by the GitHub Actions setup step.
    exit /b 1
)

rem Build the project
echo Running Godot export...
"D:\Godot\Godot_v4.4.1-stable_win64.exe" --headless --export-release "Windows Desktop" "build\windows\PNGTuber-Plus.exe"

if %ERRORLEVEL% EQU 0 (
    echo.
    echo Build completed successfully!
    echo Output: build\windows\PNGTuber-Plus.exe
    if exist "build\windows\PNGTuber-Plus.exe" (
        echo File size: 
        dir "build\windows\PNGTuber-Plus.exe"
    )
    echo.
) else (
    echo.
    echo Build failed with error code %ERRORLEVEL%
    echo.
    exit /b %ERRORLEVEL%
)
