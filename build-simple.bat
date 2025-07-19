@echo off
echo Building PNGTuber Plus for Windows...
if not exist "build\windows" mkdir "build\windows"
echo Running Godot export...
"D:\Godot\Godot_v4.4.1-stable_win64.exe" --headless --verbose --export-release "Windows Desktop" "build\windows\PNGTuber-Plus.exe"
if %ERRORLEVEL% EQU 0 (
    echo Build completed successfully!
    echo Output: build\windows\PNGTuber-Plus.exe
) else (
    echo Build failed with error code %ERRORLEVEL%
)
pause
