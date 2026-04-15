# ================================================
#  SDH UNIVERSAL PROJEKT SETUP
#  WordPress, React, Laravel, sima HTML — bármi
#  Terminálba bedobod, végigvezet mindenen.
#
#  Futtatás:
#  powershell -ExecutionPolicy Bypass -File "C:\Users\SDH\tools\setup-projekt.ps1"
# ================================================

Clear-Host
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  SDH PROJEKT SETUP" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

# ── 0. ÉLŐS VAGY LOKÁLIS? ─────────────────────────────────────────────────────

Write-Host "Ez a projekt hol fut majd élesben?" -ForegroundColor Yellow
Write-Host "  [0] Csak lokális — Windowson dolgozom, nincs élő szerver  ← ENTER" -ForegroundColor Green
Write-Host "  [1] Élő szerver is van — pushkor auto-deploy FTP-n" -ForegroundColor White
$elesValasztas = Read-Host "Szám (ENTER = 0)"
if ([string]::IsNullOrWhiteSpace($elesValasztas)) { $elesValasztas = "0" }
$elesDeployKell = ($elesValasztas -eq "1")

$ftpServer = $ftpUser = $ftpPass = $ftpDir = ""
$ftpStagingServer = $ftpStagingUser = $ftpStagingPass = $ftpStagingDir = ""
$stagingKell = $false
$branchingKell = $false

if ($elesDeployKell) {
    Write-Host ""
    Write-Host "FTP adatok — ÉLES szerver:" -ForegroundColor Yellow
    $ftpServer = Read-Host "  FTP szerver (pl. ftp.sdh.hu)"
    $ftpUser   = Read-Host "  FTP felhasználónév"
    $ftpPass   = Read-Host "  FTP jelszó"
    $ftpDir    = Read-Host "  FTP célmappa (pl. /public_html/wp-content/themes/bricks-child/)"

    Write-Host ""
    Write-Host "Kell staging környezet? (tesztelés élesítés előtt)" -ForegroundColor Yellow
    Write-Host "  [0] Nem kell" -ForegroundColor White
    Write-Host "  [1] Igen — legyen külön staging szerver (pl. staging.sdh.hu)" -ForegroundColor White
    $stagingValasztas = Read-Host "Szám"
    $stagingKell = ($stagingValasztas -eq "1")

    if ($stagingKell) {
        Write-Host ""
        Write-Host "FTP adatok — STAGING szerver:" -ForegroundColor Yellow
        $ftpStagingServer = Read-Host "  FTP szerver (pl. ftp.sdh.hu — ugyanaz lehet)"
        $ftpStagingUser   = Read-Host "  FTP felhasználónév"
        $ftpStagingPass   = Read-Host "  FTP jelszó"
        $ftpStagingDir    = Read-Host "  FTP célmappa (pl. /public_html/staging/)"
    }
    Write-Host ""
}

Write-Host "Több fejlesztő dolgozik a projekten?" -ForegroundColor Yellow
Write-Host "  [0] Nem — csak én  ← ENTER" -ForegroundColor Green
Write-Host "  [1] Igen — legyen branching stratégia (main/staging/develop)" -ForegroundColor White
$branchingValasztas = Read-Host "Szám (ENTER = 0)"
if ([string]::IsNullOrWhiteSpace($branchingValasztas)) { $branchingValasztas = "0" }
$branchingKell = ($branchingValasztas -eq "1")
Write-Host ""

# ── 1. Projekt típus ─────────────────────────────────────────────────────────

Write-Host "Milyen projekten dolgozol?" -ForegroundColor Yellow
Write-Host "  [0] WordPress" -ForegroundColor White
Write-Host "  [1] HTML / CSS / JS (statikus)" -ForegroundColor White
Write-Host "  [2] React / Vue / Node.js" -ForegroundColor White
Write-Host "  [3] Laravel / PHP" -ForegroundColor White
Write-Host "  [4] Egyéb / bármi más" -ForegroundColor White
$tipusValasztas = Read-Host "Szám"

# ── 1b. GitHub URL (korán kérdezzük, hogy a mappa javaslathoz felhasználhassuk) ──

