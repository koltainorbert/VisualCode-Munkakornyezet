import re

# ── PS1 kinyerése ──────────────────────────────────────────────────
existing = open('C:/Users/SDH/VisualCode-Munkakornyezet/DEV-RENDSZER.html', encoding='utf-8').read()
m = re.search(r'<pre id="ps1-inline"[^>]*>([\s\S]*?)</pre>', existing)
PS1 = m.group(1) if m else '# PS1 content not found'

URL  = 'https://raw.githubusercontent.com/koltainorbert/VisualCode-Munkakornyezet/main/setup-projekt.ps1'
IRM  = 'irm "' + URL + '" | iex'
WINR = "powershell -ExecutionPolicy Bypass -Command \"irm '" + URL + "' | iex\""
CPL  = '@terminal irm "' + URL + '" | iex'

CSS = """
*{margin:0;padding:0;box-sizing:border-box}
:root{
  --red:#ff0000;--bg:rgb(6,6,6);--border:rgba(255,255,255,.07);
  --border2:rgba(255,0,0,.2);--text:rgba(255,255,255,.42);
  --text2:rgba(255,255,255,.7);--green:#00e676;
  --mono:'Cascadia Code','Fira Code','Consolas',monospace;
}
html{scroll-behavior:smooth}
body{
  background:var(--bg);
  background-image:radial-gradient(rgba(255,0,0,.025) 1px,transparent 1px),
    radial-gradient(rgba(255,255,255,.012) 1px,transparent 1px);
  background-size:60px 60px,30px 30px;background-position:0 0,15px 15px;
  color:#fff;font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',sans-serif;
  min-height:100vh;overflow-x:hidden;
}
#cv{position:fixed;top:0;left:0;pointer-events:none;z-index:0;opacity:.55}
#prog{position:fixed;top:0;left:0;height:2px;z-index:999;
  background:linear-gradient(90deg,#ff0000,#ff6600,#ff0000);
  background-size:200% 100%;animation:shimmer 2s linear infinite;
  width:0;transition:width .1s}
@keyframes shimmer{0%{background-position:200% 0}100%{background-position:-200% 0}}
nav{position:fixed;top:0;left:0;right:0;z-index:100;
  display:flex;align-items:center;gap:28px;padding:0 40px;height:56px;
  background:rgba(6,6,6,.88);backdrop-filter:blur(20px);
  border-bottom:1px solid var(--border)}
.nl{font-size:13px;font-weight:800;letter-spacing:3px;
  display:flex;align-items:center;gap:9px}
.nd{width:7px;height:7px;border-radius:50%;background:var(--red);
  animation:pulse-dot 2s ease-in-out infinite}
@keyframes pulse-dot{0%,100%{box-shadow:0 0 0 0 rgba(255,0,0,.5)}
  50%{box-shadow:0 0 0 6px rgba(255,0,0,0)}}
nav a{font-size:11px;letter-spacing:1.5px;color:var(--text);
  text-decoration:none;text-transform:uppercase;transition:color .2s;position:relative}
nav a::after{content:'';position:absolute;bottom:-3px;left:0;right:0;
  height:1px;background:var(--red);transform:scaleX(0);transition:transform .25s;transform-origin:left}
nav a:hover{color:#fff}nav a:hover::after{transform:scaleX(1)}
.nr{margin-left:auto}
.ngh{display:flex;align-items:center;gap:6px;
  background:rgba(255,0,0,.07);border:1px solid var(--border2);
  color:#fff;font-size:11px;letter-spacing:1px;padding:6px 16px;
  text-decoration:none;transition:all .22s;text-transform:uppercase}
.ngh:hover{background:rgba(255,0,0,.18);border-color:var(--red)}
.ngh svg{width:14px;height:14px}
.ngh::after{display:none !important}
.hero{min-height:100vh;display:flex;flex-direction:column;
  justify-content:center;padding:100px 40px 80px;
  max-width:960px;margin:0 auto;position:relative;z-index:1}
.he{display:flex;align-items:center;gap:10px;font-size:10px;letter-spacing:4px;
  text-transform:uppercase;color:var(--red);margin-bottom:36px;
  animation:fsup .7s cubic-bezier(.16,1,.3,1) .1s both}
.hel{width:32px;height:1px;background:var(--red)}
h1.ht{font-size:clamp(52px,9vw,96px);font-weight:900;
  line-height:.95;letter-spacing:-3px;margin-bottom:28px;overflow:hidden}
.ht .ln{display:block;overflow:hidden}
.ht .wd{display:inline-block;animation:wdup .8s cubic-bezier(.16,1,.3,1) both}
.ht .wd.r{color:var(--red)}
.ht .wd:nth-child(1){animation-delay:.15s}
.ht .wd:nth-child(2){animation-delay:.3s}
.ht .wd:nth-child(3){animation-delay:.45s}
@keyframes wdup{from{transform:translateY(110%);opacity:0}to{transform:translateY(0);opacity:1}}
@keyframes fsup{from{opacity:0;transform:translateY(24px)}to{opacity:1;transform:translateY(0)}}
.hs{font-size:16px;color:var(--text2);line-height:1.75;max-width:560px;margin-bottom:48px;
  animation:fsup .8s cubic-bezier(.16,1,.3,1) .55s both}
.mb{position:relative;margin-bottom:36px;animation:fsup .8s cubic-bezier(.16,1,.3,1) .65s both}
.mbi{border:1px solid rgba(255,0,0,.3);background:rgba(255,0,0,.04);position:relative;overflow:hidden}
.mbi::before{content:'';position:absolute;inset:0;
  background:linear-gradient(135deg,rgba(255,0,0,.07) 0%,transparent 50%,rgba(255,0,0,.03) 100%);
  pointer-events:none}
.mbl{display:flex;align-items:center;gap:8px;padding:10px 18px 0;
  font-size:10px;letter-spacing:3px;color:var(--red);text-transform:uppercase;font-weight:700}
.mbl svg{width:10px;height:10px;animation:spin 4s linear infinite}
@keyframes spin{to{transform:rotate(360deg)}}
.mbr{display:flex;align-items:stretch}
.mbc{flex:1;font-family:var(--mono);font-size:13px;color:rgba(255,255,255,.9);
  padding:16px 18px;line-height:1.5;word-break:break-all;
  border-right:1px solid rgba(255,0,0,.2)}
.mbc .kw{color:rgba(255,140,140,.9)}.mbc .str{color:rgba(255,210,120,.9)}
.mcp{background:var(--red);border:none;color:#fff;font-size:11px;letter-spacing:2px;
  padding:0 26px;cursor:pointer;font-weight:800;text-transform:uppercase;
  transition:all .22s;white-space:nowrap;display:flex;align-items:center;gap:8px}
.mcp svg{width:16px;height:16px;transition:transform .2s}
.mcp:hover{background:#cc0000}.mcp.ok{background:var(--green);color:rgb(6,6,6)}
.mbf{padding:10px 18px;font-size:11px;color:var(--text);
  border-top:1px solid rgba(255,255,255,.04);display:flex;align-items:center;gap:8px}
.mbf svg{width:13px;height:13px;color:rgba(255,0,0,.5);flex-shrink:0}
.mbf a{color:rgba(255,0,0,.55);text-decoration:none;transition:color .2s}
.mbf a:hover{color:rgba(255,0,0,.85)}
.hc{display:flex;gap:12px;flex-wrap:wrap;animation:fsup .8s cubic-bezier(.16,1,.3,1) .75s both}
.btn{display:inline-flex;align-items:center;gap:8px;padding:12px 28px;
  font-size:11px;letter-spacing:2px;font-weight:700;text-transform:uppercase;
  text-decoration:none;transition:all .22s;cursor:pointer;border:none;font-family:inherit}
.btn svg{width:14px;height:14px}
.btn-r{background:var(--red);color:#fff}.btn-r:hover{background:#cc0000;transform:translateY(-1px)}
.btn-g{border:1px solid var(--border);color:var(--text);background:transparent}
.btn-g:hover{border-color:rgba(255,255,255,.22);color:#fff;transform:translateY(-1px)}
hr.d{border:none;border-top:1px solid var(--border);position:relative;z-index:1}
section{padding:88px 0;position:relative;z-index:1}
.wrap{max-width:960px;margin:0 auto;padding:0 40px}
.se{font-size:10px;letter-spacing:4px;text-transform:uppercase;
  color:var(--red);margin-bottom:14px;display:flex;align-items:center;gap:10px}
.se::before{content:'';width:24px;height:1px;background:var(--red)}
h2.st{font-size:clamp(30px,5vw,48px);font-weight:800;
  letter-spacing:-1.5px;margin-bottom:16px;line-height:1.1}
.ss{font-size:15px;color:var(--text);line-height:1.7;max-width:580px;margin-bottom:52px}
.rv{opacity:0;transform:translateY(28px);transition:opacity .65s ease,transform .65s ease}
.rv.vi{opacity:1;transform:translateY(0)}
.tbs{display:flex;flex-wrap:wrap;border-bottom:2px solid var(--border)}
.tbtn{flex:1;min-width:130px;display:flex;flex-direction:column;align-items:center;gap:10px;
  padding:20px 12px 18px;background:transparent;border:none;color:var(--text);
  cursor:pointer;font-family:inherit;transition:all .25s;position:relative;
  border-bottom:2px solid transparent;margin-bottom:-2px}
.tbtn:hover{color:rgba(255,255,255,.65);background:rgba(255,255,255,.02)}
.tbtn.act{color:#fff;border-bottom-color:var(--red);background:rgba(255,0,0,.04)}
.tbtn.act .tbi{color:var(--red)}
.tbi{width:32px;height:32px;transition:color .25s}
.tbn{font-size:11px;font-weight:700;letter-spacing:1.5px;text-transform:uppercase}
.tbh{font-size:10px;color:var(--text)}
.icon-term .cur{animation:blinkcur .8s step-end infinite}
@keyframes blinkcur{0%,100%{opacity:1}50%{opacity:0}}
.icon-vsc .vl{stroke-dasharray:80;stroke-dashoffset:80;animation:drawl 1.2s ease forwards}
@keyframes drawl{to{stroke-dashoffset:0}}
.tbtn.act .icon-vsc .vl{animation:drawl .6s ease forwards}
.icon-ai .dot{animation:aipulse 1.5s ease-in-out infinite;transform-origin:center}
.icon-ai .dot:nth-child(2){animation-delay:.2s}
.icon-ai .dot:nth-child(3){animation-delay:.4s}
@keyframes aipulse{0%,100%{r:2.5}50%{r:3.8}}
.icon-cd .br{stroke-dasharray:50;stroke-dashoffset:50;animation:drawl 1s ease .1s forwards}
.icon-cd .sl{animation:slash .4s ease 1.1s both;transform-origin:center}
@keyframes slash{from{opacity:0;transform:rotate(-15deg) scaleY(.4)}to{opacity:1;transform:none}}
.tpanels{position:relative}
.tpanel{display:none;padding:32px 0}
.tpanel.act{display:block;animation:panin .3s ease}
@keyframes panin{from{opacity:0;transform:translateY(8px)}to{opacity:1;transform:translateY(0)}}
.warn{display:flex;gap:14px;align-items:flex-start;
  background:rgba(255,165,0,.05);border:1px solid rgba(255,165,0,.2);
  border-left:3px solid #ff9800;padding:14px 18px;margin-bottom:24px}
.warn svg{width:18px;height:18px;color:#ff9800;flex-shrink:0;margin-top:1px}
.warn p{font-size:12px;color:var(--text2);line-height:1.7}
.warn p strong{color:#fff}
.warn p code{font-family:var(--mono);font-size:11px;
  color:rgba(255,140,80,.9);background:rgba(255,140,0,.08);
  padding:1px 5px;border:1px solid rgba(255,140,0,.2)}
.ml{font-size:10px;letter-spacing:2.5px;text-transform:uppercase;
  color:rgba(255,0,0,.6);margin-bottom:12px;display:flex;align-items:center;gap:8px}
.ml::after{content:'';flex:1;height:1px;background:rgba(255,0,0,.12)}
.stps{display:flex;flex-direction:column;gap:0;margin-bottom:14px}
.si{display:flex;align-items:flex-start;gap:14px;
  padding:10px 0;border-bottom:1px solid rgba(255,255,255,.04)}
.si:last-child{border-bottom:none}
.sn{width:24px;height:24px;border-radius:50%;flex-shrink:0;margin-top:1px;
  border:1px solid rgba(255,0,0,.3);display:flex;align-items:center;justify-content:center;
  font-size:10px;font-weight:800;color:rgba(255,0,0,.65)}
.si p{font-size:13px;color:var(--text2);line-height:1.65}
.si p strong{color:#fff}
.si p code,.si p var{font-family:var(--mono);font-size:11px;
  color:rgba(255,120,120,.9);background:rgba(255,0,0,.08);
  padding:1px 6px;border:1px solid rgba(255,0,0,.14);font-style:normal}
.cr{display:flex;align-items:stretch;border:1px solid var(--border)}
.cr code{flex:1;font-family:var(--mono);font-size:12px;
  color:rgba(255,255,255,.88);background:rgba(0,0,0,.65);
  padding:14px 18px;line-height:1.55;word-break:break-all;
  border-right:1px solid var(--border)}
.cbtn{background:transparent;border:none;color:var(--text);font-size:10px;
  letter-spacing:1.5px;padding:0 20px;cursor:pointer;font-family:inherit;
  text-transform:uppercase;font-weight:700;transition:all .2s;white-space:nowrap;
  display:flex;align-items:center;gap:6px}
.cbtn svg{width:13px;height:13px}
.cbtn:hover{background:rgba(255,0,0,.07);color:#fff}
.cbtn.ok{background:rgba(0,230,118,.1);color:var(--green)}
.mbb{margin-bottom:28px}
.cw{position:relative;margin-top:8px}
.ch{display:flex;align-items:center;justify-content:space-between;
  background:rgba(255,255,255,.035);border:1px solid var(--border);
  border-bottom:none;padding:8px 16px}
.clg{font-family:var(--mono);font-size:11px;color:rgba(255,0,0,.65);
  display:flex;align-items:center;gap:6px}
.clg svg{width:12px;height:12px}
.ca{display:flex;gap:6px}
.csm{background:transparent;border:1px solid var(--border);color:var(--text);
  font-size:10px;padding:3px 12px;cursor:pointer;letter-spacing:1px;
  transition:all .2s;font-family:inherit;text-transform:uppercase;font-weight:700}
.csm:hover{border-color:var(--red);color:#fff}
.csm.ok{border-color:var(--green);color:var(--green)}
pre.cpre{background:rgba(0,0,0,.75);border:1px solid var(--border);
  padding:20px;overflow-x:auto;font-size:11.5px;line-height:1.72;
  font-family:var(--mono);color:rgba(255,255,255,.82);
  max-height:320px;transition:max-height .4s ease;
  scrollbar-width:thin;scrollbar-color:rgba(255,0,0,.3) transparent}
pre.cpre::-webkit-scrollbar{width:4px;height:4px}
pre.cpre::-webkit-scrollbar-thumb{background:rgba(255,0,0,.3);border-radius:2px}
pre.cpre.exp{max-height:none}
.expbtn{display:flex;width:100%;align-items:center;justify-content:center;gap:6px;
  background:rgba(255,255,255,.02);border:1px solid var(--border);border-top:none;
  color:var(--text);font-size:10px;padding:9px;cursor:pointer;letter-spacing:1.5px;
  transition:all .2s;text-transform:uppercase;font-family:inherit}
.expbtn svg{width:11px;height:11px;transition:transform .3s;flex-shrink:0}
.expbtn:hover{background:rgba(255,255,255,.05);color:#fff}
.expbtn.isexp svg{transform:rotate(180deg)}
.wg{display:grid;grid-template-columns:repeat(auto-fit,minmax(160px,1fr));
  gap:1px;background:var(--border);margin-top:44px}
.wc{text-align:center;padding:32px 20px;background:var(--bg);
  transition:background .3s;position:relative;overflow:hidden}
.wc::after{content:'';position:absolute;bottom:0;left:0;right:0;height:2px;
  background:var(--red);transform:scaleX(0);transition:transform .3s;transform-origin:left}
.wc:hover{background:rgba(255,0,0,.04)}.wc:hover::after{transform:scaleX(1)}
.wn{font-size:9px;font-weight:800;letter-spacing:3px;
  color:rgba(255,0,0,.32);text-transform:uppercase;margin-bottom:16px}
.wi{width:44px;height:44px;margin:0 auto 16px;color:rgba(255,255,255,.3);transition:color .3s}
.wc:hover .wi{color:var(--red)}
.wc h4{font-size:13px;font-weight:800;margin-bottom:6px}
.wc p{font-size:11px;color:var(--text);line-height:1.6}
.mg{display:grid;grid-template-columns:1fr 1fr;gap:1px;
  background:var(--border);margin-top:44px}
.mc{background:var(--bg);padding:22px 24px;display:flex;align-items:flex-start;gap:14px;
  transition:background .25s;position:relative;overflow:hidden}
.mc::before{content:'';position:absolute;left:0;top:0;bottom:0;width:2px;
  background:var(--red);transform:scaleY(0);transition:transform .3s;transform-origin:top}
.mc:hover{background:rgba(255,0,0,.03)}.mc:hover::before{transform:scaleY(1)}
.mi{width:38px;height:38px;background:rgba(255,0,0,.07);
  border:1px solid rgba(255,0,0,.18);flex-shrink:0;
  display:flex;align-items:center;justify-content:center;color:var(--red)}
.mi svg{width:18px;height:18px}
.mc h4{font-size:13px;font-weight:700;margin-bottom:4px}
.mc p{font-size:11px;color:var(--text);line-height:1.55}
.ql{margin-top:40px;border:1px solid var(--border)}
.qi{display:grid;grid-template-columns:185px 1fr;
  border-bottom:1px solid var(--border);transition:background .2s}
.qi:last-child{border-bottom:none}
.qi:hover{background:rgba(255,255,255,.02)}
.qp{padding:18px 20px;font-family:var(--mono);font-size:11px;
  color:rgba(255,90,90,.8);border-right:1px solid var(--border);
  display:flex;align-items:center;line-height:1.5}
.qb{padding:18px 24px}
.qb h4{font-size:13px;font-weight:700;margin-bottom:4px}
.qb p{font-size:12px;color:var(--text);line-height:1.6}
.qb code{font-family:var(--mono);font-size:11px;
  color:rgba(255,120,120,.9);background:rgba(255,0,0,.08);
  padding:1px 5px;border:1px solid rgba(255,0,0,.14)}
.qd{display:inline-flex;align-items:center;gap:5px;margin-top:7px;
  font-size:10px;color:rgba(255,255,255,.28);font-family:var(--mono);letter-spacing:1px;
  background:rgba(255,255,255,.04);padding:2px 10px;border:1px solid var(--border)}
.qd::before{content:'default: ';color:rgba(255,0,0,.38);font-size:10px}
footer{text-align:center;padding:60px 24px;border-top:1px solid var(--border);
  color:var(--text);font-size:12px;position:relative;z-index:1}
footer strong{color:#fff}
footer a{color:rgba(255,0,0,.38);text-decoration:none;transition:color .2s}
footer a:hover{color:rgba(255,0,0,.75)}
::-webkit-scrollbar{width:6px}
::-webkit-scrollbar-thumb{background:rgba(255,0,0,.22);border-radius:3px}
@media(max-width:768px){
  nav a:not(.ngh){display:none}
  .hero,.wrap{padding-left:24px;padding-right:24px}
  .tbh{display:none}.mg,.qi{grid-template-columns:1fr}
  .qp{border-right:none;border-bottom:1px solid var(--border)}
}
"""

