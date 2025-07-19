@echo off
echo Building PNGTuber Plus for Windows...

:: Create build directory
if not exist "build\windows" mkdir "build\windows"

:: Build the project
echo Running Godot export...
godot --headless --verbose --export-release "Windows Desktop" "build\windows\PNGTuber-Plus.exe"

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ✅ Build completed successfully!
    echo Output: build\windows\PNGTuber-Plus.exe
    echo.
    pause
) else (
    echo.
    echo ❌ Build failed with error code %ERRORLEVEL%
    echo.
    pause
)
