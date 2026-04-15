param(
    [string]$Title = "VS Wizard",
    [string]$Message = "",
    [string]$Type = "success"
)

try {
    [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
    [Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime] | Out-Null

    $xml = [Windows.UI.Notifications.ToastNotificationManager]::GetTemplateContent(
        [Windows.UI.Notifications.ToastTemplateType]::ToastText02
    )
    $nodes = $xml.GetElementsByTagName("text")
    $nodes[0].AppendChild($xml.CreateTextNode($Title))   | Out-Null
    $nodes[1].AppendChild($xml.CreateTextNode($Message)) | Out-Null

    $toast = [Windows.UI.Notifications.ToastNotification]::new($xml)
    [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier("VS Wizard").Show($toast)
} catch {
    # csendben megy tovabb ha nem tamogatott
}
