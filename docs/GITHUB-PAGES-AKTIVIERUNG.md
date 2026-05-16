# GitHub Pages Aktivierung — Schritt für Schritt

## Ausgangslage

Das Repo `23lew/juniorMINING` hat eine statische HTML-Datei unter `docs/index.html`, die über GitHub Pages veröffentlicht werden soll.

**Gewünschte URL:** `https://23lew.github.io/juniorMINING/`

---

## Aktivierungs-Schritte

### 1️⃣ Repository öffnen
Navigiere zu: https://github.com/23lew/juniorMINING

### 2️⃣ Settings öffnen
Klick oben rechts auf **Settings** (Zahnrad-Icon)

![Settings Button](https://docs.github.com/assets/cb-28266/images/help/repository/repo-actions-settings.png)

### 3️⃣ Pages im linken Menü auswählen
- Scrolle im linken Menü herunter
- Klick auf **Pages** (unter "Code and automation")

### 4️⃣ Source konfigurieren
Under "Build and deployment":

1. **Branch:** Wähle `main`
2. **Folder:** Wähle `/docs`
3. Klick **Save**

![GitHub Pages Settings](https://docs.github.com/assets/cb-1b82b7c5/images/help/pages/source-settings-branch.png)

### 5️⃣ Warten auf Deployment
- GitHub zeigt eine grüne Box: "Your site is live at `https://23lew.github.io/juniorMINING/`"
- Typisch: **1-2 Minuten Wartezeit**
- Prüfen unter: https://github.com/23lew/juniorMINING/deployments/

---

## Troubleshooting

### URL zeigt 404
**Ursache:** Pages noch nicht aktiv oder falscher Branch/Folder gewählt

**Lösung:**
1. Nochmal Settings → Pages prüfen
2. Branch = `main`, Folder = `/docs`
3. 5 Minuten warten und Seite neu laden
4. Browser-Cache löschen (Ctrl+Shift+Del)

### Alte Version wird angezeigt
**Ursache:** Browser-Cache

**Lösung:**
```bash
# Force-Reload im Browser
Cmd+Shift+R (Mac)
Ctrl+Shift+R (Windows/Linux)
```

### Deployment schlägt fehl
Prüfe unter https://github.com/23lew/juniorMINING/deployments/
- Klick auf den roten Error
- Meist: falscher Branch oder Ordner

---

## Nach Aktivierung: Update-Workflow

Jedes Mal wenn die Datenbank aktualisiert wird:

```bash
# 1. Viewer neu generieren
python3 scripts/build_viewer.py

# 2. Änderung committen
git add docs/index.html
git commit -m "260517 HTML-Viewer Update — neue Daten"

# 3. Pushen
git push

# 4. GitHub Pages aktualisiert sich automatisch (~30-60 Sekunden später)
```

GitHub erkennt die neue Datei unter `docs/index.html` automatisch und deployed sie.

---

## Deployment-Status prüfen

Jederzeit den Status unter https://github.com/23lew/juniorMINING/deployments/ prüfen:
- **Green checkmark** = erfolgreich deployed
- **Red X** = Fehler (Details durch Klick)

---

## Mehr Infos

GitHub Pages Dokumentation: https://docs.github.com/en/pages/getting-started-with-github-pages
