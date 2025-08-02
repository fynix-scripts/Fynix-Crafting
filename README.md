# Fynix Crafting Script

Et crafting-script til FiveM, der understøtter ESX (gammel og ny) og QBCore. Brugere kan åbne en crafting-menu via en ped og lave crafting af våben og tilbehør, hvis de har de nødvendige materialer og det rette job.

---

## Funktioner

- Understøtter ESX (både gamle og nye versioner) og QBCore frameworks.
- Crafting-menu med kategorier og items.
- Tjekker om spiller har det korrekte job for adgang til crafting-stationen.
- Tjekker om spiller har de nødvendige materialer.
- Progress circle under crafting.
- Notifikationer via `ox_lib`.
- Bruger `ox_target` til interaktion med ped.
- Server- og client-side scripts med korrekt job-opdatering.

---

## Krav

- FiveM server med enten ESX (gammel eller ny) eller QBCore.
- Despendencies: [`ox_lib`](https://github.com/overextended/ox_lib), [`ox_target`](https://github.com/overextended/ox_target)
- Konfigureret `Config` med nødvendige værdier''.

---

## Installation

1. Download og placer `fynix_crafting` mappen i din `resources` mappe på din server.
2. Tilføj `ensure fynix_crafting` i din `server.cfg`.
3. Sørg for at `ox_lib` og `ox_target` er installeret og startes før `fynix_crafting`.
4. Tilpas `config.lua` med dine crafting-oplysninger og jobs.

---

## Konfiguration (`config.lua`)
