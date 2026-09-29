# HeartGold Minimal Randomizer

Fork experimental de [Universal Pokémon Randomizer ZX](https://github.com/Ajarmar/universal-pokemon-randomizer-zx)
pensado para **Pokémon HeartGold Minimal** (hg-engine: dex expandido, Fairy, megas, etc.).

> **No incluye ROMs ni parches.** Necesitas tu propia ROM legal de HeartGold Minimal.

## Estado

Funciona (con matices) sobre Minimal:

- Carga de ROM con dex expandido
- Encuentros salvajes
- Movepools (formato empaquetado hg-engine)
- Abilities / stats (guardado del dex completo)
- TMs (sin actualizar descripciones de ítem si el banco de texto está vacío)
- Held items de trainers (con soporte Fairy)

Sigue siendo experimental: algunas opciones del UPR original pueden fallar o comportarse raro.

## Requisitos

- **JDK 11+** (`javac`, `jar`, `java` en PATH o en `C:\Program Files\Java\jdk-*`)
- Conexión a internet la primera vez (descarga el JAR base de UPR ZX 4.6.1)

## Compilar

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\build.ps1
```

Genera `dist/PokeRandoZX-HGMinimal.jar`.

## Usar

1. Compila (o descarga el JAR de la [release](../../releases) de este repo).
2. Ejecuta `launcher_HGMinimal.bat`
3. Abre tu ROM de HeartGold Minimal
4. Randomiza y guarda una **ROM nueva**

## Licencia

Código basado en UPR ZX / UPR, bajo **GNU GPL v3**. Ver `LICENSE`.

Este proyecto **no está afiliado** a Nintendo. Pokémon y nombres relacionados son marcas de Nintendo/Creatures/GAME FREAK.

## Créditos

- [Universal Pokémon Randomizer ZX](https://github.com/Ajarmar/universal-pokemon-randomizer-zx) (Ajarmar y contribuidores)
- [Universal Pokémon Randomizer](https://github.com/Dabomstew/universal-pokemon-randomizer) (Dabomstew)
- HeartGold Minimal / [hg-engine](https://github.com/BluRosie/hg-engine)