# SVG icons
ITERM = (
    '<svg class="tbi icon-term" viewBox="0 0 40 40" fill="none" stroke="currentColor" stroke-width="1.8">'
    '<rect x="3" y="5" width="34" height="30" rx="3"/>'
    '<line x1="3" y1="14" x2="37" y2="14"/>'
    '<circle cx="9" cy="9.5" r="1.5" fill="#ff5555" stroke="none"/>'
    '<circle cx="15" cy="9.5" r="1.5" fill="#ffb800" stroke="none"/>'
    '<circle cx="21" cy="9.5" r="1.5" fill="#00cc55" stroke="none"/>'
    '<path d="M10 22l5 3.5-5 3.5" stroke-linecap="round" stroke-linejoin="round"/>'
    '<line x1="19" y1="29" x2="30" y2="29" stroke-linecap="round"/>'
    '<rect class="cur" x="19" y="21" width="7" height="2.5" rx="1" fill="rgba(255,255,255,.55)" stroke="none"/>'
    '</svg>'
)
IVSC = (
    '<svg class="tbi icon-vsc" viewBox="0 0 40 40" fill="none" stroke="currentColor" stroke-width="2">'
    '<path class="vl" d="M28 6L8 21l20 13V6z" stroke-linejoin="round"/>'
    '<path class="vl" d="M8 21L3 17.5l5-5" stroke-linecap="round" stroke-linejoin="round" style="animation-delay:.15s"/>'
    '<line class="vl" x1="28" y1="6" x2="36" y2="10" stroke-linecap="round" style="animation-delay:.3s"/>'
    '<line class="vl" x1="36" y1="10" x2="36" y2="30" stroke-linecap="round" style="animation-delay:.5s"/>'
    '<line class="vl" x1="36" y1="30" x2="28" y2="34" stroke-linecap="round" style="animation-delay:.7s"/>'
    '</svg>'
)
IAI = (
    '<svg class="tbi icon-ai" viewBox="0 0 40 40" fill="none" stroke="currentColor" stroke-width="1.8">'
    '<path d="M20 4C11.16 4 4 9.92 4 17.2c0 3.71 1.76 7.07 4.64 9.5L8 36l7.2-2.37C16.73 33.87 18.33 34 20 34c8.84 0 16-5.92 16-16.8C36 9.92 28.84 4 20 4z"/>'
    '<circle class="dot" cx="13" cy="18" r="2.5" fill="currentColor" stroke="none"/>'
    '<circle class="dot" cx="20" cy="18" r="2.5" fill="currentColor" stroke="none"/>'
    '<circle class="dot" cx="27" cy="18" r="2.5" fill="currentColor" stroke="none"/>'
    '</svg>'
)
ICD = (
    '<svg class="tbi icon-cd" viewBox="0 0 40 40" fill="none" stroke="currentColor" stroke-width="2">'
    '<polyline class="br" points="15 10 5 20 15 30" stroke-linecap="round" stroke-linejoin="round"/>'
    '<polyline class="br" points="25 10 35 20 25 30" stroke-linecap="round" stroke-linejoin="round" style="animation-delay:.25s"/>'
    '<line class="sl" x1="22" y1="7" x2="18" y2="33" stroke-linecap="round"/>'
    '</svg>'
)
CPSVG = (
    '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">'
    '<rect x="9" y="9" width="13" height="13" rx="2"/>'
    '<path d="M5 15H4a2 2 0 01-2-2V4a2 2 0 012-2h9a2 2 0 012 2v1"/>'
    '</svg>'
)
WSVG = (
    '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">'
    '<path d="M10.29 3.86L1.82 18a2 2 0 001.71 3h16.94a2 2 0 001.71-3L13.71 3.86a2 2 0 00-3.42 0z"/>'
    '<line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/>'
    '</svg>'
)
GHSVG = (
    '<svg viewBox="0 0 24 24" fill="currentColor">'
    '<path d="M12 2C6.477 2 2 6.477 2 12c0 4.418 2.865 8.168 6.839 9.49.5.092.682-.217.682-.482'
    ' 0-.237-.009-.868-.013-1.703-2.782.604-3.369-1.34-3.369-1.34-.454-1.154-1.11-1.462-1.11-1.462'
    '-.908-.62.069-.608.069-.608 1.003.07 1.531 1.03 1.531 1.03.892 1.529 2.341 1.087 2.91.832'
    '.092-.647.35-1.088.636-1.338-2.22-.253-4.555-1.11-4.555-4.943 0-1.091.39-1.984 1.029-2.683'
    '-.103-.253-.446-1.27.098-2.647 0 0 .84-.269 2.75 1.025A9.578 9.578 0 0112 6.836a9.59 9.59 0'
    ' 012.504.337c1.909-1.294 2.747-1.025 2.747-1.025.546 1.377.203 2.394.1 2.647.64.699 1.028'
    ' 1.592 1.028 2.683 0 3.842-2.339 4.687-4.566 4.935.359.309.678.919.678 1.852 0 1.336-.012'
    ' 2.415-.012 2.741 0 .267.18.579.688.481C19.138 20.165 22 16.418 22 12c0-5.523-4.477-10-10-10z"/>'
    '</svg>'
)

