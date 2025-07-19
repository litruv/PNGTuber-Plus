@echo off
setlocal

echo Building PNGTuber Plus for Windows...

rem Create build directory
if not exist "build\windows" mkdir "build\windows"

rem Build the project
echo Running Godot export...
"D:\Godot\Godot_v4.4.1-stable_win64.exe" --headless --verbose --export-release "Windows Desktop" "build\windows\PNGTuber-Plus.exe"

if %ERRORLEVEL% EQU 0 (
    echo.
    echo Build completed successfully!
    echo Output: build\windows\PNGTuber-Plus.exe
    echo.
) else (
    echo.
    echo Build failed with error code %ERRORLEVEL%
    echo.
)

pause