Write-Host "`nGitHub repo URL? (ENTER = kihagyom)" -ForegroundColor Yellow
Write-Host "  pl. https://github.com/koltainorbert/ujprojekt" -ForegroundColor DarkGray
$githubUrl = Read-Host "GitHub URL"
if ($githubUrl -and $githubUrl -notmatch '^https?://') { $githubUrl = "https://$githubUrl" }
if ($githubUrl -and $githubUrl -notmatch '\.git$') { $githubUrl = "$githubUrl.git" }

# Repo névből javasolt mappa
$repoNev = ""
if (-not [string]::IsNullOrWhiteSpace($githubUrl)) {
    $repoNev = ($githubUrl -replace '\.git$','') -replace '.+/',''
}

# ── 2. Projekt mappa ─────────────────────────────────────────────────────────

Write-Host "`nHol van a projekt gyökér mappája?" -ForegroundColor Yellow

switch ($tipusValasztas) {
    "0" {
        Write-Host "  pl. D:\LocalWP\sdh2026\app\public\wp-content\themes\bricks-child" -ForegroundColor DarkGray
        Write-Host "  ENTER = automatikus keresés D:\LocalWP-ben" -ForegroundColor DarkGray
        $projektMappa = Read-Host "Mappa"
        if ([string]::IsNullOrWhiteSpace($projektMappa)) {
            $temak = Get-ChildItem "D:\LocalWP" -Recurse -Filter "themes" -Directory -ErrorAction SilentlyContinue | Select-Object -First 5
            if ($temak.Count -ge 1) {
                $egyTemak = @()
                foreach ($t in $temak) {
                    $egyTemak += Get-ChildItem $t.FullName -Directory | Where-Object { $_.Name -notmatch "^twenty" }
                }
                Write-Host "`nElérhető témák:" -ForegroundColor Yellow
                for ($i = 0; $i -lt $egyTemak.Count; $i++) {
                    Write-Host "  [$i] $($egyTemak[$i].FullName)" -ForegroundColor White
                }
                $tv = Read-Host "Szám"
                $projektMappa = $egyTemak[[int]$tv].FullName
            } else {
                Write-Host "Nem találtam témát. Add meg manuálisan." -ForegroundColor Red
                exit 1
            }
        }
    }
    default {
        if ($repoNev) {
            $javasolt = "C:\Users\$env:USERNAME\projektek\$repoNev"
            Write-Host "  Javaslat (repo alapjan): $javasolt" -ForegroundColor Green
            Write-Host "  ENTER = ezt hasznalja, vagy irj mas eleresi utat" -ForegroundColor DarkGray
        } else {
            Write-Host "  pl. D:\projektek\ujoldal" -ForegroundColor DarkGray
            Write-Host "  pl. C:\Users\SDH\Documents\react-app" -ForegroundColor DarkGray
        }
        $projektMappa = Read-Host "Mappa"
        if ([string]::IsNullOrWhiteSpace($projektMappa)) {
            $projektMappa = if ($repoNev) { "C:\Users\$env:USERNAME\projektek\$repoNev" } else { Get-Location }
        }
    }
}

if (-not (Test-Path $projektMappa)) {
    Write-Host "Nem létezik: $projektMappa — létrehozom." -ForegroundColor Yellow
    New-Item -ItemType Directory -Force -Path $projektMappa | Out-Null
}

Set-Location $projektMappa
New-Item -ItemType Directory -Force -Path ".vscode" | Out-Null
New-Item -ItemType Directory -Force -Path ".github" | Out-Null

# ── 3. Site URL / port ────────────────────────────────────────────────────────