JS = r"""
const cv=document.getElementById('cv'),cx=cv.getContext('2d');
let W,H,pts=[];
function initP(){pts=[];for(let i=0;i<85;i++)pts.push({
  x:Math.random()*W,y:Math.random()*H,
  vx:(Math.random()-.5)*.35,vy:(Math.random()-.5)*.35,
  r:Math.random()*.7+.25,o:Math.random()*.18+.04
});}
function resize(){W=cv.width=innerWidth;H=cv.height=innerHeight;initP();}
resize();window.addEventListener('resize',resize);
function drawP(){
  cx.clearRect(0,0,W,H);
  for(let i=0;i<pts.length;i++){
    const p=pts[i];
    for(let j=i+1;j<pts.length;j++){
      const q=pts[j],dx=p.x-q.x,dy=p.y-q.y,d=Math.hypot(dx,dy);
      if(d<110){cx.beginPath();cx.moveTo(p.x,p.y);cx.lineTo(q.x,q.y);
        cx.strokeStyle='rgba(255,0,0,'+(0.055*(1-d/110))+')';
        cx.lineWidth=.5;cx.stroke();}
    }
    cx.beginPath();cx.arc(p.x,p.y,p.r,0,Math.PI*2);
    cx.fillStyle='rgba(255,255,255,'+p.o+')';cx.fill();
    p.x+=p.vx;p.y+=p.vy;
    if(p.x<0||p.x>W)p.vx*=-1;if(p.y<0||p.y>H)p.vy*=-1;
  }
  requestAnimationFrame(drawP);
}
drawP();
const prog=document.getElementById('prog');
window.addEventListener('scroll',function(){
  prog.style.width=(scrollY/(document.body.scrollHeight-innerHeight)*100)+'%';
});
const ro=new IntersectionObserver(function(entries){
  entries.forEach(function(e,i){
    if(e.isIntersecting){setTimeout(function(){e.target.classList.add('vi')},i*55);ro.unobserve(e.target);}
  });
},{threshold:.06});
document.querySelectorAll('.rv').forEach(function(el){ro.observe(el);});
function switchTab(n){
  document.querySelectorAll('.tbtn').forEach(function(b,i){b.classList.toggle('act',i===n);});
  document.querySelectorAll('.tpanel').forEach(function(p,i){p.classList.toggle('act',i===n);});
}
function cbFeedback(btn){
  var o=btn.innerHTML;
  btn.innerHTML='<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" style="width:12px;height:12px"><polyline points="20 6 9 17 4 12"/></svg> Masiolva!';
  btn.classList.add('ok');
  setTimeout(function(){btn.innerHTML=o;btn.classList.remove('ok');},2200);
}
function copyMagic(btn){
  navigator.clipboard.writeText(document.getElementById('magic-irm').textContent.trim()).then(function(){
    var o=btn.innerHTML;
    btn.innerHTML='<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" style="width:16px;height:16px"><polyline points="20 6 9 17 4 12"/></svg> Masiolva!';
    btn.classList.add('ok');
    setTimeout(function(){btn.innerHTML=o;btn.classList.remove('ok');},2500);
  });
}
function cbId(btn,id){
  navigator.clipboard.writeText(document.getElementById(id).textContent.trim()).then(function(){cbFeedback(btn);});
}
function ccById(btn,id){
  navigator.clipboard.writeText(document.getElementById(id).textContent).then(function(){cbFeedback(btn);});
}
function dlById(id,name){
  var b=new Blob([document.getElementById(id).textContent],{type:'text/plain'});
  var a=document.createElement('a');a.href=URL.createObjectURL(b);a.download=name;a.click();URL.revokeObjectURL(a.href);
}
function expById(id,btn){
  var p=document.getElementById(id);
  p.classList.toggle('exp');btn.classList.toggle('isexp');
  for(var n=btn.childNodes,i=0;i<n.length;i++){
    if(n[i].nodeType===3){n[i].textContent=p.classList.contains('exp')?' Osszehuzas':' Osszes sor megjeleniteseee';break;}
  }
}
function ccPre(btn){
  var p=btn.closest('.cw').querySelector('pre');
  navigator.clipboard.writeText(p.textContent).then(function(){cbFeedback(btn);});
}
"""
# Fix the Hungarian chars in the JS (raw string doesn't support unicode escapes for non-ASCII)
JS = JS.replace('Masiolva!', 'M\u00e1solva!').replace('Osszehuzas', '\u00d6sszeh\u00faz\u00e1s').replace('Osszes sor megjeleniteseee', '\u00d6sszes sor megjelen\u00edt\u00e9se')

