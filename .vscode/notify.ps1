param([string]$Title="", [string]$Message="", [string]$Type="")

if     ($Type -eq "no-change") { $Title="Nincs valtozas a munkaban"; $Message="Nem volt mit feltolteni" }
elseif ($Type -eq "push-ok")   { if (-not $Title) { $Title="Push sikeres" } }
elseif ($Type -eq "pull-ok")   { $Title="Letoltes kesz"; $Message="GitHub szinkronizalva" }

Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase
Add-Type -AssemblyName System.Windows.Forms

$script:screen = [System.Windows.Forms.Screen]::PrimaryScreen.WorkingArea

[xml]$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        WindowStyle="None" AllowsTransparency="True" Background="Transparent"
        Topmost="True" ShowInTaskbar="False" Width="300" Height="84">
  <Border Name="root" Background="#060606" BorderBrush="#ff0000" BorderThickness="1">
    <Border.Effect>
      <DropShadowEffect Color="#ff0000" BlurRadius="18" Opacity="0.4" ShadowDepth="0"/>
    </Border.Effect>
    <Grid Margin="14,12,14,12">
      <Grid.RowDefinitions>
        <RowDefinition Height="Auto"/>
        <RowDefinition Height="Auto"/>
        <RowDefinition Height="6"/>
      </Grid.RowDefinitions>
      <StackPanel Grid.Row="0" Orientation="Horizontal">
        <Rectangle Width="3" Fill="#ff0000" RadiusX="1" RadiusY="1" Margin="0,1,8,1"/>
        <TextBlock Name="ttl" Foreground="#ff0000" FontWeight="Bold" FontSize="12" FontFamily="Consolas" VerticalAlignment="Center"/>
      </StackPanel>
      <TextBlock Name="msg" Grid.Row="1" Foreground="#888888" FontSize="10" FontFamily="Consolas" Margin="11,5,0,0" TextTrimming="CharacterEllipsis"/>
      <Grid Grid.Row="2" Margin="0,9,0,0" Height="2">
        <Rectangle Fill="#1a1a1a" RadiusX="1" RadiusY="1"/>
        <Rectangle Name="prog" Fill="#ff0000" RadiusX="1" RadiusY="1" HorizontalAlignment="Left" Width="272"/>
      </Grid>
    </Grid>
  </Border>
</Window>
"@

$script:win = [Windows.Markup.XamlReader]::Load([System.Xml.XmlNodeReader]::new($xaml))
$script:win.FindName("ttl").Text = $Title
$script:win.FindName("msg").Text = $Message
$script:prog = $script:win.FindName("prog")

$script:startTop = $script:screen.Bottom + 10
$script:endTop   = $script:screen.Bottom - 96

$script:win.Left    = $script:screen.Right - 320
$script:win.Top     = $script:startTop
$script:win.Opacity = 0

$script:win.Add_Loaded({
    $d300 = [System.Windows.Duration]::new([TimeSpan]::FromMilliseconds(300))
    $d5s  = [System.Windows.Duration]::new([TimeSpan]::FromSeconds(5))

    $script:win.BeginAnimation([System.Windows.Window]::OpacityProperty,
        [System.Windows.Media.Animation.DoubleAnimation]::new(0, 1, $d300))
    $script:win.BeginAnimation([System.Windows.Window]::TopProperty,
        [System.Windows.Media.Animation.DoubleAnimation]::new($script:startTop, $script:endTop, $d300))
    $script:prog.BeginAnimation([System.Windows.FrameworkElement]::WidthProperty,
        [System.Windows.Media.Animation.DoubleAnimation]::new(272, 0, $d5s))

    $script:t = [System.Windows.Threading.DispatcherTimer]::new()
    $script:t.Interval = [TimeSpan]::FromSeconds(5)
    $script:t.Add_Tick({
        $script:t.Stop()
        $dOut = [System.Windows.Duration]::new([TimeSpan]::FromMilliseconds(300))
        $fo = [System.Windows.Media.Animation.DoubleAnimation]::new(1, 0, $dOut)
        $fo.Add_Completed({ $script:win.Close() })
        $script:win.BeginAnimation([System.Windows.Window]::OpacityProperty, $fo)
    })
    $script:t.Start()
})

$script:win.ShowDialog() | Out-Null