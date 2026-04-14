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

## 2026. április 14.

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