# ── Assemble HTML ──────────────────────────────────────────────────
parts = []
parts.append('<!DOCTYPE html>\n<html lang="hu">\n<head>\n<meta charset="UTF-8">\n<meta name="viewport" content="width=device-width,initial-scale=1">')
parts.append('<title>VS Code Wizard \u2014 Egy parancs, minden k\u00e9sz</title>')
parts.append('<style>' + CSS + '</style>')
parts.append('</head>\n<body>')
parts.append('<div id="prog"></div>\n<canvas id="cv"></canvas>')

# NAV
parts.append(
    '<nav>'
    '<div class="nl"><div class="nd"></div>VS&nbsp;<span style="color:var(--red)">Wizard</span></div>'
    '<a href="#hova">Beillleszt\u00e9s</a>'
    '<a href="#wizard">Wizard</a>'
    '<a href="#kerdesek">K\u00e9rd\u00e9sek</a>'
    '<a href="#script">Script</a>'
    '<div class="nr"><a class="ngh" href="https://github.com/koltainorbert/VisualCode-Munkakornyezet" target="_blank">'
    + GHSVG + 'GitHub</a></div></nav>'
)

# HERO
parts.append(
    '<div class="hero">'
    '<div class="he"><div class="hel"></div>VS Code Munkak\u00f6zeg\u00a0\u00b7\u00a0Wizard v2.0</div>'
    '<h1 class="ht">'
    '<span class="ln"><span class="wd">Egy parancs</span></span>'
    '<span class="ln"><span class="wd r">\u2014 minden</span></span>'
    '<span class="ln"><span class="wd">k\u00e9sz.</span></span>'
    '</h1>'
    '<p class="hs">WordPress, HTML, React, Vue, Node.js, Laravel \u2014 b\u00e1rmilyen projekthez. A wizard megk\u00e9rdez mindent, be\u00e1ll\u00edt mindent: Git, auto-ment\u00e9s, Browser Sync, Task Scheduler, deploy.</p>'
)