Write-Host "`nMi az oldal URL-je vagy dev szervere?" -ForegroundColor Yellow
switch ($tipusValasztas) {
    "0" { Write-Host "  pl. sdh2026.local   VAGY   https://sdh.hu" -ForegroundColor DarkGray }
    "1" { Write-Host "  pl. . (pont = jelenlegi mappa, statikus fájlok)" -ForegroundColor DarkGray }
    "2" { Write-Host "  pl. localhost:5173   VAGY   localhost:3000" -ForegroundColor DarkGray }
    "3" { Write-Host "  pl. localhost:8000   VAGY   sajatoldal.test" -ForegroundColor DarkGray }
    default { Write-Host "  pl. localhost:3000" -ForegroundColor DarkGray }
}
$siteUrl = (Read-Host "URL").TrimEnd("/")
if ([string]::IsNullOrWhiteSpace($siteUrl)) { $siteUrl = "localhost:3000" }
$proxyUrl = $siteUrl -replace "^https?://", ""

# Browser Sync mód: proxy vagy statikus
$bsCommand = if ($tipusValasztas -eq "1") {
    "npx browser-sync start --server --files '**/*.css,**/*.html,**/*.js' --port 3000 --open"
} else {
    "npx browser-sync start --proxy '$proxyUrl' --files '**/*.css,**/*.php,**/*.js,**/*.html' --port 3000 --open"
}

# ── 4. GitHub — már megvan fentről ───────────────────────────────────────────

# ── 5. Fájlok létrehozása ─────────────────────────────────────────────────────

Write-Host "`n[1/5] VS Code tasks..." -ForegroundColor Yellow
@"
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "⬆ Push (feltöltés GitHubra)",
      "type": "shell",
      "command": "git add . ; `$d = git diff --cached --quiet ; if (`$LASTEXITCODE -ne 0) { `$msg = 'Mentes_' + (Get-Date -Format 'yyyy.MM.dd_HH.mm') ; git commit -m `$msg ; git push ; Write-Host 'Kesz!' ; Start-Process powershell -WindowStyle Hidden -ArgumentList '-ExecutionPolicy','Bypass','-File','.vscode\\notify.ps1','-Type','push-ok','-Message',`$msg } else { Write-Host 'Nincs valtozas.' ; Start-Process powershell -WindowStyle Hidden -ArgumentList '-ExecutionPolicy','Bypass','-File','.vscode\\notify.ps1','-Type','no-change' }",
      "options": { "cwd": "`${workspaceFolder}" },
      "group": { "kind": "build", "isDefault": true },
      "presentation": { "reveal": "always", "panel": "shared", "clear": true },
      "problemMatcher": []
    },
    {
      "label": "↩ Visszagörgetés (undo napra/verzióra)",
      "type": "shell",
      "command": "powershell -ExecutionPolicy Bypass -Command \"`$commits = git log --oneline -20; `$i=0; `$lista = `$commits | ForEach-Object { `$i++; \"[`$i] `$_\" }; `$lista; `$v = Read-Host 'Melyik verzióhoz mész vissza? (szám)'; `$hash = (`$commits[([int]`$v)-1] -split ' ')[0]; Write-Host \"Visszaállítás: `$hash\" -ForegroundColor Yellow; `$mod = Read-Host 'Biztosan? (i/n)'; if (`$mod -eq 'i') { git checkout `$hash -- . ; git add . ; git commit -m \"Visszaallitas `$hash – `$(Get-Date -Format 'yyyy.MM.dd HH:mm')\" ; Write-Host 'Kész!' -ForegroundColor Green } else { Write-Host 'Megszakítva.' -ForegroundColor Red }\"",
      "options": { "cwd": "`${workspaceFolder}" },
      "group": "none",
      "presentation": { "reveal": "always", "panel": "shared", "clear": true },
      "problemMatcher": []
    },
    {
      "label": "⬇ Pull (letöltés GitHubról)",
      "type": "shell",
      "command": "git pull ; Write-Host 'Kesz!' ; Start-Process powershell -WindowStyle Hidden -ArgumentList '-ExecutionPolicy','Bypass','-File','.vscode\\notify.ps1','-Type','pull-ok'",
      "options": { "cwd": "`${workspaceFolder}" },
      "group": "none",
      "presentation": { "reveal": "always", "panel": "shared", "clear": true },
      "problemMatcher": []
    },
    {
      "label": "▶ Napló Watcher (auto-napló + auto-push)",
      "type": "shell",
      "command": "powershell -ExecutionPolicy Bypass -File .vscode/naplo-watcher.ps1",
      "options": { "cwd": "`${workspaceFolder}" },
      "group": "none",
      "isBackground": true,
      "runOptions": { "runOn": "folderOpen" },
      "presentation": { "reveal": "silent", "panel": "dedicated", "clear": true },
      "problemMatcher": []
    },
    {
      "label": "🌐 Browser Sync",
      "type": "shell",
      "command": "$bsCommand",
      "options": { "cwd": "`${workspaceFolder}" },
      "group": "none",
      "isBackground": true,
      "presentation": { "reveal": "always", "panel": "dedicated" },
      "problemMatcher": []
    }
  ]
}
"@ | Set-Content ".vscode/tasks.json" -Encoding UTF8

