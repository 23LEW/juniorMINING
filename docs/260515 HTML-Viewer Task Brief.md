# HTML-Viewer für Junior-Mining-DB — Task Brief

**Ziel:** Statische HTML-Ansicht der DB, lokal nutzbar und über GitHub Pages online verfügbar.

**Datenquelle:** `data/junior_mining.db`

## Anforderungen

1. **Single-File HTML** — alle CSS+JS inline (oder via CDN), keine Build-Pipeline. Liegt unter `docs/index.html` oder `viewer/index.html`.
2. **Daten-Einbettung:** Beim Generieren Python-Skript, das DB-Inhalt als JSON in das HTML einbettet. Kein Server-Backend, keine Live-DB-Verbindung im Browser.
3. **Online-fähig via GitHub Pages** — main-Branch, Ordner `docs/` als Pages-Source. URL: `https://23lew.github.io/juniorMINING/`.
4. **Update-Workflow:** ein Befehl `python3 scripts/build_viewer.py` regeneriert das HTML aus aktueller DB. Commit + Push → GitHub Pages aktualisiert automatisch in ~1 Minute.

## Inhaltliche Sichten

- **Übersichtsseite:** Companies-Tabelle mit name, success_label, total_score, exit_type, exit_year. Sortierbar, farbcodiert (success grün, ambivalent gelb, failure rot).
- **Company-Detail:** Klick auf Company → Personen, Rollen, Projekte, Outcome-Komponenten, Event-Timeline (vertikal).
- **Personen-Übersicht:** alle Personen, sortiert nach Anzahl Companies. Klick → Karriere-Pfad (welche Company, welche Rolle, welches Outcome).
- **Cross-Link-Sicht:** Serielle Personen (Mark O'Dea, Ari Sussman, Stan Bharti etc.) mit Erfolg/Failure-Pattern.
- **Filter:** Sample-Seite (success/failure/ambivalent), Commodity, Jurisdiktion, Zeitraum.

## Tech-Stack

- Python 3 + sqlite3 für JSON-Export
- HTML5 + Vanilla JS (oder Alpine.js via CDN für Reaktivität)
- CSS Grid/Flexbox, keine UI-Framework
- Optional: Chart.js via CDN für Score-Verteilungs-Charts

## Deliverables

1. `scripts/build_viewer.py` — generiert HTML aus DB
2. `docs/index.html` (oder `viewer/index.html`) — fertige Ansicht
3. README-Eintrag wie zu regenerieren

## Aktiviere GitHub Pages (Lew manuell)

GitHub Repo Settings → Pages → Source: `main` branch, `/docs` folder → Save. Dann URL erreichbar.

## Caveats

- Schema-Version v1.3, kann sich ändern → build_viewer.py soll alle Spalten dynamisch aus PRAGMA lesen
- DB-Pfad: relative zum Repo-Root `data/junior_mining.db`
- Personennamen UTF-8 (Diakritika), Apostrophe (O'Dea) — HTML-escape im Output