# Magic box  
parts.append(
    '<div class="mb"><div class="mbi">'
    '<div class="mbl">'
    '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 12v8a2 2 0 002 2h12a2 2 0 002-2v-8"/><polyline points="16 6 12 2 8 6"/><line x1="12" y1="2" x2="12" y2="15"/></svg>'
    'Var\u00e1zsparancs \u2014 m\u00e1sold be \u00e9s futtasd'
    '</div>'
    '<div class="mbr">'
    '<div class="mbc"><span class="kw">irm</span> <span class="str" id="magic-irm">&quot;' + URL + '&quot;</span> <span class="kw">|</span> iex</div>'
    '<button class="mcp" onclick="copyMagic(this)">' + CPSVG + 'M\u00e1sol\u00e1s</button>'
    '</div>'
    '<div class="mbf">'
    '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><path d="M12 8v4m0 4h.01"/></svg>'
    '<span>Win+R \u2192 <code style="font-family:var(--mono);color:rgba(255,130,80,.9);font-size:10px">powershell</code> \u2192 Enter \u2192 fekete ablakba illeszd be\u00a0|\u00a0<a href="#hova">R\u00e9szletes \u00fatmutat\u00f3 \u2193</a></span>'
    '</div>'
    '</div></div>'
)

# Hero CTA
parts.append(
    '<div class="hc">'
    '<a href="#hova" class="btn btn-r"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="6 9 12 15 18 9"/></svg>Hova illesztem be?</a>'
    '<a href="#wizard" class="btn btn-g"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><path d="M12 8v8m-4-4h8"/></svg>Mit csin\u00e1l a wizard?</a>'
    '<a href="https://github.com/koltainorbert/VisualCode-Munkakornyezet" target="_blank" class="btn btn-g">'
    + GHSVG + 'GitHub repo</a>'
    '</div>'
)
parts.append('</div>')  # /hero

parts.append('<hr class="d">')

