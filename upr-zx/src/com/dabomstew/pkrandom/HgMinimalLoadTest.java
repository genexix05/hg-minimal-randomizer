package com.dabomstew.pkrandom;

import com.dabomstew.pkrandom.pokemon.Encounter;
import com.dabomstew.pkrandom.pokemon.EncounterSet;
import com.dabomstew.pkrandom.pokemon.Pokemon;
import com.dabomstew.pkrandom.romhandlers.Gen4RomHandler;

import java.io.File;
import java.util.List;
import java.util.Random;

/**
 * Smoke tests for HeartGold Minimal support.
 *
 * Args:
 *   <rom.nds>                  -> load only
 *   <rom.nds> wild <out.nds>   -> try wild randomization + save
 */
public class HgMinimalLoadTest {
    public static void main(String[] args) {
        if (args.length < 1) {
            System.err.println("Usage: HgMinimalLoadTest <rom.nds> [wild <out.nds>]");
            System.exit(2);
        }
        String romPath = args[0];
        if (!new File(romPath).isFile()) {
            System.err.println("ROM not found: " + romPath);
            System.exit(2);
        }

        boolean doWild = args.length >= 3 && "wild".equalsIgnoreCase(args[1]);
        String outPath = doWild ? args[2] : null;

        System.out.println("Loading: " + romPath);
        Gen4RomHandler handler = new Gen4RomHandler(new Random(12345));
        try {
            boolean ok = handler.loadRom(romPath);
            if (!ok) {
                System.err.println("FAIL: detectNDSRom rejected the file");
                System.exit(1);
            }
            List<Pokemon> pokes = handler.getPokemon();
            int nonNull = 0;
            for (Pokemon p : pokes) {
                if (p != null) {
                    nonNull++;
                }
            }
            System.out.println("OK: ROM loaded");
            System.out.println("Pokemon list size: " + pokes.size());
            System.out.println("Non-null species: " + nonNull);
            if (pokes.size() > 1 && pokes.get(1) != null) {
                System.out.println("Species #1: " + pokes.get(1).name
                        + " types=" + pokes.get(1).primaryType
                        + (pokes.get(1).secondaryType != null ? "/" + pokes.get(1).secondaryType : ""));
            }
            if (pokes.size() > 25 && pokes.get(25) != null) {
                System.out.println("Species #25: " + pokes.get(25).name
                        + " evolutionsFrom=" + pokes.get(25).evolutionsFrom.size());
            }

            if (doWild) {
                System.out.println("Reading wild encounters...");
                List<EncounterSet> areas = handler.getEncounters(true);
                System.out.println("Encounter areas: " + (areas == null ? "null" : areas.size()));
                if (areas != null && !areas.isEmpty()) {
                    EncounterSet a0 = areas.get(0);
                    System.out.println("Area0 rate=" + a0.rate + " encounters=" + a0.encounters.size()
                            + (a0.encounters.isEmpty() ? "" : (" first=" + a0.encounters.get(0).pokemon.name)));
                }

                System.out.println("Shuffling wild encounters...");
                Random rnd = new Random(999);
                int swapped = 0;
                for (EncounterSet area : areas) {
                    List<Encounter> encs = area.encounters;
                    for (int i = 0; i < encs.size(); i++) {
                        int j = rnd.nextInt(encs.size());
                        Pokemon tmp = encs.get(i).pokemon;
                        encs.get(i).pokemon = encs.get(j).pokemon;
                        encs.get(j).pokemon = tmp;
                        swapped++;
                    }
                }
                System.out.println("Touches: " + swapped);
                handler.setEncounters(true, areas);
                System.out.println("Saving to: " + outPath);
                boolean saved = handler.saveRomFile(outPath, 12345L);
                System.out.println(saved ? "OK: saved" : "FAIL: saveRomFile returned false");
                if (!saved) {
                    System.exit(1);
                }
            }

            System.exit(0);
        } catch (Throwable t) {
            System.err.println("FAIL: exception");
            t.printStackTrace(System.err);
            System.exit(1);
        }
    }
}
