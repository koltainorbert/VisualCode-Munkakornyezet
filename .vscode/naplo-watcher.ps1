# ================================================
#  NAPLO WATCHER - percenkénti auto-push
#  Szerkeszd: $temaMappa = a projekt mappa abszolút útja
# ================================================

# !!! ÁLLÍTSD BE: a projekt mappa abszolút útja !!!
$temaMappa = "C:\\PROJEKT_MAPPA_IDE"
$naplo = "$temaMappa\\NAPLO.md"

Set-Location $temaMappa
Write-Host "Napló watcher elindult... (Ctrl+C = leállítás)" -ForegroundColor Green

$utolsoPercBejegyzes = ""

while ($true) {
    $most = Get-Date
    $datumSor = $most.ToString("yyyy. MMMM dd.")
    $ido = $most.ToString("HH:mm")

    $valtozottFajlok = git diff --name-only HEAD 2>$null
    $untracked = git ls-files --others --exclude-standard 2>$null
    $osszes = @($valtozottFajlok) + @($untracked) | Where-Object { $_ -ne "" }

    if ($osszes.Count -gt 0) {
        $bejegyzes = "$ido - módosítva: $($osszes -join ', ')"

        if ($bejegyzes -ne $utolsoPercBejegyzes) {
            $utolsoPercBejegyzes = $bejegyzes

            $tartalom = Get-Content $naplo -Raw -Encoding UTF8
            if ($tartalom -match [regex]::Escape("## $datumSor")) {
                $ujTartalom = $tartalom -replace "(?m)(## $([regex]::Escape($datumSor))[\s\S]*?)(---)", "\$1- $bejegyzes\n\$2"
                Set-Content $naplo $ujTartalom -Encoding UTF8
            } else {
                $ujBejegyzes = "\n## $datumSor\n\n### Változások:\n- $bejegyzes\n\n---\n"
                "$tartalom\n$ujBejegyzes" | Set-Content $naplo -Encoding UTF8
            }

            git add .
            git diff --cached --quiet
            if ($LASTEXITCODE -ne 0) {
                git commit -m "Auto-mentés $ido - $($osszes -join ', ')"
                git push
                Write-Host "[$ido] GitHub-ra feltöltve: $($osszes -join ', ')" -ForegroundColor Green
            }
        }
    } else {
        Write-Host "[$ido] Nincs változás." -ForegroundColor DarkGray
    }

    Start-Sleep -Seconds 60
}
