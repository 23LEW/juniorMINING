# HTML Viewer — GitHub Pages Setup

## Übersicht

Der HTML Viewer (`docs/index.html`) ist eine **statische Single-File-Anwendung**, die lokal und über GitHub Pages läuft. Die Daten werden aus der Datenbank in das HTML eingebettet — es ist kein Server oder Backend erforderlich.

**URL:** `https://23lew.github.io/juniorMINING/` (nach GitHub Pages Aktivierung)

---

## Lokale Nutzung

### Datei öffnen
Einfach im Browser öffnen:
```bash
open docs/index.html
```

Oder mit Python Server (für einige Browser-Features):
```bash
cd docs
python3 -m http.server 8000
```
Dann `http://localhost:8000` besuchen.

---

## GitHub Pages Aktivieren (einmalig)

### Schritt 1: Repository Settings öffnen
1. Gehe zu https://github.com/23lew/juniorMINING
2. Klick auf **Settings** (oben rechts)

### Schritt 2: Pages konfigurieren
1. Linkes Menü → **Pages**
2. **Source** → Wähle `main` branch
3. Wähle Folder: `/docs`
4. Klick **Save**

### Schritt 3: Warten
GitHub Pages wird in ~1 Minute aktiv. Die URL wird angezeigt:
```
https://23lew.github.io/juniorMINING/
```

---

## Update-Workflow

Jedes Mal wenn du die Datenbank aktualisierst:

### 1. Daten einpflegen
```bash
# Deine Datenbank-Updates (SQL, Inserts etc.)
sqlite3 data/junior_mining.db < sql/260517_neue_daten.sql
```

### 2. Viewer regenerieren
```bash
python3 scripts/build_viewer.py
```
Dies liest `data/junior_mining.db` und generiert `docs/index.html` neu.

### 3. Commit und Push
```bash
git add docs/index.html
git commit -m "260517 HTML-Viewer Update — 5 neue Companies"
git push
```

### 4. GitHub Pages aktualisiert
Nach ~30-60 Sekunden ist die neue Version online unter `https://23lew.github.io/juniorMINING/`.

---

## Viewer-Features

### 📊 Overview Tab
- **Sortierbar:** Klick auf Column-Header (Name, Score, Country, etc.)
- **Filterbar:** Status (Success/Failure/Ambivalent), Commodity, Land, Exit Year
- **Farb-Status:** Grün = Success | Rot = Failure | Gelb = Ambivalent
- **Klick auf Company:** → springt zu **Company-Detail** Tab

### 🏢 Company-Detail Tab
- **Outcome & Scores:** Discovery, Reserve Conversion, Exit Production, Peak Marketcap
- **Personen & Rollen:** Alle Personen in dieser Company mit Role Type und Daten
- **Projekte:** Alle Projekte der Company mit Jurisdiction und Commodity
- **Event Timeline:** Chronologische Liste aller Events (Permit, Expropriation etc.)

### 👥 Personen Tab
- **Sortierbar:** Name, Birth Year, Country, Companies-Count
- **Filterbar:** Nach Nachname suchen
- **Klick auf Person:** → zeigt **Karriere-Pfad**
  - Alle Companies in der diese Person tätig war
  - Role Type pro Position
  - Outcome (Success/Failure) pro Company

### 🔗 Cross-Links Tab
- **Serien-Personen:** Personen mit 2+ Companies (filterbar)
- **Erfolgs-Rate:** Success-Count / Total-Count pro Person
- **Sorted by Success:** Erfolgreichste Serien-Personen oben

---

## Technische Details

### Build-Prozess
1. `build_viewer.py` liest `data/junior_mining.db` via sqlite3
2. Alle Tabellen werden als JSON extrahiert
3. JSON wird in das HTML eingebettet (inline)
4. **Keine Server-DB-Verbindung im Browser** — alles läuft lokal im Browser
5. Alpine.js (@3.x) für Interaktivität (Filter, Sort, Toggle)

### Datenbank-Kompatibilität
Das Skript nutzt `PRAGMA table_info()` für dynamische Spalten-Erkennung.
- Schema kann sich ändern → Skript passt sich automatisch an
- Neue Spalten werden einfach mitgenommen
- Ältere Versionen sind kompatibel (NULL-Werte sind OK)

### Browser-Kompatibilität
- Chrome/Edge/Firefox/Safari (aktuell)
- Mobile (Responsive Design)
- Keine speziellen Plug-ins nötig

---

## Dateistruktur

```
juniorMINING/
├── data/
│   └── junior_mining.db          (Datenbank — Quelle)
├── scripts/
│   └── build_viewer.py           (Generator — aktualisieren bei DB-Änderung)
├── docs/
│   ├── index.html                (Fertige HTML — wird von GitHub Pages serviert)
│   └── VIEWER-SETUP.md           (Diese Datei)
└── README.md
```

---

## Troubleshooting

### HTML lädt nicht im Browser
→ Localhost-Server nutzen (siehe oben)

### "Keine Daten" im Viewer
→ Skript hat alte DB gelesen. Ausführen:
```bash
python3 scripts/build_viewer.py
```

### GitHub Pages zeigt alte Version
→ Cache löschen (Strg+Shift+Del) oder 1-2 Minuten warten

### Fehler beim Ausführen von `build_viewer.py`
→ Python 3.6+ erforderlich:
```bash
python3 --version
```

---

## Performance

- **Dateigröße:** ~170 KB (HTML mit embedded JSON)
- **Ladezeit:** <1 Sekunde
- **Filterung/Sortierung:** Instant (client-side)
- **GitHub Pages Latenz:** ~30-60 Sekunden nach Push
