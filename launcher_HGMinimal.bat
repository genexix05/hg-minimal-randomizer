@echo off
setlocal
cd /d "%~dp0"

set "JAR=%~dp0dist\PokeRandoZX-HGMinimal.jar"
if not exist "%JAR%" (
  echo No se encuentra dist\PokeRandoZX-HGMinimal.jar
  echo Compila antes con: powershell -ExecutionPolicy Bypass -File scripts\build.ps1
  echo O descarga el JAR desde Releases.
  pause
  exit /b 1
)

echo HeartGold Minimal Randomizer ^(fork experimental^)
echo.
java -Xmx4608M -jar "%JAR%" please-use-the-launcher
echo.
pause
