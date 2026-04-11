# Copilot fejlesztési szabályok

## Kötelező napló írás
- Minden session végén frissítsd a NAPLO.md fájlt
- Session elején olvasd el a NAPLO.md utolsó bejegyzését
- Kérdezz rá a mai célra ha nem egyértelmű

## Kódolási szabályok
- Minden szöveg color:#fff — SOHA rgba(255,255,255,0.x) szövegszínnél
- Accent szín: #ff0000
- Háttér: rgb(6,6,6) + dot grid
- Corner cut: ::after { background:linear-gradient(225deg,#ff0000 50%,transparent 50%) }
- Scrollanimáció: IntersectionObserver + opacity 0→1 + translateY/X
- min-height:100vh minden wrapper-en

## Workflow
- Git: main branch az éles, develop a fejlesztési ág
- Push előtt: git add . && git diff --cached --quiet
- Ha valami elromlott: Visszagörgetés task (utolsó 20 commit listából)
