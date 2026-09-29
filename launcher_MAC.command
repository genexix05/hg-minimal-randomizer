#!/bin/bash
cd "$(dirname "$0")"
JAR="./PokeRandoZX-HGMinimal.jar"
if [ ! -f "$JAR" ]; then
  JAR="./dist/PokeRandoZX-HGMinimal.jar"
fi
if [ ! -f "$JAR" ]; then
  echo "PokeRandoZX-HGMinimal.jar not found."
  echo "Download a Release ZIP, or build with scripts/build.ps1"
  exit 1
fi
echo "HeartGold Minimal Randomizer"
java -Xmx4608M -jar "$JAR" please-use-the-launcher