# ── SECTION HOVA ──────────────────────────────────────────────────
parts.append('<section id="hova"><div class="wrap">')
parts.append('<div class="se rv">H\u00e1rom + egy lehet\u0151s\u00e9g</div>')
parts.append('<h2 class="st rv">Hova illeszted be?</h2>')
parts.append('<p class="ss rv">Ugyanaz a parancs \u2014 n\u00e9gy k\u00fcl\u00f6nb\u00f6z\u0151 helyr\u0151l futtathat\u00f3. Vagy a teljes k\u00f3d offline, GitHub n\u00e9lk\u00fcl.</p>')

parts.append('<div class="rv"><div class="tbs">')
parts.append(
    '<button class="tbtn act" onclick="switchTab(0)">' + ITERM +
    '<span class="tbn">PowerShell</span><span class="tbh">Win+R \u2192 powershell</span></button>'
)
parts.append(
    '<button class="tbtn" onclick="switchTab(1)">' + IVSC +
    '<span class="tbn">VS Code Terminal</span><span class="tbh">Ctrl+` a VS Code-ban</span></button>'
)
parts.append(
    '<button class="tbtn" onclick="switchTab(2)">' + IAI +
    '<span class="tbn">Copilot Chat</span><span class="tbh">Copilot Agent Mode</span></button>'
)
parts.append(
    '<button class="tbtn" onclick="switchTab(3)">' + ICD +
    '<span class="tbn">Teljes k\u00f3d</span><span class="tbh">Offline, GitHub n\u00e9lk\u00fcl</span></button>'
)
parts.append('</div><div class="tpanels">')

# Panel 0
parts.append('<div class="tpanel act" id="tp-0">')
parts.append(
    '<div class="warn">' + WSVG +
    '<p><strong>Win+R-ba NEM az <code>irm</code> parancsot kell be\u00edrni!</strong><br>'
    'Win+R egy sima futtat\u00f3ablak \u2014 nem ismeri a PowerShell parancsokat. El\u0151bb PowerShell-t kell megnyitni, aztán a fekete ablakba illeszteni az <code>irm</code> parancsot.</p></div>'
)
parts.append(
    '<div class="mbb"><div class="ml">1. m\u00f3dszer \u2014 K\u00e9t l\u00e9p\u00e9s (aj\u00e1nlott)</div>'
    '<div class="stps">'
    '<div class="si"><div class="sn">1</div><p><strong>Win+R</strong> \u2192 g\u00e9peld: <var>powershell</var> \u2192 Enter\u00a0(megnyílik a fekete PS ablak)</p></div>'
    '<div class="si"><div class="sn">2</div><p>A fekete ablakba illeszd be (Ctrl+V) \u2192 Enter \u2192 wizard elindul</p></div>'
    '</div>'
    '<div class="cr"><code id="cmd-irm">' + IRM + '</code>'
    '<button class="cbtn" onclick="cbId(this,\'cmd-irm\')">' + CPSVG + ' M\u00e1sol\u00e1s</button></div></div>'
)
parts.append(
    '<div class="mbb"><div class="ml">2. m\u00f3dszer \u2014 Win+R-b\u00f3l egyből (egy l\u00e9p\u00e9s)</div>'
    '<div class="stps">'
    '<div class="si"><div class="sn">1</div><p><strong>Win+R</strong> \u2192 illeszd be az al\u00e1bbi <em>teljes</em> parancsot \u2192 Enter (automatikusan PS-t nyit \u00e9s futtatja)</p></div>'
    '</div>'
    '<div class="cr"><code id="cmd-winr">' + WINR + '</code>'
    '<button class="cbtn" onclick="cbId(this,\'cmd-winr\')">' + CPSVG + ' M\u00e1sol\u00e1s</button></div></div>'
)
parts.append('</div>')  # /tp-0

# Panel 1
parts.append('<div class="tpanel" id="tp-1">')
parts.append(
    '<div class="stps" style="margin-bottom:20px">'
    '<div class="si"><div class="sn">1</div><p>VS Code-ban <strong>Ctrl+`</strong> \u2192 megnyílik az integr\u00e1lt termin\u00e1l</p></div>'
    '<div class="si"><div class="sn">2</div><p>Gy\u0151z\u0151dj meg r\u00f3la, hogy <strong>PowerShell</strong> fut (termin\u00e1l fejl\u00e9c\u00e9ben l\u00e1that\u00f3)</p></div>'
    '<div class="si"><div class="sn">3</div><p>Illeszd be (Ctrl+V) \u2192 Enter \u2192 wizard elindul</p></div>'
    '</div>'
    '<div class="cr"><code id="cmd-vsc">' + IRM + '</code>'
    '<button class="cbtn" onclick="cbId(this,\'cmd-vsc\')">' + CPSVG + ' M\u00e1sol\u00e1s</button></div>'
)
parts.append('</div>')  # /tp-1

# Panel 2
parts.append('<div class="tpanel" id="tp-2">')
parts.append(
    '<div class="stps" style="margin-bottom:20px">'
    '<div class="si"><div class="sn">1</div><p>VS Code-ban <strong>Ctrl+Alt+I</strong> \u2192 Copilot Chat megnyílik</p></div>'
    '<div class="si"><div class="sn">2</div><p>Az <strong>Agent Mode</strong> legyen aktív (legu00f6rdu0151 a chat beviteli mez\u0151 mellett)</p></div>'
    '<div class="si"><div class="sn">3</div><p>Illeszd be az al\u00e1bbi parancsot \u2192 Enter \u2192 Copilot futtatja a termin\u00e1lban</p></div>'
    '<div class="si"><div class="sn">4</div><p>Ha felugr\u00f3 k\u00e9ri a j\u00f3v\u00e1hagy\u00e1st, kattints <strong>Continue</strong></p></div>'
    '</div>'
    '<div class="cr"><code id="cmd-cpl">' + CPL + '</code>'
    '<button class="cbtn" onclick="cbId(this,\'cmd-cpl\')">' + CPSVG + ' M\u00e1sol\u00e1s</button></div>'
)
parts.append('</div>')  # /tp-2

