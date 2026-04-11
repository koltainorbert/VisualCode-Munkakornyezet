# ================================================
#  TASK SCHEDULER REGISZTRÁLÁS
#  Futtasd egyszer adminként:
#  Jobb klikk → "Futtatás rendszergazdaként"
#  Szerkeszd: $scriptPath = autosave-background.ps1 TELJES elérési útja
# ================================================

# !!! ÁLLÍTSD BE !!!
$scriptPath = "C:\\PROJEKT_MAPPA_IDE\\.vscode\\autosave-background.ps1"
$taskName = "ProjektAutoSave"

Unregister-ScheduledTask -TaskName $taskName -Confirm:$false -ErrorAction SilentlyContinue

$action = New-ScheduledTaskAction `
    -Execute "powershell.exe" `
    -Argument "-ExecutionPolicy Bypass -WindowStyle Hidden -File `"$scriptPath`""

$triggerLogin = New-ScheduledTaskTrigger -AtLogOn
$triggerRepeat = New-ScheduledTaskTrigger -RepetitionInterval (New-TimeSpan -Minutes 5) -Once -At (Get-Date)

$settings = New-ScheduledTaskSettingsSet `
    -RunOnlyIfNetworkAvailable:$false `
    -StartWhenAvailable `
    -ExecutionTimeLimit (New-TimeSpan -Minutes 2)

Register-ScheduledTask `
    -TaskName $taskName `
    -Action $action `
    -Trigger $triggerLogin `
    -Settings $settings `
    -RunLevel Highest `
    -Force | Out-Null

$task = Get-ScheduledTask -TaskName $taskName
$task.Triggers += $triggerRepeat
$task | Set-ScheduledTask | Out-Null

Write-Host "Task Scheduler beregisztrálva: $taskName" -ForegroundColor Green
Write-Host "5 percenként automatikusan ment és push." -ForegroundColor White
