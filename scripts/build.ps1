# Build HeartGold Minimal Randomizer (plug-and-play package in dist/)
# Usage:
#   powershell -ExecutionPolicy Bypass -File .\scripts\build.ps1
# Optional smoke test:
#   $env:HG_MINIMAL_ROM = "C:\path\to\HeartGold Minimal.nds"

$ErrorActionPreference = "Stop"
$root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
Set-Location $root

function Find-JdkBin {
    $cmd = Get-Command javac -ErrorAction SilentlyContinue
    if ($cmd) {
        $dir = Split-Path $cmd.Source
        if (Test-Path (Join-Path $dir "jar.exe")) { return $dir }
    }
    $candidates = @(
        "C:\Program Files\Java\jdk-11.0.32\bin",
        "C:\Program Files\Java\jdk-26.0.1\bin"
    ) + @(Get-ChildItem "C:\Program Files\Java\jdk-*\bin" -ErrorAction SilentlyContinue | Select-Object -ExpandProperty FullName)
    foreach ($c in $candidates) {
        if ((Test-Path (Join-Path $c "javac.exe")) -and (Test-Path (Join-Path $c "jar.exe"))) {
            return $c
        }
    }
    throw "JDK with javac/jar not found. Install JDK 11+."
}

$jdkBin = Find-JdkBin
$javac = Join-Path $jdkBin "javac.exe"
$java = Join-Path $jdkBin "java.exe"
$jar = Join-Path $jdkBin "jar.exe"
Write-Host "Using JDK: $jdkBin"

$vendorDir = Join-Path $root "poke-rando-release"
$releaseJar = Join-Path $vendorDir "PokeRandoZX.jar"
$zipPath = Join-Path $vendorDir "PokeRandoZX-v4_6_1.zip"
$uprUrl = "https://github.com/Ajarmar/universal-pokemon-randomizer-zx/releases/download/v4.6.1/PokeRandoZX-v4_6_1.zip"

if (-not (Test-Path $releaseJar)) {
    New-Item -ItemType Directory -Force -Path $vendorDir | Out-Null
    Write-Host "Downloading UPR ZX 4.6.1 (build dependency only)..."
    Invoke-WebRequest -Uri $uprUrl -OutFile $zipPath
    Expand-Archive -Path $zipPath -DestinationPath $vendorDir -Force
    if (-not (Test-Path $releaseJar)) {
        $found = Get-ChildItem $vendorDir -Filter "PokeRandoZX.jar" -Recurse | Select-Object -First 1
        if ($found) { Copy-Item $found.FullName $releaseJar -Force }
    }
    if (-not (Test-Path $releaseJar)) { throw "Could not obtain PokeRandoZX.jar" }
}

$outDir = Join-Path $root "build\classes"
$extractDir = Join-Path $root "build\jar-extract"
$distDir = Join-Path $root "dist"
$patchedJar = Join-Path $distDir "PokeRandoZX-HGMinimal.jar"
$packageZip = Join-Path $distDir "PokeRandoZX-HGMinimal.zip"

New-Item -ItemType Directory -Force -Path $outDir, $distDir | Out-Null
if (Test-Path $extractDir) { Remove-Item $extractDir -Recurse -Force }
New-Item -ItemType Directory -Force -Path $extractDir | Out-Null

Push-Location $extractDir
& $jar xf $releaseJar
Pop-Location

$sources = @(
    "upr-zx\src\com\dabomstew\pkrandom\constants\GlobalConstants.java",
    "upr-zx\src\com\dabomstew\pkrandom\constants\Gen4Constants.java",
    "upr-zx\src\com\dabomstew\pkrandom\romhandlers\AbstractRomHandler.java",
    "upr-zx\src\com\dabomstew\pkrandom\romhandlers\Gen4RomHandler.java",
    "upr-zx\src\com\dabomstew\pkrandom\pokemon\EvolutionType.java",
    "upr-zx\src\com\dabomstew\pkrandom\pokemon\Effectiveness.java",
    "upr-zx\src\com\dabomstew\pkrandom\HgMinimalLoadTest.java"
) | ForEach-Object { Join-Path $root $_ }

Write-Host "Compiling patched sources..."
& $javac -encoding UTF-8 -cp $releaseJar -d $outDir @sources
if ($LASTEXITCODE -ne 0) { throw "javac failed" }

Copy-Item -Path (Join-Path $outDir "*") -Destination $extractDir -Recurse -Force
$manifest = Join-Path $extractDir "META-INF\MANIFEST.MF"
@"
Manifest-Version: 1.0
Main-Class: com.dabomstew.pkrandom.newgui.NewRandomizerGUI

"@ | Set-Content -Path $manifest -Encoding ASCII

if (Test-Path $patchedJar) { Remove-Item $patchedJar -Force }
Push-Location $extractDir
& $jar cfm $patchedJar $manifest .
Pop-Location

# Plug-and-play package (same layout as UPR ZX releases)
Copy-Item (Join-Path $root "launcher_WINDOWS.bat") $distDir -Force
Copy-Item (Join-Path $root "launcher_UNIX.sh") $distDir -Force
Copy-Item (Join-Path $root "launcher_MAC.command") $distDir -Force
Copy-Item (Join-Path $root "scripts\release-readme.txt") (Join-Path $distDir "README.txt") -Force

if (Test-Path $packageZip) { Remove-Item $packageZip -Force }
Compress-Archive -Path @(
    (Join-Path $distDir "PokeRandoZX-HGMinimal.jar"),
    (Join-Path $distDir "launcher_WINDOWS.bat"),
    (Join-Path $distDir "launcher_UNIX.sh"),
    (Join-Path $distDir "launcher_MAC.command"),
    (Join-Path $distDir "README.txt")
) -DestinationPath $packageZip

Write-Host "Built JAR:  $patchedJar"
Write-Host "Built ZIP:  $packageZip"

$rom = $env:HG_MINIMAL_ROM
if ($rom -and (Test-Path -LiteralPath $rom)) {
    Write-Host "Smoke test load: $rom"
    & $java -cp $patchedJar com.dabomstew.pkrandom.HgMinimalLoadTest $rom
    exit $LASTEXITCODE
} else {
    Write-Host "No ROM smoke test (set HG_MINIMAL_ROM to enable)."
}
