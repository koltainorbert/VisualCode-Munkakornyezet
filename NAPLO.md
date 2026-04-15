# Fejlesztési napló

## Projekt indítása

Ez a napló automatikusan frissül a Napló Watcher script által.

---

## 2026. április 11.

### Változások:
- Repo létrehozva: koltainorbert/VisualCode-Munkakornyezet
- DEV-RENDSZER.html dashboard feltöltve
- Összes script és template fájl feltöltve

---

## 2026. április 15.

### Elvégezve: [x]
- [x] notify.ps1: WPF custom popup toast — dark #161616 háttér, színes ikon doboz, slide-down animáció jobb felülről
- [x] notify.ps1: Unicode ikonok [char] kóddal (PS5.1 kompatibilis): ↑ zöld push, ↓ kék pull, ~ sárga no-change, ☁ felhő ikon
- [x] notify.ps1: `$script:t` scope fix, 3.5 mp után auto fade-out + slide-up eltűnés
- [x] tasks.json: `-Type push-ok / pull-ok / no-change` paraméter — ékezetes szövegek a ps1-ben, nem az argumentumban
- [x] NAPI-MUNKAREND.txt: dátum fejléc hozzáadva
- [x] Git identity: koltainorbert / koltainorbert@users.noreply.github.com beállítva globálisan

### Értesítési rendszer összefoglalója:
| Esemény | Ikon | Szín | Szöveg |
|---|---|---|---|
| Push (változás volt) | ☁↑ | zöld | Push sikeres + commit neve |
| Push (nincs változás) | ~ | sárga | Nincs változás a munkában |
| Pull | ☁↓ | kék | Letöltés kész / GitHub szinkronizálva |

---



### Elvégezve: [x]
- [x] setup-projekt.ps1: `powershell -File` → `& script.ps1` (ugyanaz a PS session, automata)
- [x] setup-projekt.ps1: `code $projektMappa` a végén — VS Code auto megnyílik a helyes mappában
- [x] setup-projekt.ps1: `.vscode/settings.json` generálás `task.allowAutomaticTasks: on`
- [x] tasks.json Push task: `&&` → PS5.1 kompatibilis `;` + `if ($LASTEXITCODE)` logika
- [x] tasks.json commit üzenet: em dash + szóköz → `Mentes_yyyy.MM.dd_HH.mm` (git-safe)
- [x] DEV-RENDSZER.html: minden módnál frissített parancs (VS Code, Copilot, offline inline)
- [x] GitHub push: minden szinkronban

### Nyitott TODO-k: [ ]
- [ ] Teszt: setup-projekt.ps1 futtatása egy új projekt mappán — ellenőrizni hogy VS Code auto megnyílik

---

## 2026. április 17.

### Elvégezve: [x]
- [x] DEV-RENDSZER.html: Hero szekcióban Varázsparancs (`irm` parancssor) eltávolítva
- [x] DEV-RENDSZER.html: Hero szekcióba nagy animált "GRAFIKUS WIZARD INDÍTÁSA" gomb kerül
- [x] DEV-RENDSZER.html: Wizard Step 1 – 4 opcióról **8 opcióra** bővítve, tag badge-ekkel
- [x] wzSelOpt JS: `i<4` → `i<8`, placeholder tömb 8 elemre bővítve
- [x] CSS: `.wz-tags` és `.wz-tag` stílusok hozzáadva (kör badge-ek minden opción)

### Wizard projekt típusok (Step 1):
| # | Típus | Technológiák |
|---|---|---|
| 0 | WordPress | LocalWP, PHP, MySQL, WP-CLI |
| 1 | HTML / CSS / JS | Statikus, Browser Sync, SCSS, FTP |
| 2 | React / Vue / Node | Vite, NPM, HMR, localhost:5173 |
| 3 | Laravel / PHP | PHP 8+, Composer, MySQL, artisan |
| 4 | Next.js / Nuxt | Node, SSR, SSG, Vercel |
| 5 | Python / Django / Flask | Python 3, pip, venv, REST API |
| 6 | Electron / Tauri | Desktop, Chromium, Rust / Node |
| 7 | Egyéb / Saját | Git, Egyéni, Manuális |

---