# Panel 3 — inline PS1
parts.append('<div class="tpanel" id="tp-3">')
parts.append(
    '<div class="stps" style="margin-bottom:20px">'
    '<div class="si"><div class="sn">!</div><p>Nincs internet, nincs GitHub \u2014 a <strong>teljes 920 soros wizard script</strong> be\u00e1gyazva itt van</p></div>'
    '<div class="si"><div class="sn">1</div><p><strong>M\u00c1SOL\u00c1S</strong> gomb \u2192 nyiss PowerShell ablakot \u2192 illeszd be \u2192 Enter</p></div>'
    '<div class="si"><div class="sn">2</div><p>Vagy: <strong>LET\u00d6LT\u00c9S .ps1</strong> \u2192 ments el \u2192 <var>powershell -ExecutionPolicy Bypass -File setup-projekt.ps1</var></p></div>'
    '</div>'
)
parts.append(
    '<div class="cw">'
    '<div class="ch">'
    '<div class="clg"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="2" y="3" width="20" height="18" rx="2"/><path d="m6 8 4 4-4 4M12 16h6"/></svg>'
    'setup-projekt.ps1 &mdash; teljes wizard (920 sor)</div>'
    '<div class="ca">'
    '<button class="csm" onclick="ccById(this,\'ps1-inline\')">M\u00e1sol\u00e1s</button>'
    '<button class="csm" onclick="dlById(\'ps1-inline\',\'setup-projekt.ps1\')">Let\u00f6lt\u00e9s .ps1</button>'
    '</div></div>'
)
parts.append('<pre id="ps1-inline" class="cpre">' + PS1 + '</pre>')
parts.append(
    '<button class="expbtn" id="exp-ps1" onclick="expById(\'ps1-inline\',this)">'
    '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="6 9 12 15 18 9"/></svg>'
    ' \u00d6sszes sor megjelen\u00edt\u00e9se</button>'
    '</div>'  # /cw
)
parts.append('</div>')  # /tp-3
parts.append('</div></div>')  # /tpanels  /rv
parts.append('</div></section><hr class="d">')

# ── WIZARD SECTION ─────────────────────────────────────────────────
def wcard(num, svg_d, title, desc):
    return (
        '<div class="wc"><div class="wn">' + num + '</div>'
        '<div class="wi"><svg viewBox="0 0 44 44" fill="none" stroke="currentColor" stroke-width="1.8">' + svg_d + '</svg></div>'
        '<h4>' + title + '</h4><p>' + desc + '</p></div>'
    )

def mcard(svg_d, title, desc):
    return (
        '<div class="mc"><div class="mi"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">' + svg_d + '</svg></div>'
        '<div><h4>' + title + '</h4><p>' + desc + '</p></div></div>'
    )

parts.append('<section id="wizard"><div class="wrap">')
parts.append('<div class="se rv">Automatikus folyamat</div>')
parts.append('<h2 class="st rv">Mit csin\u00e1l a wizard?</h2>')
parts.append('<p class="ss rv">Egy PowerShell parancs \u2014 \u00f6t l\u00e9p\u00e9s \u2014 teljesen fel\u00e9p\u00edtett fejleszt\u0151i k\u00f6rnyezet b\u00e1rmilyen projekthez.</p>')
parts.append('<div class="wg rv">')
parts.append(wcard('01', '<circle cx="22" cy="22" r="18"/><path d="M15 22h14M22 15v14" stroke-linecap="round"/>', 'K\u00e9rd\u00e9sek', 'Projekt neve, mappa, GitHub URL, t\u00edpus, proxy \u2014 Enter = alapértelmezett'))
parts.append(wcard('02', '<path d="M8 38V16l14-8 14 8v22H8z"/><path d="M16 38V28h12v10"/>', 'F\u00e1jlok \u00edr\u00e1sa', 'tasks.json, naplo-watcher.ps1, autosave.ps1 \u2014 mind a te adataiddal kit\u00f6ltve'))
parts.append(wcard('03', '<circle cx="22" cy="8" r="4"/><circle cx="8" cy="36" r="4"/><circle cx="36" cy="36" r="4"/><line x1="22" y1="12" x2="22" y2="24"/><line x1="22" y1="24" x2="8" y2="32"/><line x1="22" y1="24" x2="36" y2="32"/>', 'Git init', 'git init, első commit, GitHub push, develop / staging / main branch'))
parts.append(wcard('04', '<rect x="6" y="8" width="32" height="28" rx="3"/><path d="M14 22l6 6 10-12" stroke-linecap="round" stroke-linejoin="round"/>', 'Task Scheduler', 'Windows Task-ba bejegyzi az 5 perces auto-push taskot \u2014 VS Code n\u00e9lk\u00fcl is fut'))
parts.append(wcard('k\u00e9sz!', '<polygon points="22 4 28 16 42 18 32 28 34 42 22 36 10 42 12 28 2 18 16 16"/>', 'VS Code megnyit', 'Taskok akt\u00edvak, auto-ment\u00e9s fut, Browser Sync elindul \u2014 munka kezdhet\u0151'))
parts.append('</div>')

parts.append('<div style="margin-top:72px">')
parts.append('<div class="se rv" style="margin-bottom:14px">Gener\u00e1lt f\u00e1jlok</div>')
parts.append('<h3 class="rv" style="font-size:22px;font-weight:800;letter-spacing:-.5px;margin-bottom:4px">Mind a te adataiddal kit\u00f6ltve</h3>')
parts.append('<p class="rv" style="font-size:13px;color:var(--text)">Nem template \u2014 val\u00f3di \u00e9rt\u00e9kekkel, az \u00e1ltald megadott mappa \u00e9s projekt n\u00e9vvel.</p>')
parts.append('<div class="mg rv" style="margin-top:28px">')
parts.append(mcard('<path d="M14 2H6a2 2 0 00-2 2v16a2 2 0 002 2h12a2 2 0 002-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/>',
    '.vscode/tasks.json', 'Push (Ctrl+Shift+B), Pull, Visszag\u00f6rget\u00e9s, Napl\u00f3 Watcher, Browser Sync, Branch'))
parts.append(mcard('<rect x="2" y="3" width="20" height="18" rx="2"/><path d="m6 8 4 4-4 4"/><line x1="12" y1="16" x2="18" y2="16"/>',
    'naplo-watcher.ps1', 'Percenk\u00e9nti auto-push \u2014 VS Code megnyit\u00e1sakor automatikusan elindul'))
parts.append(mcard('<circle cx="12" cy="12" r="3"/><path d="M12 1v4M12 19v4M4.22 4.22l2.83 2.83M16.95 16.95l2.83 2.83M1 12h4M19 12h4M4.22 19.78l2.83-2.83M16.95 7.05l2.83-2.83"/>',
    'autosave-background.ps1', '5 perces Windows Task Scheduler script \u2014 VS Code n\u00e9lk\u00fcl is fut a h\u00e1tt\u00e9rben'))
parts.append(mcard('<circle cx="12" cy="18" r="3"/><circle cx="6" cy="6" r="3"/><circle cx="18" cy="6" r="3"/><path d="M18 9v1a2 2 0 01-2 2H8a2 2 0 01-2-2V9M12 15v-3"/>',
    'Git + GitHub + Branches', 'git init, el\u0151 commit, push, develop / staging / main branch rendszer fell\u00e1ll\u00edt\u00e1sa'))
