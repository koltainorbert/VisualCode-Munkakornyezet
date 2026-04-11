# ============================================================
#  VS CODE MUNKAKORNYEZET - VARAZS WIZARD v2.0
#
#  Hasznalat (PowerShell-ben):
#  irm "https://raw.githubusercontent.com/koltainorbert/VisualCode-Munkakornyezet/main/setup-projekt.ps1" | iex
#
#  Vagy ha mar klonoztal:
#  powershell -ExecutionPolicy Bypass -File setup-projekt.ps1
# ============================================================

function Show-Header {
    Clear-Host
    Write-Host ""
    Write-Host "  +==========================================+" -ForegroundColor Red
    Write-Host "  |   VS CODE MUNKAKORNYEZET WIZARD  v2.0   |" -ForegroundColor White
    Write-Host "  |   Automatikus teljes projekt beallitas   |" -ForegroundColor Gray
    Write-Host "  +==========================================+" -ForegroundColor Red
    Write-Host ""
    Write-Host "  WordPress, HTML, React, Vue, Node.js, Laravel - minden tipushoz" -ForegroundColor DarkGray
    Write-Host ""
}

function Kerd($kerdes, $def = "") {
    $p = if ($def) { "  >> $kerdes [$def]: " } else { "  >> $kerdes: " }
    Write-Host $p -ForegroundColor Yellow -NoNewline
    $v = Read-Host
    if ($v -eq "" -and $def) { return $def }
    return $v
}

function Lepas($n, $szoveg) {
    Write-Host ""
    Write-Host "  ------------------------------------------" -ForegroundColor DarkGray
    Write-Host "  LEPES $n  |  $szoveg" -ForegroundColor Cyan
    Write-Host "  ------------------------------------------" -ForegroundColor DarkGray
    Write-Host ""
}

function Ok($s)   { Write-Host "  [OK] $s" -ForegroundColor Green }
function Hiba($s) { Write-Host "  [!!] $s" -ForegroundColor Red }
function Info($s) { Write-Host "   >>  $s" -ForegroundColor DarkGray }

# ================================================================
Show-Header

# ── 1. PROJEKT ADATOK ───────────────────────────────────────────
Lepas "1/5" "PROJEKT ADATOK"

$projektNev = ""
while (-not $projektNev) {
    $projektNev = Kerd "Projekt neve (pl: WebshopProjekt, MyCoolSite)"
    if (-not $projektNev) { Hiba "A projekt neve kotelyezo!" }
}

$aktualis = (Get-Location).Path
$projektMappa = Kerd "Projekt mappa teljes eleresi ut" $aktualis
$githubUrl = Kerd "GitHub repo URL (hagy uresen ha meg nincs)" ""

# ── 2. PROJEKT TIPUSA ───────────────────────────────────────────
Lepas "2/5" "PROJEKT TIPUSA"

Write-Host "  [1] WordPress (LocalWP / WampServer / XAMPP)" -ForegroundColor White
Write-Host "  [2] HTML / CSS / JavaScript" -ForegroundColor White
Write-Host "  [3] React / Vue / Angular (npm alapu)" -ForegroundColor White
Write-Host "  [4] Node.js / Express" -ForegroundColor White
Write-Host "  [5] Laravel / PHP" -ForegroundColor White
Write-Host "  [6] Egyeb" -ForegroundColor DarkGray
Write-Host ""

$tipus = Kerd "Valasztas" "2"
$tipusMap = @{"1"="WordPress";"2"="HTML/CSS/JS";"3"="React/Vue";"4"="Node.js";"5"="Laravel";"6"="Egyeb"}
$tipusNev = $tipusMap[$tipus]
if (-not $tipusNev) { $tipusNev = "Egyeb" }
Ok "Kivalasztva: $tipusNev"

# ── 3. LIVE RELOAD ──────────────────────────────────────────────
Lepas "3/5" "LIVE RELOAD BEALLITASOK"

$bsPort = Kerd "Browser Sync port" "3000"
$proxyUrl = ""

if ($tipus -eq "1" -or $tipus -eq "5") {
    $proxyUrl = Kerd "Proxy URL (WordPress: myproject.local)" ""
}

