@echo off
setlocal enabledelayedexpansion

echo =====================================================================
echo  VeriSmat ESP32 Controller - Android APK Generator
echo =====================================================================
echo.

:: 1. Check for Flutter
where flutter >nul 2>nul
if %errorlevel% neq 0 (
    echo [X] Flutter SDK was not detected in your system PATH.
    echo.
    echo To build locally on Windows, you need:
    echo   1. Flutter SDK: https://docs.flutter.dev/get-started/install/windows
    echo   2. Java JDK 17: winget install Microsoft.OpenJDK.17
    echo   3. Android Studio / Android SDK command-line tools
    echo.
    echo -----------------------------------------------------------------
    echo  RECOMMENDED ALTERNATIVES (NO LOCAL INSTALLATION REQUIRED):
    echo -----------------------------------------------------------------
    echo  1. FlutterFlow Cloud Build:
    echo     Open this project in FlutterFlow, click the top-right
    echo     'Download / APK' menu and click 'Build APK'. FlutterFlow
    echo     compiles and gives you the APK directly in 2-3 minutes.
    echo.
    echo  2. Free GitHub Actions Cloud Build:
    echo     Push this repository to GitHub. The included workflow
    echo     (.github/workflows/build_apk.yml) compiles the APK
    echo     automatically in the cloud and lets you download it.
    echo -----------------------------------------------------------------
    echo.
    pause
    exit /b 1
)

echo [OK] Flutter SDK detected.
echo.

:: 2. Run flutter doctor
echo Checking Flutter and Android environment...
call flutter doctor -v
echo.

:: 3. Fetch dependencies
echo [1/2] Resolving dependencies (flutter pub get)...
call flutter pub get
if %errorlevel% neq 0 (
    echo [X] flutter pub get failed.
    pause
    exit /b 1
)

:: 4. Build release APK
echo.
echo [2/2] Compiling Android Release APK (flutter build apk --release)...
call flutter build apk --release

if %errorlevel% equ 0 (
    echo.
    echo =====================================================================
    echo [SUCCESS] APK compiled successfully!
    echo Location: build\app\outputs\flutter-apk\app-release.apk
    echo =====================================================================
    echo.
    explorer.exe build\app\outputs\flutter-apk
) else (
    echo.
    echo [X] APK compilation failed. Please review the error log above.
)

pause
