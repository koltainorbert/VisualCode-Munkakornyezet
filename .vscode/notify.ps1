param([string]$Title="", [string]$Message="", [string]$Type="")

# Szovegek + szinek type alapjan
$iconMain = "↑"
$iconTop  = "☁"
$iconTopFg = "#60b0ff"
$iconBg    = "#1a2a1a"
$iconFg    = "#00e676"
$showTop   = $true

if ($Type -eq "no-change") {
    $Title    = "Nincs valtozas a munkaban"
    $Message  = "Nem volt mit feltolteni"
    $iconMain = "~"
    $iconTop  = ""
    $showTop  = $false
    $iconBg   = "#2a2a1a"
    $iconFg   = "#ffb800"
} elseif ($Type -eq "push-ok") {
    if (-not $Title) { $Title = "Push sikeres" }
    $iconMain  = "↑"
    $iconTop   = "☁"
    $iconTopFg = "#60b0ff"
    $iconBg    = "#1a2a1a"
    $iconFg    = "#00e676"
} elseif ($Type -eq "pull-ok") {
    $Title     = "Letoltes kesz"
    $Message   = "GitHub szinkronizalva"
    $iconMain  = "↓"
    $iconTop   = "☁"
    $iconTopFg = "#60b0ff"
    $iconBg    = "#1a2030"
    $iconFg    = "#60b0ff"
}

Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase, System.Windows.Forms

$screen = [System.Windows.Forms.Screen]::PrimaryScreen.WorkingArea

[xml]$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        WindowStyle="None" AllowsTransparency="True" Background="Transparent"
        Topmost="True" ShowInTaskbar="False" Width="320" Height="72">
  <Border CornerRadius="12" Background="#161616" BorderThickness="1">
    <Border.BorderBrush><SolidColorBrush Color="#FFFFFF" Opacity="0.12"/></Border.BorderBrush>
    <Border.Effect>
      <DropShadowEffect Color="#000000" BlurRadius="40" Opacity="0.8" ShadowDepth="8"/>
    </Border.Effect>
    <Grid Margin="14,12,14,12">
      <Grid.ColumnDefinitions>
        <ColumnDefinition Width="Auto"/>
        <ColumnDefinition Width="*"/>
      </Grid.ColumnDefinitions>
      <Border Name="iconBox" Width="34" Height="34" CornerRadius="8" Margin="0,0,13,0" VerticalAlignment="Center">
        <StackPanel VerticalAlignment="Center" HorizontalAlignment="Center">
          <TextBlock Name="iconTopTxt" HorizontalAlignment="Center" FontSize="9" Margin="0,0,0,0"/>
          <TextBlock Name="iconTxt" HorizontalAlignment="Center" FontSize="14" FontWeight="Bold"/>
        </StackPanel>
      </Border>
      <StackPanel Grid.Column="1" VerticalAlignment="Center">
        <TextBlock Name="ttl" FontSize="12" FontWeight="Bold" Foreground="#FFFFFF" Margin="0,0,0,3" TextTrimming="CharacterEllipsis"/>
        <TextBlock Name="msg" FontSize="11" Foreground="#888888" TextTrimming="CharacterEllipsis"/>
      </StackPanel>
    </Grid>
  </Border>
</Window>
"@

$win = [Windows.Markup.XamlReader]::Load([System.Xml.XmlNodeReader]::new($xaml))
$win.FindName("ttl").Text      = $Title
$win.FindName("msg").Text      = $Message
$win.FindName("iconTxt").Text  = $iconMain
$win.FindName("iconTxt").Foreground    = [System.Windows.Media.BrushConverter]::new().ConvertFromString($iconFg)
$win.FindName("iconBox").Background    = [System.Windows.Media.BrushConverter]::new().ConvertFromString($iconBg)
$win.FindName("iconTopTxt").Text       = $iconTop
$win.FindName("iconTopTxt").Foreground = [System.Windows.Media.BrushConverter]::new().ConvertFromString($iconTopFg)
if (-not $showTop) { $win.FindName("iconTopTxt").Visibility = "Collapsed" }

$startTop = $screen.Top - 90
$endTop   = $screen.Top + 12
$win.Left    = $screen.Right - 340
$win.Top     = $startTop
$win.Opacity = 0

$win.Add_Loaded({
    $d = [System.Windows.Duration]::new([TimeSpan]::FromMilliseconds(450))
    $ease = [System.Windows.Media.Animation.CubicEase]::new()
    $ease.EasingMode = [System.Windows.Media.Animation.EasingMode]::EaseOut

    $aOp = [System.Windows.Media.Animation.DoubleAnimation]::new(0, 1, [System.Windows.Duration]::new([TimeSpan]::FromMilliseconds(300)))
    $aTop = [System.Windows.Media.Animation.DoubleAnimation]::new($startTop, $endTop, $d)
    $aTop.EasingFunction = $ease

    $win.BeginAnimation([System.Windows.Window]::OpacityProperty, $aOp)
    $win.BeginAnimation([System.Windows.Window]::TopProperty, $aTop)

    $t = [System.Windows.Threading.DispatcherTimer]::new()
    $t.Interval = [TimeSpan]::FromSeconds(3.5)
    $t.Add_Tick({
        $t.Stop()
        $dOut = [System.Windows.Duration]::new([TimeSpan]::FromMilliseconds(300))
        $fo   = [System.Windows.Media.Animation.DoubleAnimation]::new(1, 0, $dOut)
        $aOut = [System.Windows.Media.Animation.DoubleAnimation]::new($endTop, $endTop - 20, $dOut)
        $fo.Add_Completed({ $win.Close() })
        $win.BeginAnimation([System.Windows.Window]::OpacityProperty, $fo)
        $win.BeginAnimation([System.Windows.Window]::TopProperty, $aOut)
    })
    $t.Start()
})

$win.ShowDialog() | Out-Null