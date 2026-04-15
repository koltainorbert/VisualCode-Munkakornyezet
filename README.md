# VS Code Fejlesztői Munkaközeg
### One-command VS Code Developer Environment Setup Wizard

> **HU:** Egy parancs — és a teljes fejlesztői környezet kész. Git, auto-mentés, Browser Sync, FTP deploy, branch rendszer, visszagörgetés.
>
> **EN:** One command sets up your entire VS Code development environment. Git, auto-save, Browser Sync, FTP deploy, branch strategy, rollback — everything automated.

---

## 🚀 Gyors indítás / Quick Start

**PowerShell-be másold be és futtasd:**

```powershell
irm "https://raw.githubusercontent.com/koltainorbert/VisualCode-Munkakornyezet/main/setup-projekt.ps1" | iex
```

> Win+R → `powershell` → Enter → illeszd be → wizard elindul

Vagy nyisd meg: **[DEV-RENDSZER.html](https://koltainorbert.github.io/VisualCode-Munkakornyezet/)** — grafikus wizard, kérdések alapján generál mindent.

---

## Mit csinál? / What does it do?

| | Magyar | English |
|---|---|---|
| ⚡ | Projekt típus választás (WordPress, HTML, React, Vue, Laravel, Node.js, Python, Shopify) | Choose project type |
| 📁 | Mappa létrehozása, GitHub repo bekötése | Creates folder, connects GitHub repo |
| 🔄 | Git init + auto-push minden mentésnél | Git init + auto-push on every save |
| 🌐 | Browser Sync — azonnali live reload | Browser Sync live reload |
| 📅 | Task Scheduler — VS Code nélkül is menti | Task Scheduler backup even without VS Code |
| 🚀 | FTP auto-deploy GitHub push-kor | FTP auto-deploy on GitHub push |
| ↩ | Visszagörgetés az utolsó 20 verzió bármelyikére | Rollback to any of the last 20 versions |

---

## Fájlok / Files

| Fájl | Leírás |
|------|--------|
| `DEV-RENDSZER.html` | **Grafikus wizard dashboard** — nyisd meg böngészőben |
| `setup-projekt.ps1` | Projekt setup script (wizard futtat) |
| `.vscode/tasks.json` | VS Code task template |
| `.vscode/naplo-watcher.ps1` | Percenkénti auto-push (háttérben) |
| `.vscode/autosave-background.ps1` | Task Scheduler script (5 percenként) |

---

## Támogatott projekttípusok / Supported project types

`WordPress` · `HTML/CSS/JS` · `React/Next.js` · `Vue/Nuxt` · `Laravel/PHP` · `Node.js/Express` · `Python/Django/Flask` · `Shopify/WooCommerce` · `Egyéb`

---

*Készítette / Made by: [Koltai Norbert](https://www.infostudio.hu) · SDH Infostudio*

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
