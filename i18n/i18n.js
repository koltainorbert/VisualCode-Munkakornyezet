/**
 * SDH i18n Engine v1.0
 * IP-alapú auto-detektálás + Google Translate batch fordítás
 * Minden oldalon használható: <script src="/i18n/i18n.js"></script>
 */
(function(){
'use strict';

var DEFAULT_LANG = 'hu';
var CACHE_VER = '2';

var LANGS_BASIC = [
  { code:'hu', name:'Magyar',    flag:'🇭🇺' },
  { code:'en', name:'English',   flag:'🇬🇧' },
  { code:'de', name:'Deutsch',   flag:'🇩🇪' },
  { code:'fr', name:'Français',  flag:'🇫🇷' },
  { code:'es', name:'Español',   flag:'🇪🇸' }
];

var LANGS_ALL = [
  { code:'af', name:'Afrikaans',    flag:'🇿🇦' },
  { code:'sq', name:'Shqip',        flag:'🇦🇱' },
  { code:'ar', name:'العربية',      flag:'🇸🇦' },
  { code:'hy', name:'Հայերեն',      flag:'🇦🇲' },
  { code:'az', name:'Azərbaycan',   flag:'🇦🇿' },
  { code:'be', name:'Беларуская',   flag:'🇧🇾' },
  { code:'bn', name:'বাংলা',        flag:'🇧🇩' },
  { code:'bs', name:'Bosanski',     flag:'🇧🇦' },
  { code:'bg', name:'Български',    flag:'🇧🇬' },
  { code:'ca', name:'Català',       flag:'🏴' },
  { code:'zh', name:'中文',         flag:'🇨🇳' },
  { code:'hr', name:'Hrvatski',     flag:'🇭🇷' },
  { code:'cs', name:'Čeština',      flag:'🇨🇿' },
  { code:'da', name:'Dansk',        flag:'🇩🇰' },
  { code:'nl', name:'Nederlands',   flag:'🇳🇱' },
  { code:'et', name:'Eesti',        flag:'🇪🇪' },
  { code:'fi', name:'Suomi',        flag:'🇫🇮' },
  { code:'ka', name:'ქართული',      flag:'🇬🇪' },
  { code:'el', name:'Ελληνικά',     flag:'🇬🇷' },
  { code:'gu', name:'ગુજરાતી',      flag:'🇮🇳' },
  { code:'he', name:'עברית',        flag:'🇮🇱' },
  { code:'hi', name:'हिन्दी',       flag:'🇮🇳' },
  { code:'id', name:'Indonesia',    flag:'🇮🇩' },
  { code:'it', name:'Italiano',     flag:'🇮🇹' },
  { code:'ja', name:'日本語',       flag:'🇯🇵' },
  { code:'ko', name:'한국어',       flag:'🇰🇷' },
  { code:'lv', name:'Latviešu',     flag:'🇱🇻' },
  { code:'lt', name:'Lietuvių',     flag:'🇱🇹' },
  { code:'mk', name:'Македонски',   flag:'🇲🇰' },
  { code:'ms', name:'Melayu',       flag:'🇲🇾' },
  { code:'mt', name:'Malti',        flag:'🇲🇹' },
  { code:'no', name:'Norsk',        flag:'🇳🇴' },
  { code:'fa', name:'فارسی',        flag:'🇮🇷' },
  { code:'pl', name:'Polski',       flag:'🇵🇱' },
  { code:'pt', name:'Português',    flag:'🇵🇹' },
  { code:'ro', name:'Română',       flag:'🇷🇴' },
  { code:'ru', name:'Русский',      flag:'🇷🇺' },
  { code:'sr', name:'Srpski',       flag:'🇷🇸' },
  { code:'sk', name:'Slovenčina',   flag:'🇸🇰' },
  { code:'sl', name:'Slovenščina',  flag:'🇸🇮' },
  { code:'sw', name:'Kiswahili',    flag:'🇹🇿' },
  { code:'sv', name:'Svenska',      flag:'🇸🇪' },
  { code:'tl', name:'Filipino',     flag:'🇵🇭' },
  { code:'ta', name:'தமிழ்',        flag:'🇮🇳' },
  { code:'te', name:'తెలుగు',       flag:'🇮🇳' },
  { code:'th', name:'ไทย',          flag:'🇹🇭' },
  { code:'tr', name:'Türkçe',       flag:'🇹🇷' },
  { code:'uk', name:'Українська',   flag:'🇺🇦' },
  { code:'ur', name:'اردو',         flag:'🇵🇰' },
  { code:'vi', name:'Tiếng Việt',   flag:'🇻🇳' }
];

var COUNTRY_LANG = {
  HU:'hu', GB:'en', US:'en', AU:'en', CA:'en', NZ:'en', IE:'en',
  DE:'de', AT:'de',
  FR:'fr', BE:'fr',
  ES:'es', MX:'es', AR:'es', CO:'es', CL:'es', PE:'es',
  IT:'it', CN:'zh', TW:'zh', JP:'ja', KR:'ko', RU:'ru',
  UA:'uk', PL:'pl', CZ:'cs', SK:'sk', RO:'ro', BG:'bg',
  HR:'hr', RS:'sr', SI:'sl', BA:'bs', AL:'sq', GR:'el',
  TR:'tr', NL:'nl', SE:'sv', NO:'no', DK:'da', FI:'fi',
  PT:'pt', BR:'pt', IL:'he', SA:'ar', AE:'ar', EG:'ar',
  IN:'hi', PK:'ur', BD:'bn', TH:'th', VN:'vi', ID:'id',
  MY:'ms', PH:'tl', IR:'fa', GE:'ka', AM:'hy'
};

var _currentLang = DEFAULT_LANG;
var _originals = []; /* [{node, text}] */
var _nodesSnapshot = null;

/* ── utils ── */
function getLangInfo(code) {
  var found = LANGS_BASIC.filter(function(l){ return l.code===code; })[0];
  if (!found) found = LANGS_ALL.filter(function(l){ return l.code===code; })[0];
  return found || { code:code, name:code.toUpperCase(), flag:'🌐' };
}

/* ── CSS inject ── */
function injectStyles() {
  if (document.getElementById('sdh-i18n-css')) return;
  var s = document.createElement('style');
  s.id = 'sdh-i18n-css';
  s.textContent = [
    /* nav-ba ágyazott widget */
    '#sdh-lw{position:relative;display:flex;align-items:center;font-family:Arial,Helvetica,sans-serif;margin-left:8px;}',
    '#sdh-lbtn{display:flex;align-items:center;gap:6px;background:transparent;',
    '  border:1.5px solid rgba(255,0,0,.45);border-radius:8px;padding:6px 12px;',
    '  cursor:pointer;color:#fff;font-size:11px;font-weight:700;letter-spacing:1px;',
    '  transition:border-color .2s,background .2s;position:relative;outline:none;white-space:nowrap;}',
    '#sdh-lbtn:hover{border-color:#ff0000;background:rgba(255,0,0,.08);}',
    '#sdh-lflag{font-size:16px;line-height:1;}',
    '#sdh-lcode{font-size:10px;color:#ff0000;letter-spacing:2px;}',
    /* dropdown lefelé nyílik */
    '#sdh-lpanel{position:absolute;top:calc(100% + 10px);right:0;',
    '  background:rgb(6,6,6);border:1.5px solid rgba(255,0,0,.35);border-radius:12px;',
    '  padding:14px;min-width:220px;display:none;z-index:99999;',
    '  box-shadow:0 8px 40px rgba(0,0,0,.9),0 0 0 1px rgba(255,0,0,.08);}',
    '#sdh-lpanel.open{display:block;}',
    '.sdh-ltitle{font-size:9px;letter-spacing:3px;text-transform:uppercase;',
    '  color:rgba(255,0,0,.8);margin-bottom:10px;font-weight:700;}',
    '.sdh-lgrid{display:grid;grid-template-columns:1fr 1fr;gap:5px;margin-bottom:8px;}',
    '.sdh-li{display:flex;align-items:center;gap:7px;padding:6px 9px;border-radius:7px;',
    '  border:1px solid rgba(255,255,255,.07);cursor:pointer;',
    '  transition:background .15s,border-color .15s;font-size:12px;color:#fff;background:transparent;}',
    '.sdh-li:hover{background:rgba(255,0,0,.1);border-color:rgba(255,0,0,.4);}',
    '.sdh-li.on{border-color:#ff0000;background:rgba(255,0,0,.12);}',
    '.sdh-lf{font-size:15px;}',
    '.sdh-lhr{height:1px;background:rgba(255,255,255,.08);margin:8px 0;}',
    '#sdh-lsearch{width:100%;background:rgba(255,255,255,.05);',
    '  border:1px solid rgba(255,255,255,.12);border-radius:7px;padding:7px 10px;',
    '  color:#fff;font-size:12px;outline:none;transition:border-color .2s;box-sizing:border-box;}',
    '#sdh-lsearch::placeholder{color:rgba(255,255,255,.3);}',
    '#sdh-lsearch:focus{border-color:rgba(255,0,0,.5);}',
    '#sdh-lresults{display:flex;flex-direction:column;gap:3px;max-height:160px;',
    '  overflow-y:auto;margin-top:7px;}',
    '#sdh-lresults::-webkit-scrollbar{width:3px;}',
    '#sdh-lresults::-webkit-scrollbar-thumb{background:rgba(255,0,0,.4);border-radius:2px;}',
    '.sdh-lri{display:flex;align-items:center;gap:8px;padding:6px 10px;border-radius:6px;',
    '  cursor:pointer;font-size:12px;color:#fff;transition:background .12s;}',
    '.sdh-lri:hover{background:rgba(255,0,0,.1);}',
    '.sdh-lri.on{color:#ff0000;}',
    '#sdh-lloader{display:none;position:fixed;top:70px;right:16px;',
    '  background:rgb(6,6,6);border:1px solid rgba(255,0,0,.5);',
    '  border-radius:8px;padding:8px 16px;font-size:11px;color:#ff0000;',
    '  letter-spacing:2px;z-index:99998;font-family:Arial,Helvetica,sans-serif;',
    '  box-shadow:0 4px 20px rgba(0,0,0,.6);animation:sdh-lp 1s ease infinite;}',
    '@keyframes sdh-lp{0%,100%{opacity:1;}50%{opacity:.4;}}'
  ].join('');
  document.head.appendChild(s);
}

/* ── widget HTML ── */
function injectWidget() {
  if (document.getElementById('sdh-lw')) return;
  var w = document.createElement('div');
  w.id = 'sdh-lw';
  w.setAttribute('data-no-translate','');
  w.innerHTML =
    '<button id="sdh-lbtn" title="Nyelv / Language">' +
      '<span id="sdh-lflag">🇭🇺</span>' +
      '<span id="sdh-lcode">HU</span>' +
      '<svg width="8" height="8" viewBox="0 0 10 10" style="opacity:.45;flex-shrink:0">' +
        '<path d="M2 3.5L5 6.5L8 3.5" stroke="#fff" stroke-width="1.5" fill="none" stroke-linecap="round"/>' +
      '</svg>' +
    '</button>' +
    '<div id="sdh-lpanel">' +
      '<div class="sdh-ltitle">🌐 Nyelv / Language</div>' +
      '<div class="sdh-lgrid" id="sdh-lgrid"></div>' +
      '<div class="sdh-lhr"></div>' +
      '<input id="sdh-lsearch" type="text" placeholder="Keress… / Search language…">' +
      '<div id="sdh-lresults"></div>' +
    '</div>' +
    '<div id="sdh-lloader">⏳ FORDÍTÁS…</div>';

  /* nav-ba illesztés, fallback: body */
  var nav = document.querySelector('nav');
  if (nav) {
    var nr = nav.querySelector('.nr');
    if (nr) nr.insertBefore(w, nr.firstChild);
    else nav.appendChild(w);
  } else {
    w.style.cssText = 'position:fixed;bottom:24px;right:24px;z-index:99999;';
    document.body.appendChild(w);
  }

  /* 5 alap flag */
  var grid = document.getElementById('sdh-lgrid');
  LANGS_BASIC.forEach(function(l) {
    var el = document.createElement('div');
    el.className = 'sdh-li' + (l.code===_currentLang ? ' on' : '');
    el.dataset.code = l.code;
    el.innerHTML = '<span class="sdh-lf">' + l.flag + '</span><span>' + l.name + '</span>';
    el.addEventListener('click', function(){ switchLang(l.code); });
    grid.appendChild(el);
  });

  /* kereső */
  var search = document.getElementById('sdh-lsearch');
  var results = document.getElementById('sdh-lresults');
  search.addEventListener('input', function() {
    var q = this.value.toLowerCase().trim();
    results.innerHTML = '';
    if (!q) return;
    var all = LANGS_BASIC.concat(LANGS_ALL);
    var filtered = all.filter(function(l) {
      return l.name.toLowerCase().indexOf(q) !== -1 || l.code.toLowerCase().indexOf(q) !== -1;
    }).slice(0, 12);
    filtered.forEach(function(l) {
      var el = document.createElement('div');
      el.className = 'sdh-lri' + (l.code===_currentLang ? ' on' : '');
      el.innerHTML = l.flag + ' ' + l.name +
        '<span style="opacity:.35;margin-left:auto;font-size:10px">' + l.code.toUpperCase() + '</span>';
      el.addEventListener('click', function() {
        switchLang(l.code);
        search.value = '';
        results.innerHTML = '';
      });
      results.appendChild(el);
    });
  });

  /* panel toggle */
  document.getElementById('sdh-lbtn').addEventListener('click', function(e) {
    e.stopPropagation();
    document.getElementById('sdh-lpanel').classList.toggle('open');
  });
  document.addEventListener('click', function() {
    var p = document.getElementById('sdh-lpanel');
    if (p) p.classList.remove('open');
  });
  document.getElementById('sdh-lpanel').addEventListener('click', function(e) {
    e.stopPropagation();
  });
}

/* ── IP auto-detektálás ── */
function detectLangByIP() {
  return fetch('https://ipapi.co/json/')
    .then(function(r){ return r.json(); })
    .then(function(d){ return COUNTRY_LANG[d.country_code] || DEFAULT_LANG; })
    .catch(function() {
      return fetch('https://ip-api.com/json/?fields=countryCode')
        .then(function(r){ return r.json(); })
        .then(function(d){ return COUNTRY_LANG[d.countryCode] || DEFAULT_LANG; })
        .catch(function(){ return DEFAULT_LANG; });
    });
}

/* ── szöveges node-ok gyűjtése ── */
var SKIP_TAGS = {'SCRIPT':1,'STYLE':1,'CODE':1,'PRE':1,'NOSCRIPT':1,'TEXTAREA':1,'INPUT':1};

function collectNodes() {
  var nodes = [];
  var walker = document.createTreeWalker(
    document.body,
    NodeFilter.SHOW_TEXT,
    {
      acceptNode: function(node) {
        var p = node.parentElement;
        if (!p) return NodeFilter.FILTER_REJECT;
        if (SKIP_TAGS[p.tagName]) return NodeFilter.FILTER_REJECT;
        /* widget és no-translate elemek kihagyása */
        if (p.closest && p.closest('[data-no-translate]')) return NodeFilter.FILTER_REJECT;
        if (p.closest && p.closest('#sdh-lw')) return NodeFilter.FILTER_REJECT;
        if (!node.textContent.trim()) return NodeFilter.FILTER_REJECT;
        return NodeFilter.FILTER_ACCEPT;
      }
    }
  );
  var n;
  while ((n = walker.nextNode())) nodes.push(n);
  return nodes;
}

/* ── Google Translate (unofficial, ingyenes) — egyenként küld, nincs szeparátor-probléma ── */
function translateOne(text, from, to) {
  var url = 'https://translate.googleapis.com/translate_a/single?client=gtx&sl=' +
    from + '&tl=' + to + '&dt=t&q=' + encodeURIComponent(text);
  return fetch(url)
    .then(function(r){ return r.json(); })
    .then(function(d){
      return d[0].map(function(x){ return x[0]; }).join('');
    })
    .catch(function(){ return text; });
}

function batchTranslate(texts, from, to) {
  var PARALLEL = 8; /* egyszerre max 8 kérés */
  var results = new Array(texts.length);
  var idx = 0;

  function runNext() {
    if (idx >= texts.length) return Promise.resolve();
    var i = idx++;
    return translateOne(texts[i], from, to).then(function(t){
      results[i] = t || texts[i];
      return runNext();
    });
  }

  var workers = [];
  for (var w = 0; w < Math.min(PARALLEL, texts.length); w++) {
    workers.push(runNext());
  }
  return Promise.all(workers).then(function(){ return results; });
}

/* ── oldal fordítás ── */
function translatePage(targetLang) {
  var cacheKey = 'sdh-i18n-' + CACHE_VER + '-' + location.pathname + '-' + targetLang;

  /* node-ok gyűjtése és eredeti szövegek mentése (egyszer) */
  if (!_nodesSnapshot) {
    _nodesSnapshot = collectNodes();
    _originals = _nodesSnapshot.map(function(n){
      return { node: n, text: n.textContent };
    });
  }

  /* visszaállítás magyarra */
  if (targetLang === DEFAULT_LANG) {
    _originals.forEach(function(o){ o.node.textContent = o.text; });
    return Promise.resolve();
  }

  /* sessionStorage cache */
  try {
    var cached = sessionStorage.getItem(cacheKey);
    if (cached) {
      var map = JSON.parse(cached);
      _originals.forEach(function(o, i){
        if (map[i] !== undefined) o.node.textContent = map[i];
      });
      return Promise.resolve();
    }
  } catch(e){}

  /* fordítás */
  var loader = document.getElementById('sdh-lloader');
  if (loader) loader.style.display = 'block';

  var texts = _originals.map(function(o){ return o.text; });

  return batchTranslate(texts, DEFAULT_LANG, targetLang)
    .then(function(translated) {
      translated.forEach(function(txt, i) {
        if (_originals[i]) _originals[i].node.textContent = txt;
      });
      /* cache mentés */
      try {
        var save = {};
        translated.forEach(function(t, i){ save[i] = t; });
        sessionStorage.setItem(cacheKey, JSON.stringify(save));
      } catch(e){}
    })
    .finally(function() {
      if (loader) loader.style.display = 'none';
    });
}

/* ── widget frissítés ── */
function updateWidget() {
  var info = getLangInfo(_currentLang);
  var flagEl = document.getElementById('sdh-lflag');
  var codeEl = document.getElementById('sdh-lcode');
  if (flagEl) flagEl.textContent = info.flag;
  if (codeEl) codeEl.textContent = _currentLang.toUpperCase();
  document.querySelectorAll('.sdh-li').forEach(function(el) {
    el.classList.toggle('on', el.dataset.code === _currentLang);
  });
}

/* ── nyelvváltás ── */
function switchLang(code) {
  if (code === _currentLang) {
    var p = document.getElementById('sdh-lpanel');
    if (p) p.classList.remove('open');
    return;
  }
  _currentLang = code;
  localStorage.setItem('sdh-lang', code);
  updateWidget();
  var p = document.getElementById('sdh-lpanel');
  if (p) p.classList.remove('open');
  translatePage(code);
}

/* ── init ── */
function init() {
  injectStyles();

  var saved = localStorage.getItem('sdh-lang');
  if (saved) {
    _currentLang = saved;
    injectWidget();
    updateWidget();
    if (_currentLang !== DEFAULT_LANG) translatePage(_currentLang);
  } else {
    detectLangByIP().then(function(lang) {
      _currentLang = lang;
      localStorage.setItem('sdh-lang', lang);
      injectWidget();
      updateWidget();
      if (_currentLang !== DEFAULT_LANG) translatePage(_currentLang);
    });
  }
}

if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', init);
} else {
  init();
}

})();