Write-Host "[2/5] Notify popup script..." -ForegroundColor Yellow
$notifyUrl = "https://raw.githubusercontent.com/koltainorbert/VisualCode-Munkakornyezet/main/.vscode/notify.ps1"
try {
    Invoke-WebRequest $notifyUrl -OutFile ".vscode\notify.ps1" -Encoding UTF8 -ErrorAction Stop
    Write-Host "  notify.ps1 letoltve OK" -ForegroundColor Green
} catch {
    Write-Host "  notify.ps1 letoltes sikertelen (offline?) — kihagyva" -ForegroundColor Yellow
}

$notifyUpdateUrl = "https://raw.githubusercontent.com/koltainorbert/VisualCode-Munkakornyezet/main/.vscode/update-notify.ps1"
try {
    Invoke-WebRequest $notifyUpdateUrl -OutFile ".vscode\update-notify.ps1" -Encoding UTF8 -ErrorAction Stop
} catch { }


Write-Host "[3/5] Napló watcher script..." -ForegroundColor Yellow
@'
$temaMappa = (Get-Location).Path
$naplo = "$temaMappa\NAPLO.md"
Write-Host "Naplo watcher elindult..." -ForegroundColor Green
$utolso = ""
while ($true) {
    $most  = Get-Date
    $datum = $most.ToString("yyyy. MMMM dd.")
    $ido   = $most.ToString("HH:mm")
    $fajlok = @(git diff --name-only HEAD 2>$null) + @(git ls-files --others --exclude-standard 2>$null) | Where-Object { $_ -ne "" }
    if ($fajlok.Count -gt 0) {
        $sor = "$ido — $($fajlok -join ', ')"
        if ($sor -ne $utolso) {
            $utolso = $sor
            $tartalom = Get-Content $naplo -Raw -Encoding UTF8
            if ($tartalom -match [regex]::Escape("## $datum")) {
                $tartalom = $tartalom -replace "(?m)(## $([regex]::Escape($datum))[\s\S]*?)(---)", "`$1- $sor`n`$2"
            } else {
                $tartalom += "`n## $datum`n`n### Valtozasok:`n- $sor`n`n---`n"
            }
            Set-Content $naplo $tartalom -Encoding UTF8
            git add .
            git diff --cached --quiet
            if ($LASTEXITCODE -ne 0) {
                git commit -m "Auto $ido — $($fajlok -join ', ')"
                git push
                Write-Host "[$ido] Pushed: $($fajlok -join ', ')" -ForegroundColor Green
            }
        }
    } else {
        Write-Host "[$ido] Nincs valtozas." -ForegroundColor DarkGray
    }
    Start-Sleep -Seconds 60
}
'@ | Set-Content ".vscode/naplo-watcher.ps1" -Encoding UTF8

Write-Host "[3/5] NAPLO.md..." -ForegroundColor Yellow
@"
# Fejlesztési Napló

---

## $(Get-Date -Format 'yyyy. MMMM dd.')

### Ma elvégezve:
- Projekt beállítás, munkakörnyezet felállítva

### Holnap folytatás:
-

### Nyitott TODO-k:
- [ ]

---
"@ | Set-Content "NAPLO.md" -Encoding UTF8

