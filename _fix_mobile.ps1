$f = 'C:\Repos\VisualCode-Munkakornyezet\DEV-RENDSZER.html'
$c = [System.IO.File]::ReadAllText($f, [System.Text.Encoding]::UTF8)

# 1. Remove orphaned CSS leftover
$c = [regex]::Replace($c, '\r\n  \.hero,\.wrap\{padding-left:24px;padding-right:24px\}\r\n.*?\.qp\{border-right:none;border-bottom:1px solid var\(--border\)\}\r\n\}', '', [System.Text.RegularExpressions.RegexOptions]::Singleline)

# 2. Add hamburger base CSS after nav a block
$navA = "nav a{font-size:11px;letter-spacing:1.5px;color:var(--text);" + [char]13 + [char]10 + "  text-decoration:none;text-transform:uppercase;transition:color .2s;position:relative}"
$navANew = $navA + [char]13 + [char]10 + "#hbg{display:none;flex-direction:column;justify-content:center;gap:5px;background:none;border:none;padding:8px;cursor:pointer;flex-shrink:0;margin-left:auto}" + [char]13 + [char]10 + "#hbg span{display:block;width:22px;height:2px;background:#fff;border-radius:1px;transition:all .25s}"
$c = $c.Replace($navA, $navANew)

# 3. Update @media(max-width:768px) nav rules
$old768 = "  nav{padding:0 16px}" + [char]13 + [char]10 + "  nav a:not(.ngh){display:none}"
$new768 = "  nav{padding:0 16px;flex-wrap:wrap;height:auto;min-height:58px;max-height:58px;overflow:hidden;transition:max-height .35s ease;align-content:flex-start;gap:0}" + [char]13 + [char]10 + "  nav .nl{height:58px;display:flex;align-items:center;padding-right:8px}" + [char]13 + [char]10 + "  .nr{height:58px;display:flex;align-items:center}" + [char]13 + [char]10 + "  #hbg{display:flex}" + [char]13 + [char]10 + "  nav.open{max-height:500px}" + [char]13 + [char]10 + "  nav a:not(.ngh){display:flex!important;width:100%;padding:13px 16px;font-size:12px;letter-spacing:1.5px;color:#fff;border-top:1px solid rgba(255,255,255,.05)}" + [char]13 + [char]10 + "  nav.open #hbg span:nth-child(1){transform:translateY(7px) rotate(45deg)}" + [char]13 + [char]10 + "  nav.open #hbg span:nth-child(2){opacity:0;transform:scaleX(0)}" + [char]13 + [char]10 + "  nav.open #hbg span:nth-child(3){transform:translateY(-7px) rotate(-45deg)}"
$c = $c.Replace($old768, $new768)

# 4. Add hamburger HTML button before .nr div
$nrDiv = '<div class="nr">'
$hbgHtml = '<button id="hbg" onclick="document.querySelector(''nav'').classList.toggle(''open'')" aria-label="Menu"><span></span><span></span><span></span></button>'
$c = $c.Replace($nrDiv, $hbgHtml + $nrDiv)

# 5. Add close-on-click JS - insert before IntersectionObserver observer.observe pattern
$jsAnchor = "new IntersectionObserver"
$jsClose = "document.querySelectorAll('nav a').forEach(function(a){a.addEventListener('click',function(){document.querySelector('nav').classList.remove('open')})});" + [char]13 + [char]10
$firstIdx = $c.IndexOf($jsAnchor)
if($firstIdx -gt 0){ $c = $c.Substring(0,$firstIdx) + $jsClose + $c.Substring($firstIdx) }

# 6. Save
[System.IO.File]::WriteAllText($f, $c, [System.Text.Encoding]::UTF8)
Write-Host "DONE"
Write-Host "orphan gone: $(-not $c.Contains('.hero,.wrap{padding-left:24px'))"
Write-Host "hbg css: $($c.Contains('#hbg{display:none'))"
Write-Host "nav.open: $($c.Contains('nav.open{max-height'))"
Write-Host "hbg html: $($c.Contains('id=""hbg""'))"
Write-Host "js close: $($c.Contains('classList.remove(''open'')') -or $c.Contains("classList.remove('open')"))"