parts.append(mcard('<path d="M14 2H6a2 2 0 00-2 2v16a2 2 0 002 2h12a2 2 0 002-2V8z"/><polyline points="14 2 14 8 20 8"/>',
    'NAPLO.md', 'Fejleszt\u00e9si napl\u00f3 \u2014 push el\u0151tt automatikusan friss\u00fcl a m\u00f3dos\u00edt\u00e1sok list\u00e1j\u00e1val'))
parts.append(mcard('<path d="M22 12h-4l-3 9L9 3l-3 9H2"/>',
    '.github/workflows/deploy.yml', 'FTP auto-deploy template \u2014 main push \u2192 \u00e9les szerver (4 GitHub Secret kell)'))
parts.append('</div></div>')
parts.append('</div></section><hr class="d">')

# ── KÉRDÉSEK SECTION ───────────────────────────────────────────────
def qi(prompt, h4, p_html, default=''):
    d = ('<div class="qd">' + default + '</div>') if default else ''
    return '<div class="qi"><div class="qp">' + prompt + '</div><div class="qb"><h4>' + h4 + '</h4><p>' + p_html + '</p>' + d + '</div></div>'

parts.append('<section id="kerdesek"><div class="wrap">')
parts.append('<div class="se rv">Interakt\u00edv wizard</div>')
parts.append('<h2 class="st rv">Milyen k\u00e9rd\u00e9seket tesz fel?</h2>')
parts.append('<p class="ss rv">8 k\u00e9rd\u00e9s \u2014 Enter = alapértelmezett \u00e9rt\u00e9k. Minden k\u00e9rd\u00e9sn\u00e9l egy sor a v\u00e1lasz.</p>')
parts.append('<div class="ql rv">')
parts.append(qi('&gt;&gt; Projekt neve', 'Projekt neve', 'Pl: <code>WebshopProjekt</code> \u2014 commit neve \u00e9s Task Scheduler task neve is'))
parts.append(qi('&gt;&gt; Mappa', 'Projekt mappa teljes el\u00e9r\u00e9si \u00fatja', 'Pl: <code>C:\\\\projektek\\\\mywebshop</code> \u2014 ha nem l\u00e9tezik, l\u00e9trehozza', 'aktu\u00e1lis mappa'))
parts.append(qi('&gt;&gt; GitHub URL', 'GitHub repo URL', 'Pl: <code>https://github.com/neved/repo.git</code> \u2014 \u00fcresen hagyhat\u00f3, push akkor nem fut'))
parts.append(qi('&gt;&gt; Tipus [2]', 'Projekt t\u00edpusa', '[1] WordPress &nbsp; [2] HTML/CSS/JS &nbsp; [3] React/Vue &nbsp; [4] Node.js &nbsp; [5] Laravel &nbsp; [6] Egy\u00e9b', '2'))
parts.append(qi('&gt;&gt; Proxy URL', 'Browser Sync proxy (WP/Laravel eset\u00e9n)', 'WordPress: <code>myproject.local</code> \u2014 HTML/React eset\u00e9n automatikusan <code>--server</code> m\u00f3d'))
parts.append(qi('&gt;&gt; Port [3000]', 'Browser Sync port', 'Alapértelmezett: 3000 \u2014 ha m\u00e1s portot haszn\u00e1l valamid, m\u00f3dos\u00edthat\u00f3', '3000'))
parts.append(qi('&gt;&gt; FTP? [n]', 'FTP auto-deploy', '<code>i</code> = l\u00e9trehozza a deploy.yml-t. A jelsz\u00f3t NEM k\u00e9ri \u2014 GitHub Secrets-be ker\u00fcl', 'n'))
parts.append(qi('&gt;&gt; Branch? [i]', 'Branch rendszer', '<code>i</code> = l\u00e9trehozza \u00e9s pushol develop / staging / main branch-et. Fejleszt\u00e9s develop \u00e1gon.', 'i'))
parts.append('</div></div></section><hr class="d">')

# ── SCRIPT SECTION ─────────────────────────────────────────────────
DEPLOY_YML = (
    'name: Deploy - Eles szerver\n\n'
    'on:\n  push:\n    branches: [ main ]\n\n'
    'jobs:\n  deploy:\n    runs-on: ubuntu-latest\n    steps:\n'
    '      - name: Checkout\n        uses: actions/checkout@v4\n\n'
    '      - name: FTP Deploy\n        uses: SamKirkland/FTP-Deploy-Action@v4.3.4\n        with:\n'
    '          server: ${{ secrets.FTP_SERVER }}\n'
    '          username: ${{ secrets.FTP_USERNAME }}\n'
    '          password: ${{ secrets.FTP_PASSWORD }}\n'
    '          server-dir: ${{ secrets.FTP_SERVER_DIR }}\n'
    '          exclude: |\n'
    '            **/.git*\n            **/.git*/**\n'
    '            **/node_modules/**\n            **/.vscode/**'
)

parts.append('<section id="script"><div class="wrap">')
parts.append('<div class="se rv">Forr\u00e1sk\u00f3d</div>')
parts.append('<h2 class="st rv">deploy.yml \u2014 FTP auto-deploy</h2>')
parts.append('<p class="ss rv">A wizard gener\u00e1lja \u2014 4 GitHub Secret be\u00edr\u00e1sa ut\u00e1n automatikus az \u00e9les deploy main branchre push eset\u00e9n.</p>')
parts.append(
    '<div class="cw rv">'
    '<div class="ch"><div class="clg">'
    '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 12h-4l-3 9L9 3l-3 9H2"/></svg>'
    '.github/workflows/deploy.yml</div>'
    '<div class="ca"><button class="csm" onclick="ccPre(this)">M\u00e1sol\u00e1s</button></div></div>'
    '<pre id="deploy-src" class="cpre" style="max-height:none">' + DEPLOY_YML + '</pre>'
    '</div>'
)
parts.append('</div></section>')

# FOOTER
parts.append(
    '<footer><div class="wrap">'
    '<strong>VS Code Munkak\u00f6zeg Wizard</strong> &nbsp;&middot;&nbsp; v3.0 &nbsp;&middot;&nbsp; '
    '<span style="color:var(--red)">2026</span><br>'
    '<a href="https://github.com/koltainorbert/VisualCode-Munkakornyezet" target="_blank" style="margin-top:10px;display:inline-block">'
    'github.com/koltainorbert/VisualCode-Munkakornyezet</a>'
    '</div></footer>'
)

# JS
parts.append('<script>' + JS + '</script>')
parts.append('</body>\n</html>')

html = '\n'.join(parts)
out = 'C:/Users/SDH/VisualCode-Munkakornyezet/DEV-RENDSZER.html'
open(out, 'w', encoding='utf-8').write(html)
print('OK -- meret:', len(html), 'karakter,', html.count('\n'), 'sor')
