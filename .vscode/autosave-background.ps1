# ================================================
#  AUTO-MENTÉS - WINDOWS TASK SCHEDULER SCRIPT
#  5 percenként fut, VS Code-tól FÜGGETLENÜL
#  Szerkeszd: $temaMappa = a projekt mappa
# ================================================

# !!! ÁLLÍTSD BE !!!
$temaMappa = "C:\\PROJEKT_MAPPA_IDE"
$naplo = "$temaMappa\\NAPLO.md"
$logFile = "$temaMappa\\.vscode\\autosave.log"

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
            $tartalom = $tartalom -replace "(?m)(## $([regex]::Escape($datumSor))[\s\S]*?)(---)", "\$1- $sor\n\$2"
        } else {
            $tartalom += "\n## $datumSor\n\n### Változások:\n- $sor\n\n---\n"
        }
        Set-Content $naplo $tartalom -Encoding UTF8
    }

    git add .
    git diff --cached --quiet
    if ($LASTEXITCODE -ne 0) {
        git commit -m "AutoSave $ido - $($fajlok -join ', ')"
        git push 2>&1
        Add-Content $logFile "[$ido] PUSHED: $($fajlok -join ', ')"
    }
} else {
    Add-Content $logFile "[$ido] Nincs változás."
}
