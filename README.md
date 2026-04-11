# VS Code Fejlesztői Munkaközeg

**Teljes professzionális fejlesztői workflow** – GitHub sync, auto-mentés, FTP deploy, visszagörgetés, branch rendszer.

## Mi van itt?

| Fájl | Leírás |
|------|--------|
| `DEV-RENDSZER.html` | **Nyisd meg ezt!** Animált dashboard – minden benne, scriptek letölthetők |
| `setup-projekt.ps1` | Új projektet állít fel automatikusan (WordPress/HTML/React/Laravel) |
| `.vscode/tasks.json` | VS Code task template (Push, Pull, Watcher, Browser Sync, Branch) |
| `.vscode/naplo-watcher.ps1` | Percenkénti auto-push script (VS Code háttérben) |
| `.vscode/autosave-background.ps1` | Task Scheduler script (VS Code nélkül, 5 percenként) |
| `.vscode/install-autosave-task.ps1` | Task Scheduler regisztrálása (egyszer, adminként) |
| `.github/workflows/deploy.yml` | FTP auto-deploy template (GitHub Actions) |

## Gyors indítás – új projektre

```powershell
# 1. Klónozd le ezt a repót
git clone https://github.com/koltainorbert/VisualCode-Munkakornyezet.git
cd VisualCode-Munkakornyezet

# 2. Futtasd a setup scriptet (megkérdez mindent)
powershell -ExecutionPolicy Bypass -File setup-projekt.ps1
```

A script felállítja:
- Git + GitHub kapcsolat
- VS Code tasks (Ctrl+Shift+B = push)
- Percenkénti auto-mentés watcher
- Windows Task Scheduler (VS Code nélkül is ment)
- FTP deploy workflow (opcionális)
- Branch rendszer (develop / staging / main)
- NAPLO.md fejlesztési napló

## Meglévő projektbe illesztés

```powershell
# Másold be a .vscode/ mappát a projekted gyökerébe
# Szerkeszd meg a naplo-watcher.ps1-ben a $temaMappa változót
# Ctrl+Shift+P → Manage Automatic Tasks → Allow
```

## DEV-RENDSZER.html

Egyszerűen nyisd meg böngészőben – minden benne van:
- Animált CI/CD pipeline diagram
- Lépésről lépésre útmutató
- Minden script másolható / letölthető

## GitHub

[koltainorbert/VisualCode-Munkakornyezet](https://github.com/koltainorbert/VisualCode-Munkakornyezet)

---
*Felépítve: 2026. április 11. | SDH2026 projekt alapján*