if ($proxyUrl) {
    $bsCommand = "npx browser-sync start --proxy `"$proxyUrl`" --files `"**/*.css,**/*.php,**/*.js`" --port $bsPort"
    Info "Browser Sync: proxy mod -> $proxyUrl:$bsPort"
} else {
    $bsCommand = "npx browser-sync start --server --files `"**/*.css,**/*.html,**/*.js`" --port $bsPort"
    Info "Browser Sync: server mod -> localhost:$bsPort"
}

# ── 4. EXTRA OPCIOK ─────────────────────────────────────────────
Lepas "4/5" "EXTRA BEALLITASOK"

$ftpKell = Kerd "FTP auto-deploy GitHub Actions-szel? (i/n)" "n"
$taskSchedulerKell = Kerd "Windows Task Scheduler 5 perces auto-push (admin jog kell)? (i/n)" "i"
$branchKell = Kerd "Branch rendszer (develop / staging / main)? (i/n)" "i"

# ── 5. TELEPITES ────────────────────────────────────────────────
Lepas "5/5" "TELEPITES FOLYAMATBAN..."

# Mappa letrehozasa
if (-not (Test-Path $projektMappa)) {
    New-Item -ItemType Directory -Path $projektMappa -Force | Out-Null
    Ok "Mappa letrehozva: $projektMappa"
} else {
    Ok "Mappa mar letezik: $projektMappa"
}

Set-Location $projektMappa
New-Item -ItemType Directory -Path ".vscode" -Force | Out-Null
New-Item -ItemType Directory -Path ".github" -Force | Out-Null
if ($ftpKell -eq "i") {
    New-Item -ItemType Directory -Path ".github\workflows" -Force | Out-Null
}

# ── tasks.json ──────────────────────────────────────────────────
$tasksBase = @'
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "Push (feltoltes GitHubra)",
      "type": "shell",
      "command": "git add . && git diff --cached --quiet && echo 'Nincs valtozas.' || (git commit -m \"Mentes - $(Get-Date -Format 'yyyy.MM.dd HH:mm')\" && git push && echo 'Kesz!')",
      "options": { "cwd": "${workspaceFolder}" },
      "group": { "kind": "build", "isDefault": true },
      "presentation": { "reveal": "always", "panel": "shared", "clear": true },
      "problemMatcher": []
    },
    {
      "label": "Pull (letoltes GitHubrol)",
      "type": "shell",
      "command": "git pull && echo 'Frissites kesz!'",
      "options": { "cwd": "${workspaceFolder}" },
      "group": "none",
      "presentation": { "reveal": "always", "panel": "shared", "clear": true },
      "problemMatcher": []
    },
    {
      "label": "Visszagorgetees",
      "type": "shell",
      "command": "powershell -ExecutionPolicy Bypass -Command \"$c=git log --oneline -20;$i=0;$c|%{$i++;Write-Host \\\"[$i] $_\\\"};$v=Read-Host 'Sorszam';$h=($c[([int]$v)-1] -split ' ')[0];$m=Read-Host 'Visszaallitas $h ? (i/n)';if($m -eq 'i'){git checkout $h -- .;git add .;git commit -m \\\"Visszaallitas $h\\\";Write-Host 'Kesz!' -ForegroundColor Green}\"",
      "options": { "cwd": "${workspaceFolder}" },
      "group": "none",
      "presentation": { "reveal": "always", "panel": "shared", "clear": true },
      "problemMatcher": []
    },
    {
      "label": "Naplo Watcher",
      "type": "shell",
      "command": "powershell -ExecutionPolicy Bypass -File .vscode/naplo-watcher.ps1",
      "options": { "cwd": "${workspaceFolder}" },
      "group": "none",
      "isBackground": true,
      "runOptions": { "runOn": "folderOpen" },
      "presentation": { "reveal": "silent", "panel": "dedicated", "clear": true },
      "problemMatcher": []
    },
    {
      "label": "Browser Sync",
      "type": "shell",
      "command": "BS_CMD_PLACEHOLDER",
      "options": { "cwd": "${workspaceFolder}" },
      "group": "none",
      "isBackground": true,
      "presentation": { "reveal": "always", "panel": "dedicated", "clear": true },
      "problemMatcher": []
    },
    {
      "label": "Branch valtas",
      "type": "shell",
      "command": "powershell -ExecutionPolicy Bypass -Command \"Write-Host 'Branch:' (git branch --show-current);$a=git branch --format='%(refname:short)';$i=0;$a|%{$i++;Write-Host \\\"  [$i] $_\\\"};Write-Host '  [m] Merge -> staging';Write-Host '  [M] Merge staging -> main';$v=Read-Host 'Valasztas';if($v -eq 'm'){git checkout staging;git merge (git branch --show-current);git push;git checkout develop}elseif($v -eq 'M'){git checkout main;git merge staging;git push;git checkout develop}else{git checkout ($a[([int]$v)-1])}\"",
      "options": { "cwd": "${workspaceFolder}" },
      "group": "none",
      "presentation": { "reveal": "always", "panel": "shared", "clear": true },
      "problemMatcher": []
    }
  ]
}
'@
$tasks = $tasksBase -replace "BS_CMD_PLACEHOLDER", $bsCommand
Set-Content ".vscode\tasks.json" $tasks -Encoding UTF8
Ok "tasks.json letrehozva  (Ctrl+Shift+B = push)"

# ── naplo-watcher.ps1 ───────────────────────────────────────────
$watcherBase = @'
# NAPLO WATCHER - percenkenti auto-push
# Projekt: PROJEKT_NEV_PLACEHOLDER
$temaMappa = "PROJEKT_MAPPA_PLACEHOLDER"
$naplo = "$temaMappa\NAPLO.md"
Set-Location $temaMappa
Write-Host "Naplo watcher elindult..." -ForegroundColor Green
$utolso = ""
while ($true) {
    $most = Get-Date
    $datumSor = $most.ToString("yyyy. MMMM dd.")
    $ido = $most.ToString("HH:mm")
    $valtozott = git diff --name-only HEAD 2>$null
    $untracked = git ls-files --others --exclude-standard 2>$null
    $osszes = @($valtozott) + @($untracked) | Where-Object { $_ -ne "" }
    if ($osszes.Count -gt 0) {
        $bejegyzes = "$ido - modositva: $($osszes -join ', ')"
        if ($bejegyzes -ne $utolso) {
            $utolso = $bejegyzes
            if (Test-Path $naplo) {
                $tartalom = Get-Content $naplo -Raw -Encoding UTF8
                if ($tartalom -match [regex]::Escape("## $datumSor")) {
                    $tartalom = $tartalom -replace "(?m)(## $([regex]::Escape($datumSor))[\s\S]*?)(---)", "`$1- $bejegyzes`n`$2"
                    Set-Content $naplo $tartalom -Encoding UTF8
                } else {
                    "$tartalom`n## $datumSor`n`n### Valtozasok:`n- $bejegyzes`n`n---`n" | Set-Content $naplo -Encoding UTF8
                }
            }
            git add .
            git diff --cached --quiet
            if ($LASTEXITCODE -ne 0) {
                git commit -m "Auto-mentes $ido - $($osszes -join ', ')"
                git push
                Write-Host "[$ido] Feltoltve: $($osszes -join ', ')" -ForegroundColor Green
            }
        }
    } else { Write-Host "[$ido] Nincs valtozas." -ForegroundColor DarkGray }
    Start-Sleep -Seconds 60
}
'@
$watcher = $watcherBase -replace "PROJEKT_MAPPA_PLACEHOLDER", $projektMappa -replace "PROJEKT_NEV_PLACEHOLDER", $projektNev
Set-Content ".vscode\naplo-watcher.ps1" $watcher -Encoding UTF8
Ok "naplo-watcher.ps1 letrehozva  (percenkenti auto-push)"

# ── autosave-background.ps1 ─────────────────────────────────────
$bgBase = @'
# AUTO-MENTES - WINDOWS TASK SCHEDULER - Projekt: PROJEKT_NEV_PLACEHOLDER
$temaMappa = "PROJEKT_MAPPA_PLACEHOLDER"
$naplo = "$temaMappa\NAPLO.md"
$logFile = "$temaMappa\.vscode\autosave.log"
Set-Location $temaMappa
$most = Get-Date
$datumSor = $most.ToString("yyyy. MMMM dd.")
$ido = $most.ToString("HH:mm:ss")
$fajlok = @(git diff --name-only HEAD 2>$null) + @(git ls-files --others --exclude-standard 2>$null) | Where-Object { $_ -ne "" }
if ($fajlok.Count -gt 0) {
    $sor = "$ido - $($fajlok -join ', ')"
    if (Test-Path $naplo) {
        $tartalom = Get-Content $naplo -Raw -Encoding UTF8
        if ($tartalom -match [regex]::Escape("## $datumSor")) {
            $tartalom = $tartalom -replace "(?m)(## $([regex]::Escape($datumSor))[\s\S]*?)(---)", "`$1- $sor`n`$2"
        } else { $tartalom += "`n## $datumSor`n`n### Valtozasok:`n- $sor`n`n---`n" }
        Set-Content $naplo $tartalom -Encoding UTF8
    }
    git add .
    git diff --cached --quiet
    if ($LASTEXITCODE -ne 0) {
        git commit -m "AutoSave $ido - $($fajlok -join ', ')"
        git push 2>&1
        Add-Content $logFile "[$ido] PUSHED: $($fajlok -join ', ')"
    }
} else { Add-Content $logFile "[$ido] Nincs valtozas." }
'@
$bg = $bgBase -replace "PROJEKT_MAPPA_PLACEHOLDER", $projektMappa -replace "PROJEKT_NEV_PLACEHOLDER", $projektNev
Set-Content ".vscode\autosave-background.ps1" $bg -Encoding UTF8
Ok "autosave-background.ps1 letrehozva"

# ── install-autosave-task.ps1 ───────────────────────────────────
$installBase = @'
# Task Scheduler regisztralas - futtasd egyszer adminisztratorkent
$scriptPath = "PROJEKT_MAPPA_PLACEHOLDER\.vscode\autosave-background.ps1"
$taskName = "PROJEKT_NEV_PLACEHOLDER-AutoSave"
Unregister-ScheduledTask -TaskName $taskName -Confirm:$false -ErrorAction SilentlyContinue
$action = New-ScheduledTaskAction -Execute "powershell.exe" `
    -Argument "-ExecutionPolicy Bypass -WindowStyle Hidden -File `"$scriptPath`""
$triggerLogin = New-ScheduledTaskTrigger -AtLogOn
$triggerRepeat = New-ScheduledTaskTrigger -RepetitionInterval (New-TimeSpan -Minutes 5) -Once -At (Get-Date)
$settings = New-ScheduledTaskSettingsSet -RunOnlyIfNetworkAvailable:$false -StartWhenAvailable -ExecutionTimeLimit (New-TimeSpan -Minutes 2)
Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $triggerLogin -Settings $settings -RunLevel Highest -Force | Out-Null
$task = Get-ScheduledTask -TaskName $taskName
$task.Triggers += $triggerRepeat
$task | Set-ScheduledTask | Out-Null
Write-Host "Task: $taskName - 5 percenkent auto-push." -ForegroundColor Green
'@
$install = $installBase -replace "PROJEKT_MAPPA_PLACEHOLDER", $projektMappa -replace "PROJEKT_NEV_PLACEHOLDER", $projektNev
Set-Content ".vscode\install-autosave-task.ps1" $install -Encoding UTF8
Ok "install-autosave-task.ps1 letrehozva"

# ── copilot-instructions.md ─────────────────────────────────────
$copilotLines = @(
    "# Copilot szabalyok - $projektNev",
    "",
    "## Kotelezo naplo iras",
    "- Minden session vegen frissitsd a NAPLO.md fajlt",
    "- Session elejen olvasd el az utolso NAPLO.md bejegyzest",
    "",
    "## Projekt adatok",
    "- Nev: $projektNev",
    "- Mappa: $projektMappa",
    "- Tipus: $tipusNev",
    "- GitHub: $githubUrl"
)
$copilotLines | Set-Content ".github\copilot-instructions.md" -Encoding UTF8
Ok "copilot-instructions.md letrehozva"

# ── NAPLO.md ────────────────────────────────────────────────────
$datum = (Get-Date).ToString("yyyy. MMMM dd.")
$naploLines = @(
    "# $projektNev - Fejlesztesi naplo",
    "",
    "## $datum",
    "",
    "### Projekt letrehozva",
    "- Tipus: $tipusNev",
    "- Mappa: $projektMappa",
    "- GitHub: $githubUrl",
    "- Beallitas: VS Code Munkakornyezet Wizard v2.0",
    "",
    "---"
)
$naploLines | Set-Content "NAPLO.md" -Encoding UTF8
Ok "NAPLO.md letrehozva"

# ── .gitignore ──────────────────────────────────────────────────
@("*.log", "autosave.log", "node_modules/", ".DS_Store", "Thumbs.db") | Set-Content ".gitignore" -Encoding UTF8
Ok ".gitignore letrehozva"

# ── FTP deploy.yml ──────────────────────────────────────────────
if ($ftpKell -eq "i") {
    $deployLines = @(
        "name: Deploy - Eles szerver",
        "",
        "on:",
        "  push:",
        "    branches: [ main ]",
        "",
        "jobs:",
        "  deploy:",
        "    runs-on: ubuntu-latest",
        "    steps:",
        "      - name: Checkout",
        "        uses: actions/checkout@v4",
        "      - name: FTP Deploy",
        "        uses: SamKirkland/FTP-Deploy-Action@v4.3.4",
        "        with:",
        '          server: ${{ secrets.FTP_SERVER }}',
        '          username: ${{ secrets.FTP_USERNAME }}',
        '          password: ${{ secrets.FTP_PASSWORD }}',
        '          server-dir: ${{ secrets.FTP_SERVER_DIR }}',
        "          exclude: |",
        "            **/.git*",
        "            **/.git*/**",
        "            **/node_modules/**",
        "            **/.vscode/**"
    )
    $deployLines | Set-Content ".github\workflows\deploy.yml" -Encoding UTF8
    Ok "deploy.yml letrehozva"
}