Write-Host "[4/6] GitHub Actions deploy workflow..." -ForegroundColor Yellow
New-Item -ItemType Directory -Force -Path ".github/workflows" | Out-Null
if ($elesDeployKell) {
    # ÉLES deploy workflow (main branch)
@"
name: Deploy ÉLES szerverre (FTP)
on:
  push:
    branches: [ main ]
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: FTP Deploy – Éles
        uses: SamKirkland/FTP-Deploy-Action@v4.3.5
        with:
          server: `${{ secrets.FTP_SERVER }}
          username: `${{ secrets.FTP_USERNAME }}
          password: `${{ secrets.FTP_PASSWORD }}
          server-dir: `${{ secrets.FTP_SERVER_DIR }}
          exclude: |
            **/.git*/**
            **/.vscode/**
            **/NAPLO.md
            **/NAPI-MUNKAREND.txt
"@ | Set-Content ".github/workflows/deploy-production.yml" -Encoding UTF8

    # STAGING deploy workflow (staging branch)
    if ($stagingKell) {
@"
name: Deploy STAGING szerverre (FTP)
on:
  push:
    branches: [ staging ]
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: FTP Deploy – Staging
        uses: SamKirkland/FTP-Deploy-Action@v4.3.5
        with:
          server: `${{ secrets.FTP_STAGING_SERVER }}
          username: `${{ secrets.FTP_STAGING_USERNAME }}
          password: `${{ secrets.FTP_STAGING_PASSWORD }}
          server-dir: `${{ secrets.FTP_STAGING_DIR }}
          exclude: |
            **/.git*/**
            **/.vscode/**
            **/NAPLO.md
            **/NAPI-MUNKAREND.txt
"@ | Set-Content ".github/workflows/deploy-staging.yml" -Encoding UTF8
    }

    # GitHub Secrets beállítása
    $ghCheck = Get-Command gh -ErrorAction SilentlyContinue
    if ($ghCheck -and -not [string]::IsNullOrWhiteSpace($githubUrl)) {
        $repoPath = $githubUrl -replace "https://github.com/","" -replace "\.git$",""
        gh secret set FTP_SERVER     --body $ftpServer --repo $repoPath 2>$null
        gh secret set FTP_USERNAME   --body $ftpUser   --repo $repoPath 2>$null
        gh secret set FTP_PASSWORD   --body $ftpPass   --repo $repoPath 2>$null
        gh secret set FTP_SERVER_DIR --body $ftpDir    --repo $repoPath 2>$null
        if ($stagingKell) {
            gh secret set FTP_STAGING_SERVER   --body $ftpStagingServer --repo $repoPath 2>$null
            gh secret set FTP_STAGING_USERNAME --body $ftpStagingUser   --repo $repoPath 2>$null
            gh secret set FTP_STAGING_PASSWORD --body $ftpStagingPass   --repo $repoPath 2>$null
            gh secret set FTP_STAGING_DIR      --body $ftpStagingDir    --repo $repoPath 2>$null
        }
        Write-Host "  GitHub Secrets beállítva automatikusan!" -ForegroundColor Green
    } else {
        Write-Host ""
        Write-Host "  !! Kézzel add meg a GitHub Secrets-t:" -ForegroundColor Yellow
        Write-Host "  github.com → repo → Settings → Secrets → Actions" -ForegroundColor DarkGray
        Write-Host "  FTP_SERVER=$ftpServer | FTP_USERNAME=$ftpUser | FTP_SERVER_DIR=$ftpDir" -ForegroundColor White
        if ($stagingKell) {
            Write-Host "  FTP_STAGING_SERVER=$ftpStagingServer | FTP_STAGING_DIR=$ftpStagingDir" -ForegroundColor White
        }
        Write-Host ""
    }
} else {
    Write-Host "  Csak lokális projekt — deploy kihagyva." -ForegroundColor DarkGray
}

Write-Host "[5/6] VS Code beállítások (auto-task engedélyezés)..." -ForegroundColor Yellow
@"
{
  "task.allowAutomaticTasks": "on"
}
"@ | Set-Content ".vscode/settings.json" -Encoding UTF8

Write-Host "[6/7] Copilot instrukciók..." -ForegroundColor Yellow
@"
# Copilot Instrukciók

