@echo off
setlocal

echo Building PNGTuber Plus for Windows...

rem Create build directory
if not exist "build\windows" mkdir "build\windows"

rem Install export templates if they don't exist
echo Checking for export templates...
set TEMPLATE_DIR=%APPDATA%\Godot\export_templates\4.4.1.stable
if not exist "%TEMPLATE_DIR%" (
    echo Export templates not found. Installing...
    "D:\Godot\Godot_v4.4.1-stable_win64.exe" --headless --export-pack
    timeout /t 5 /nobreak >nul
    
    rem Download templates if the export-pack didn't work
    if not exist "%TEMPLATE_DIR%" (
        echo Downloading export templates...
        powershell -Command "& {Invoke-WebRequest -Uri 'https://downloads.tuxfamily.org/godotengine/4.4.1/Godot_v4.4.1-stable_export_templates.tpz' -OutFile 'templates.tpz'}"
        
        rem Extract templates
        powershell -Command "& {Expand-Archive -Path 'templates.tpz' -DestinationPath 'temp_templates' -Force}"
        if not exist "%APPDATA%\Godot\export_templates" mkdir "%APPDATA%\Godot\export_templates"
        move "temp_templates\templates" "%TEMPLATE_DIR%"
        rmdir /s /q "temp_templates"
        del "templates.tpz"
        echo Export templates installed.
    )
) else (
    echo Export templates found.
)

rem Build the project
echo Running Godot export...
"D:\Godot\Godot_v4.4.1-stable_win64.exe" --headless --export-release "Windows Desktop" "build\windows\PNGTuber-Plus.exe"

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