# ── GIT INIT ────────────────────────────────────────────────────
Info "Git inicializalas..."
git init 2>&1 | Out-Null
git config user.name "koltainorbert"
git config user.email "koltainorbert@users.noreply.github.com"
git add .
git diff --cached --quiet
if ($LASTEXITCODE -ne 0) {
    git commit -m "Projekt inicializalas - $projektNev ($tipusNev)" 2>&1 | Out-Null
    Ok "Elso commit keszult"
}

if ($githubUrl) {
    git branch -M main 2>&1 | Out-Null
    $remoteCheck = git remote get-url origin 2>&1
    if ($LASTEXITCODE -ne 0) { git remote add origin $githubUrl 2>&1 | Out-Null }
    Info "GitHub push..."
    git push -u origin main 2>&1 | Out-Null
    if ($LASTEXITCODE -eq 0) {
        Ok "GitHub-ra feltoltve: $githubUrl"
    } else {
        Hiba "GitHub push sikertelen (a repo letezik es van hozzaferesed?)"
        Info "Manualis: git push -u origin main"
    }
}

# ── BRANCH RENDSZER ─────────────────────────────────────────────
if ($branchKell -eq "i" -and $githubUrl) {
    Info "Branch rendszer..."
    git checkout -b develop 2>&1 | Out-Null
    git push -u origin develop 2>&1 | Out-Null
    git checkout -b staging 2>&1 | Out-Null
    git push -u origin staging 2>&1 | Out-Null
    git checkout develop 2>&1 | Out-Null
    Ok "Branch rendszer: develop / staging / main"
}

