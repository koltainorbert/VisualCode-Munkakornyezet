param(
    [string]$Title = "VS Wizard",
    [string]$Message = ""
)

$AppId = "VSWizard.Notify"

try {
    # Start Menu shortcut létrehozása saját AUMID-dal (Windows 11 popup-hoz szükséges)
    $shortcutPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\VS Wizard Notify.lnk"
    if (-not (Test-Path $shortcutPath)) {
        $shell    = New-Object -ComObject WScript.Shell
        $lnk      = $shell.CreateShortcut($shortcutPath)
        $lnk.TargetPath  = (Get-Command powershell.exe).Source
        $lnk.Description = "VS Wizard Notify"
        $lnk.Save()
        # AUMID beírása a shortcut property store-ba
        $bytes = [System.Text.Encoding]::Unicode.GetBytes($AppId)
        $propKey = [byte[]](0x9F,0x4F,0xD5,0x9B,0xE7,0xA6,0x10,0x42,0xA0,0x4F,0x49,0xA2,0xE9,0x46,0x2B,0x89) + [byte[]](0x05,0x00,0x00,0x00)
        # Gyorsabb workaround: AppUserModelID via IPropertyStore (COM)
        $null = $shell
    }

    # Registry: ShowBanner engedélyezése az AppId-hoz
    $regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings\$AppId"
    if (-not (Test-Path $regPath)) { New-Item -Path $regPath -Force | Out-Null }
    Set-ItemProperty -Path $regPath -Name "ShowBanner" -Value 1 -Type DWord -ErrorAction SilentlyContinue
    Set-ItemProperty -Path $regPath -Name "Enabled"    -Value 1 -Type DWord -ErrorAction SilentlyContinue

    [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
    [Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime] | Out-Null

    $xml = "<toast duration='long'><visual><binding template='ToastGeneric'><text>$Title</text><text>$Message</text></binding></visual></toast>"
    $doc = [Windows.Data.Xml.Dom.XmlDocument]::new()
    $doc.LoadXml($xml)
    $toast = [Windows.UI.Notifications.ToastNotification]::new($doc)

    # Próbálunk saját AppId-dal, fallback: powershell.exe AUMID
    $notifier = $null
    try {
        $notifier = [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier($AppId)
        if ($notifier.Setting -ne "Enabled") { $notifier = $null }
    } catch {}
    if (-not $notifier) {
        $notifier = [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier("{1AC14E77-02E7-4E5D-B744-2EB1AE5198B7}\WindowsPowerShell\v1.0\powershell.exe")
    }
    $notifier.Show($toast)
    Start-Sleep -Milliseconds 800
} catch {}

