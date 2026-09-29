@echo off
setlocal
cd /d "%~dp0"

rem Prefer jar next to this launcher (release ZIP layout).
set "JAR=%~dp0PokeRandoZX-HGMinimal.jar"
if not exist "%JAR%" set "JAR=%~dp0dist\PokeRandoZX-HGMinimal.jar"

if not exist "%JAR%" (
  echo PokeRandoZX-HGMinimal.jar not found.
  echo Download a Release ZIP, or build with scripts\build.ps1
  pause
  exit /b 1
)

echo HeartGold Minimal Randomizer
echo.
java -Xmx4608M -jar "%JAR%" please-use-the-launcher
echo.
pause