# ── TASK SCHEDULER ──────────────────────────────────────────────
if ($taskSchedulerKell -eq "i") {
    $isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    if ($isAdmin) {
        powershell -ExecutionPolicy Bypass -File ".vscode\install-autosave-task.ps1" 2>&1 | Out-Null
        Ok "Task Scheduler: ${projektNev}-AutoSave bereg."
    } else {
        Write-Host ""
        Write-Host "  [->] Admin jog kell a Task Scheduler-hez. Futtasd kesobb:" -ForegroundColor Yellow
        Write-Host "       Jobb klikk PowerShell -> Futtattas rendszergazdakent" -ForegroundColor DarkGray
        Write-Host "       cd `"$projektMappa`"" -ForegroundColor DarkGray
        Write-Host "       powershell -ExecutionPolicy Bypass -File .vscode\install-autosave-task.ps1" -ForegroundColor DarkGray
    }
}

# ── KESZ! ───────────────────────────────────────────────────────
Write-Host ""
Write-Host "  +==========================================+" -ForegroundColor Green
Write-Host "  |              MINDEN KESZ!               |" -ForegroundColor Green
Write-Host "  +==========================================+" -ForegroundColor Green
Write-Host ""
Write-Host "  Projekt:  $projektNev  ($tipusNev)" -ForegroundColor White
Write-Host "  Mappa:    $projektMappa" -ForegroundColor White
if ($githubUrl) { Write-Host "  GitHub:   $githubUrl" -ForegroundColor White }
Write-Host ""
Write-Host "  KOVETKEZŐ LEPES:" -ForegroundColor Cyan
Write-Host ""
Write-Host "      code `"$projektMappa`"" -ForegroundColor Yellow
Write-Host ""
Write-Host "  VS Code-ban automatikusan:" -ForegroundColor DarkGray
Write-Host "    Ctrl+Shift+B = push | Browser Sync = live reload | Watcher = percenkenti mentes" -ForegroundColor DarkGray
Write-Host ""
Write-Host "  +==========================================+" -ForegroundColor Green
Write-Host ""
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
Write-Host "  [0] Csak lokális (LocalWP, localhost) — nincs élő szerver" -ForegroundColor White
Write-Host "  [1] Élő szerver is van — pushkor auto-deploy FTP-n" -ForegroundColor White
$elesValasztas = Read-Host "Szám"
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
Write-Host "  [0] Nem — csak én" -ForegroundColor White
Write-Host "  [1] Igen — legyen branching stratégia (main/staging/develop)" -ForegroundColor White
$branchingValasztas = Read-Host "Szám"
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
        Write-Host "  pl. D:\projektek\ujoldal" -ForegroundColor DarkGray
        Write-Host "  pl. C:\Users\SDH\Documents\react-app" -ForegroundColor DarkGray
        $projektMappa = Read-Host "Mappa"
        if ([string]::IsNullOrWhiteSpace($projektMappa)) {
            $projektMappa = Get-Location
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

# ── 4. GitHub ─────────────────────────────────────────────────────────────────

Write-Host "`nGitHub repo URL? (ENTER = kihagyom)" -ForegroundColor Yellow
Write-Host "  pl. https://github.com/koltainorbert/ujprojekt.git" -ForegroundColor DarkGray
$githubUrl = Read-Host "GitHub URL"

# ── 5. Fájlok létrehozása ─────────────────────────────────────────────────────

Write-Host "`n[1/5] VS Code tasks..." -ForegroundColor Yellow
@"
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "⬆ Push (feltöltés GitHubra)",
      "type": "shell",
      "command": "git add . && git diff --cached --quiet && echo 'Nincs változás.' || (git commit -m \\"Mentés `$(Get-Date -Format 'yyyy.MM.dd HH:mm')\\" && git push && echo 'Kész!')",
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
      "label": "⬇ Pull (frissítés GitHubról)",
      "type": "shell",
      "command": "git pull && echo 'Kész!'",
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

Write-Host "[2/5] Napló watcher script..." -ForegroundColor Yellow
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

Write-Host "[5/6] Copilot instrukciók..." -ForegroundColor Yellow
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

Write-Host "[6/6] NAPI-MUNKAREND.txt..." -ForegroundColor Yellow
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
Write-Host "  !! Ctrl+Shift+P → Manage Automatic Tasks → Allow" -ForegroundColor Yellow
Write-Host "     (ha még nem tetted meg egyszer)" -ForegroundColor Yellow
Write-Host "========================================`n" -ForegroundColor Green
