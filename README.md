# HeartGold Minimal Randomizer

Experimental fork of [Universal Pokémon Randomizer ZX](https://github.com/Ajarmar/universal-pokemon-randomizer-zx) for **Pokémon HeartGold Minimal** (hg-engine: expanded dex, Fairy type, megas, and more).

> **This project does not include any ROMs or patches.** You must provide your own legally obtained HeartGold Minimal ROM.

## Quick start (players)

1. Download the latest **Release** ZIP from this repository.
2. Extract it anywhere.
3. Double-click `launcher_WINDOWS.bat` (Windows), `launcher_MAC.command` (macOS), or `launcher_UNIX.sh` (Linux).
4. Open your HeartGold Minimal `.nds` ROM, randomize, and save a **new** ROM.

That is it — no extra downloads, no JDK install for players, no building from source.

Requires a normal Java install (same as official UPR ZX). If Java is missing, install a recent JRE/JDK and try again.

## What works

- Loading expanded-dex Minimal ROMs
- Wild encounters
- Level-up movesets (hg-engine packed format)
- Abilities / stats (full dex save)
- TMs (item description text bank may be skipped on Minimal)
- Trainer held items (including Fairy)

Still experimental: some stock UPR options may fail or behave oddly on this hack.

## Build from source (developers)

Requirements: **JDK 11+**.

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\build.ps1
```

This downloads the UPR ZX 4.6.1 base JAR once (into a local ignored folder), applies the Minimal patches, and writes:

- `dist/PokeRandoZX-HGMinimal.jar`
- `dist/` launcher scripts (ready to zip for a release)

Optional smoke test:

```powershell
$env:HG_MINIMAL_ROM = "C:\path\to\HeartGold Minimal.nds"
powershell -ExecutionPolicy Bypass -File .\scripts\build.ps1
```

## License

Based on UPR ZX / UPR under **GNU GPL v3**. See `LICENSE` and `NOTICE`.

Not affiliated with Nintendo. Pokémon and related names are trademarks of Nintendo / Creatures Inc. / GAME FREAK.

## Credits

- [Universal Pokémon Randomizer ZX](https://github.com/Ajarmar/universal-pokemon-randomizer-zx)
- [Universal Pokémon Randomizer](https://github.com/Dabomstew/universal-pokemon-randomizer)
- HeartGold Minimal / [hg-engine](https://github.com/BluRosie/hg-engine)
