param(
    [string]$Title = "",
    [string]$Message = "",
    [string]$Type = ""
)

# Szövegek itt, ékezetekkel rendesen
if ($Type -eq "no-change") {
    $Title   = "Nincs változás a munkában"
    $Message = "Nem volt mit feltölteni"
}
elseif ($Type -eq "push-ok") {
    # $Message már tartalmazza a commit nevet
    $Title = "Push sikeres"
}
elseif ($Type -eq "pull-ok") {
    $Title   = "Letöltés kész"
    $Message = "GitHub szinkronizálva"
}

try {
    # Registry: ShowBanner engedélyezése
    $regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings\Microsoft.VisualStudioCode"
    if (-not (Test-Path $regPath)) { New-Item -Path $regPath -Force | Out-Null }
    Set-ItemProperty -Path $regPath -Name "ShowBanner" -Value 1 -Type DWord -ErrorAction SilentlyContinue
    Set-ItemProperty -Path $regPath -Name "Enabled"    -Value 1 -Type DWord -ErrorAction SilentlyContinue

    [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
    [Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime] | Out-Null

    $xml = "<toast duration='short'><visual><binding template='ToastGeneric'><text>$Title</text><text>$Message</text></binding></visual></toast>"
    $doc = [Windows.Data.Xml.Dom.XmlDocument]::new()
    $doc.LoadXml($xml)
    $toast = [Windows.UI.Notifications.ToastNotification]::new($doc)
    $toast.ExpirationTime = [DateTimeOffset]::Now.AddSeconds(5)
    [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier("Microsoft.VisualStudioCode").Show($toast)
    Start-Sleep -Milliseconds 800
} catch {}