## URL: $siteUrl
## GitHub: $githubUrl

## Minden munkamenet ELEJÉN (kötelező, automatikus):
1. Olvasd el a NAPLO.md teljes utolsó bejegyzését
2. Mondd el hol tartott legutóbb és mi volt nyitott
3. Kérdezd meg mi a mai cél

## Minden munkamenet VÉGÉN (kötelező, automatikus — NEM KELL KÉRNI):
1. Írj részletes bejegyzést a NAPLO.md-be:
   - Dátum fejléc, mit csináltunk [x], hol tartunk, nyitott TODO-k [ ]
2. Emlékeztess: Ctrl+Shift+B = push

## TODO: [x] = kész, [ ] = nyitott

## SDH Design szabályok (ha frontend):
- color:#fff, accent: #ff0000, háttér: rgb(6,6,6) + dot grid
- Corner cut: ::after linear-gradient(225deg,#ff0000 50%,transparent 50%)
- CSS prefix egyedi oldalanként, min-height:100vh minden wrapper-en
"@ | Set-Content ".github/copilot-instructions.md" -Encoding UTF8

Write-Host "[7/7] NAPI-MUNKAREND.txt..." -ForegroundColor Yellow
@"
========================================
  NAPI MUNKAREND
========================================
REGGEL:
  1. VS Code megnyit → watcher auto-indul
  2. Ctrl+Shift+P → Run Task → ⬇ Pull
  3. Ctrl+Shift+P → Run Task → 🌐 Browser Sync
     Live: http://localhost:3000

ESTE:
  Ctrl+Shift+B = Push GitHubra

!! EGYSZER (első megnyitáskor):
  Ctrl+Shift+P → Manage Automatic Tasks → Allow
========================================
"@ | Set-Content "NAPI-MUNKAREND.txt" -Encoding UTF8

# ── 6. Git ────────────────────────────────────────────────────────────────────

Write-Host "`n[GIT] Inicializálás..." -ForegroundColor Yellow
if (-not (Test-Path ".git")) { git init }
git config user.name "koltainorbert"
git config user.email "koltainorbert@users.noreply.github.com"
git add .
git commit -m "Projekt setup – initial commit"

if (-not [string]::IsNullOrWhiteSpace($githubUrl)) {
    git branch -M main
    $remoteCheck = git remote 2>$null
    if ($remoteCheck -notcontains "origin") { git remote add origin $githubUrl }
    git pull origin main --allow-unrelated-histories 2>$null
    git push -u origin main

    if ($stagingKell -or $branchingKell) {
        Write-Host "`n[BRANCH] Branch stratégia beállítása..." -ForegroundColor Yellow
        # staging branch
        git checkout -b staging
        git push -u origin staging
        Write-Host "  staging branch létrehozva → deploy-staging.yml figyeli" -ForegroundColor Green
        # develop branch (ha többen dolgoznak)
        if ($branchingKell) {
            git checkout -b develop
            git push -u origin develop
            Write-Host "  develop branch létrehozva → itt fejlesztesz, staging-be merge-lsz" -ForegroundColor Green
        }
        # vissza a main-re
        git checkout main

        Write-Host ""
        Write-Host "  Branch munkafolyamat:" -ForegroundColor Cyan
        if ($branchingKell) {
            Write-Host "  develop  → itt fejlesztesz" -ForegroundColor White
            Write-Host "  staging  → tesztelés (staging.sdh.hu-n jelenik meg)" -ForegroundColor White
            Write-Host "  main     → éles (sdh.hu-n jelenik meg)" -ForegroundColor White
            Write-Host ""
            Write-Host "  Parancsok:" -ForegroundColor DarkGray
            Write-Host "  git checkout develop        # fejlesztés" -ForegroundColor DarkGray
            Write-Host "  git merge develop staging   # tesztelésre" -ForegroundColor DarkGray
            Write-Host "  git merge staging main      # élesítés" -ForegroundColor DarkGray
        } else {
            Write-Host "  staging  → tesztelés (staging szerveren jelenik meg)" -ForegroundColor White
            Write-Host "  main     → éles (push = deploy élesre)" -ForegroundColor White
        }
    } else {
        Write-Host "  GitHub push kész!" -ForegroundColor Green
    }
}

# ── Task Scheduler (biztonsági auto-mentés) ───────────────────────────────────

Write-Host "`n[BIZTONSÁGI MENTÉS] Task Scheduler beállítása..." -ForegroundColor Yellow
$scriptPath = "$projektMappa\.vscode\naplo-watcher-bg.ps1"

# Background verzió (ablak nélkül, VS Code-tól független)
@"
Set-Location "$projektMappa"
`$naplo = "$projektMappa\NAPLO.md"
`$ido = Get-Date -Format 'HH:mm:ss'
`$fajlok = @(git diff --name-only HEAD 2>`$null) + @(git ls-files --others --exclude-standard 2>`$null) | Where-Object { `$_ -ne "" }
if (`$fajlok.Count -gt 0) {
    git add .
    git diff --cached --quiet
    if (`$LASTEXITCODE -ne 0) {
        git commit -m "AutoSave `$ido — `$(`$fajlok -join ', ')"
        git push 2>`$null
    }
}
"@ | Set-Content $scriptPath -Encoding UTF8

$taskName = "SDH-AutoSave-$(Split-Path $projektMappa -Leaf)"
Start-Process powershell -Verb RunAs -ArgumentList @"
-ExecutionPolicy Bypass -Command "
Unregister-ScheduledTask -TaskName '$taskName' -Confirm:`$false -ErrorAction SilentlyContinue;
`$a = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument '-ExecutionPolicy Bypass -WindowStyle Hidden -File ""$scriptPath""';
`$t1 = New-ScheduledTaskTrigger -AtLogOn;
`$t2 = New-ScheduledTaskTrigger -RepetitionInterval (New-TimeSpan -Minutes 5) -Once -At (Get-Date);
`$s = New-ScheduledTaskSettingsSet -StartWhenAvailable -ExecutionTimeLimit (New-TimeSpan -Minutes 2);
Register-ScheduledTask -TaskName '$taskName' -Action `$a -Trigger `$t1 -Settings `$s -RunLevel Highest -Force;
Write-Host 'Task beregisztralva!'; Start-Sleep 2"
"@ -Wait -WindowStyle Normal

# ── Kész ──────────────────────────────────────────────────────────────────────

Write-Host "`n========================================" -ForegroundColor Green
Write-Host "  KÉSZ! Indulhatsz dolgozni." -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host "  Projekt:      $projektMappa" -ForegroundColor White
Write-Host "  URL:          $siteUrl" -ForegroundColor White
if (-not [string]::IsNullOrWhiteSpace($githubUrl)) {
    Write-Host "  GitHub:       $githubUrl" -ForegroundColor White
}
Write-Host ""
Write-Host "  Ctrl+Shift+B         = Push GitHubra" -ForegroundColor Cyan
Write-Host "  Pull Task            = Letöltés" -ForegroundColor Cyan
Write-Host "  Browser Sync Task    = Live preview" -ForegroundColor Cyan
Write-Host "  Auto-mentés          = 5 percenként (Task Scheduler)" -ForegroundColor Cyan
Write-Host ""
Write-Host "  Auto-task watcher     = automatikusan engedélyezve" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Green

Write-Host "VS Code megnyitasa: $projektMappa" -ForegroundColor Cyan
Start-Sleep -Seconds 1
$vscodePaths = @(
    "$env:LOCALAPPDATA\Programs\Microsoft VS Code\Code.exe",
    "C:\Program Files\Microsoft VS Code\Code.exe",
    "C:\Program Files (x86)\Microsoft VS Code\Code.exe"
)
$vscodeExe = $vscodePaths | Where-Object { Test-Path $_ } | Select-Object -First 1
if ($vscodeExe) {
    Start-Process $vscodeExe $projektMappa
} elseif (Get-Command code -ErrorAction SilentlyContinue) {
    code $projektMappa
} else {
    Write-Host "VS Code nem talalhato. Nyisd meg manualisan: $projektMappa" -ForegroundColor Yellow
}
