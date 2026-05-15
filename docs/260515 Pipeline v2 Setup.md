# Pipeline v2 — Setup für Batch 2+

**Datum:** 2026-05-15
**Status:** Vorbereitung, nicht im Workflow v0.2 reflektiert. Bei Bewährung in nächsten 1–2 Batches: Konsolidierung in Workflow v0.3.

---

## Zweck

Pipeline v1 (heute durchgeführt: Batch 1, Aurelian + 5 Failures) verbrauchte ~75 % von Lews 5-Stunden-Limit auf Claude Max 5x. Davon entfielen geschätzt **60 %** auf Opus-getriebene parallele Web-Recherche durch 5 General-Purpose-Agenten — eine teure Anwendung des stärksten Modells für Crawling-Arbeit, die Haiku 4.5 zu einem Sechstel des Token-Preises auch erledigt.

Pipeline v2 trennt klarer:

- **Haiku 4.5** für strukturierte Web-Recherche (parallele Crawler)
- **Opus 4.7** (= „ich" in Live-Sessions) für Review, Personen-Verifikation, SQL-Erstellung, Audit
- **Bundled SQL** (1 File pro Batch statt 5) für effizientere DB-Browser-Bedienung
- **Light Audit** wenn keine Zweifelsfälle, Full Audit nur bei methodischen Funden

Erwartete Token-Ersparnis ggü. Batch 1: **~70 %**. Erwartete Live-Klick-Zeit-Ersparnis: **~15 Min pro Batch**.

---

## Workflow-Diagramm

```
Lew: "starte Batch N: <5 Company-Namen>"
       │
       ▼
[1] Opus erstellt 5 Haiku-Agent-Aufträge (parallel)
       │
       ▼
[2] 5 Haiku-Agenten recherchieren (WebSearch + WebFetch)
    → strukturierte Markdown-Outputs (siehe Template unten)
       │
       ▼
[3] Opus-Review-Pass
    - Personen-Namen via Spot-Check WebSearch verifizieren
    - Score-Konsistenz gegen Workflow v0.2 §7 prüfen
    - Schema-Lücken flaggen
    - Zweifelsfall-Trigger anwenden (§11.3)
       │
       ▼
[4] Opus generiert EIN gebündeltes SQL-File
    `YYMMDD Batch N Insert All.sql`
    Reihenfolge im File: company → person → role → project → outcome → event,
    pro Company als Section getrennt
       │
       ▼
[5] Opus erweitert sources.csv um neue Quellen
       │
       ▼
[6] Opus schreibt Audit-Markdown
    - Light: 1 Tabelle (Companies + Scores), 1 Abschnitt „No Flags"
    - Full: nur wenn methodische Funde (§11.3 Trigger)
       │
       ▼
[7] Lew bekommt 3 Files:
    - SQL-Batch-File
    - sources.csv (Update)
    - Audit
       │
       ▼
[8] Lew führt aus (Step-by-Step von Opus):
    - DB Browser: SQL-Batch-File → Play → Write Changes
    - Terminal: git add + commit + push
       │
       ▼
[9] Opus aktualisiert Memory-File
```

---

## Haiku-Agent Prompt-Template

Copy-paste-ready für Opus. Pro Batch wird der Template-Prompt 5× mit unterschiedlichen Company-Namen instanziiert und parallel an 5 Haiku-Agenten gegeben.

**Wichtig:** `subagent_type: "general-purpose"`, `model: "haiku"`.

```
Du bist Recherche-Agent für die Junior-Mining-Erfolgs-Datenbank.
Hypothesen-Test: "Bet on the jockey, not the horse" — sagt Personen-
Track-Record Junior-Mining-Erfolg voraus?

**Target: <COMPANY_NAME>** (<COMMODITY>, <JURISDICTION>)
**Sample-Label:** <success | failure | ambivalent>
**Methodische Funktion in Batch:** <z.B. "Reverse-Causation-Test für X"
oder "Vergleichscase zu Y" oder "Sample-Validierung mittlere Konfidenz">

WICHTIGE REGELN:
- JEDE Personen-Identifikation muss durch ≥2 unabhängige Web-Sources
  verifiziert sein. NIEMALS Namen aus Trainings-Daten generieren —
  immer aktiv via WebSearch suchen.
- Bei Zweifel: "[NICHT VERIFIZIERT]" markieren statt zu raten.
- Director-only-Personen (Non-Executive Directors ohne Cornerstone-
  Beteiligung) AUSLASSEN per Workflow v0.2 §3.1.

ERLAUBTE ROLLE-TYPEN (sonst auslassen):
CEO, Chairman, CFO, COO, President, VP Exploration, Chief Geologist,
Project Geologist, Cornerstone Investor, Founder

ERLAUBTE EVENT-TYPEN (sonst flaggen):
IPO, Exchange Upgrade, Discovery, Resource Estimate, PEA, PFS, FS,
Production Start, M&A, Industry Award, Insolvency, Delisting,
Permit Granted, Permit Denied, Expropriation, Arbitration Award

OUTPUT — exakt diese Markdown-Struktur:

## Company Stammdaten
- name:
- isin (wenn auffindbar):
- country:
- stock_exchange:
- listing_year:
- delisting_year:
- primary_commodity:
- commodity_2:
- commodity_3:
- fraud_flag (0/1):
- exit_type: M&A | Production | Insolvency | Delisting | Active
- exit_year:

## Persons (nur mit Exekutiv- oder Founder- oder Cornerstone-Rolle)
Für jede Person:
- vorname, nachname
- birth_year (falls auffindbar; sonst NULL)
- education
- country
- bio_text (50–500 Zeichen aus Appointment-PR oder AIF)
- production_ramp_up_experience: 0 oder 1
- first_mention_year, first_mention_source (source_id, siehe unten)
- ROLLEN AN DIESER COMPANY:
  - role_type | start_date (ISO) | end_date (ISO oder NULL)

## Projects (Konzession + Deposit wo zutreffend via parent_project)
Für jedes:
- name, jurisdiction
- primary_commodity, commodity_2, commodity_3
- deposit_type
- stage_at_acquisition: Greenfield | Brownfield | Discovery | PEA | PFS | FS | Construction | Production
- peak_stage: gleiche Optionen
- parent_project_name (wenn Sub-Deposit einer Konzession; sonst NULL)

## Outcome
- discovery_score (0.0 / 0.5 / 1.0 nach §7.1)
- reserve_conversion_score (0.0 / 0.3 / 0.6 / 1.0 nach §7.2)
- exit_production_score (0.0 / 0.4 / 0.7 / 1.0 nach §7.3)
  - 1.0 = M&A Premium ≥ 30 % über 20-Tage-VWAP, oder Production erreicht
  - 0.7 = M&A Premium 10–30 %, oder strategisches JV mit Major
  - 0.4 = Merger of Equals, Spin-Off mit Werterhalt, Restrukturierung mit Fortbestand
  - 0.0 = Insolvenz, Delisting wegen Wertverlust, Aufgabe des Hauptprojekts
- peak_marketcap_score (0.0 / 0.3 / 0.6 / 1.0 nach §7.4)
  - 1.0 = ≥ 1 Mrd CAD
  - 0.6 = 250 Mio – 1 Mrd CAD
  - 0.3 = 50 – 250 Mio CAD
  - 0.0 = < 50 Mio CAD
- peak_marketcap_cad_million (numerisch, falls bekannt)
- total_score = 0.25*discovery + 0.25*reserve_conversion + 0.30*exit + 0.20*peak_marketcap

## Events (chronologisch)
Pro Event:
- event_type (aus erlaubter Liste)
- event_date (ISO 8601, degraded YYYY-MM oder YYYY wenn nötig)
- description (max 500 Zeichen)

## Sources
Pro Quelle:
- source_id: <KÜRZEL>-<TICKER>-<JAHR>-<TYP> (z.B. SEC-XXX-2014-10K, PR-XXX-2015-MOA)
- citation (volle bibliografische Angabe)
- url
- accessed_date: 2026-05-15
- source_type: filing | press | book | academic | web | other

## Uncertainties / Flags
- Liste alle Personen-Konflikte zwischen Quellen
- Liste alle Schema-Lücken (event_type/role_type außerhalb Vokabular)
- Liste alle nicht-eindeutigen Score-Komponenten
- Liste alle Stamm-Daten-Konflikte (z.B. listing_year ambig)

Sei knapp aber vollständig. Output wird in SQL umgesetzt.
```

---

## Opus-Review-Checkliste (Schritt [3] im Diagramm)

Nach Erhalt der 5 Haiku-Outputs prüft Opus:

### Pflicht-Checks pro Company

1. **Personen-Verifikation:** Stichprobe 1–2 Personen pro Company via WebSearch
   gegenprüfen (Name + Company + Rolle). Bei Halluzinations-Verdacht: alle Personen.
2. **Score-Konsistenz:** total_score = 0.25×disc + 0.25×rc + 0.30×ep + 0.20×pmc
   nachrechnen. Bei Abweichung > 0.01: Korrektur durch Opus.
3. **Schema-Vokabel:** alle role_type und event_type-Werte gegen v1.3-CHECK-Liste prüfen.
4. **Quellen-Mindestmenge:** ≥ 2 unabhängige Primärquellen pro Schluesselfakt
   (Personen-ID, Discovery, M&A-Premium, Reserve-Estimate).
5. **success_label gegen Konzeptpapier v0.4** §7.2/§8.1: stimmt Sample-Zuordnung?

### Zweifelsfall-Trigger (§11.3 Workflow v0.2)

Bei einem dieser Befunde: in Audit-File flaggen und Lew zur Entscheidung vorlegen
**bevor** SQL-Generierung:

- Personen-Identifikations-Konflikt (Halluzination, Namensverwechslung, ambivalente Quellen)
- success/failure-Label nicht eindeutig
- Schema-Lücke (event_type/role_type fehlt)
- Score-Komponente aus Quellen nicht ableitbar

---

## SQL-Bundling-Konvention

**Statt 5 Einzeldateien:** EIN gebündeltes File pro Batch.

### Datei-Konvention

```
sql/YYMMDD Batch N Insert All.sql
```

z.B. `sql/260516 Batch 2 Insert All.sql`

### Struktur des gebündelten Files

```sql
-- ============================================================================
-- Pipeline-Batch N
--   Sample-Label: <success|failure|gemischt>
--   Companies: <c1>, <c2>, <c3>, <c4>, <c5>
-- ============================================================================
-- Schema-Voraussetzung: vX.Y
-- Audit: docs/YYMMDD Batch N Audit.md
-- ============================================================================

PRAGMA foreign_keys = ON;

-- ============================================================================
-- COMPANY 1: <Company-Name>
-- ============================================================================

-- 1.1 company
INSERT INTO company (...) VALUES (...);

-- 1.2 person
INSERT INTO person (...) VALUES ...;

-- 1.3 role
INSERT INTO role (...) VALUES ...;

-- 1.4 project
INSERT INTO project (...) VALUES ...;

-- 1.5 outcome
INSERT INTO outcome (...) VALUES (...);

-- 1.6 event
INSERT INTO event (...) VALUES ...;

-- ============================================================================
-- COMPANY 2: <Company-Name>
-- ============================================================================
[...]
```

### Vorteile

- DB Browser: einmal laden, einmal Play, einmal Write Changes (statt 5×)
- Atomare Operation: entweder ganzes Batch oder nichts (SQLite-Transaktion via DB Browser)
- Weniger Klick-Arbeit, weniger Fehlerquellen
- Konsistenter PRAGMA-Header

### Caveat

Falls Schema-Migration nötig: bleibt separates File und läuft VOR dem Batch-Insert.
Beispiel-Reihenfolge bei Schema-Update:
1. `Migration vA.B zu vA.C.sql` → Play → Write Changes
2. `Batch N Insert All.sql` → Play → Write Changes

---

## Audit-Convention: Light vs. Full

### Light Audit (Default — wenn keine Zweifelsfälle)

`docs/YYMMDD Batch N Audit.md` mit:

1. **Übersicht-Tabelle** (Company | Score | Exit | Sources-Count)
2. **„Keine Zweifelsfälle"-Statement**
3. **Quellen-Übersicht** (Anzahl pro Company, Stufen-Verteilung)

Länge: ~30–50 Zeilen Markdown.

### Full Audit (wenn ≥ 1 Zweifelsfall-Trigger)

Wie Batch-1-Audit-Struktur:

1. Übersicht
2. Pro Company: Stammdaten, Persons, Projects, Outcome, Events, Flags
3. Cross-Cutting Zweifelsfälle mit Optionen
4. Empfehlungen für Lew

Länge: 100–300 Zeilen.

### Trigger für Full Audit

- ≥ 1 Personen-Identifikations-Konflikt
- ≥ 1 Schema-Lücke
- ≥ 1 Konzeptpapier-Korrektur-Befund (z.B. wie Titaro/Allied-Gold-Sache in Batch 1)
- ≥ 1 Score-Komponente nicht eindeutig

---

## Scheduling-Optionen

Scheduled Tasks (über das Tool `mcp__scheduled-tasks__create_scheduled_task`) helfen
nicht beim Token-Budget direkt — Tokens fallen bei Ausführung an. Aber sie helfen:

- **Zeitliche Entkopplung:** Recherche läuft über Nacht, du reviewst morgens
- **Reset-Timing:** wenn dein 5-Stunden-Fenster bekannt um z.B. 22:00 zurücksetzt,
  Schedule um 22:05 starten (volle 5h frischer Budget)

### Pattern für Schedule-Run

Prompt-Vorlage für Scheduled Task:

```
Führe Pipeline-Batch <N> für folgende Companies aus:
1. <Company 1>
2. <Company 2>
3. <Company 3>
4. <Company 4>
5. <Company 5>

Folge dem Workflow in /Users/lew/Dokumente/Business/JuniorMiner/JuniorMining/
docs/260515 Pipeline v2 Setup.md.

Setup:
- 5 parallele Haiku-Agenten zur Recherche
- Opus-Review-Pass
- Gebündeltes SQL-File
- Audit (Light/Full nach Trigger-Lage)
- KEINE eigene Ausführung in DB Browser oder git push — nur Files anlegen.
Lew reviewt am nächsten Morgen.
```

### Caveat Scheduling

Während ein Scheduled Task läuft, kann Lew nicht parallel mit Claude arbeiten
(gleiche Account-Limits). Empfehlung: schedulen wenn ohnehin nicht aktiv.

---

## Token-Budget-Tracking

Pro Batch ein kurzer Eintrag in der Audit-File:

```
Token-Verbrauch Batch N:
- Haiku-Recherche: ~X tokens
- Opus-Review + SQL + Audit: ~Y tokens
- Total: ~Z tokens
```

Damit kalibrieren wir nach 2–3 Batches die echten Kosten.

---

## Nächster Batch — Vorschlag-Liste

Pipeline v2 wird in Batch 2 zum ersten Mal angewendet. Vorschlag für Batch 2:

**Variante A — 5 Success-Companies** (testet Score-Verteilung breiter):
- Fronteer Gold (Mark O'Dea, später True Gold)
- Reservoir Minerals (Cu, Serbien)
- Probe Mines (Au, Ontario)
- Detour Gold (Au, Ontario, größter Mining-Discovery 2010er)
- Pretium Resources (Au, BC Brucejack)

**Variante B — 5 Failure-Companies mit mittlerer Konfidenz** (Sample-Verifikation):
- Aurcana, Gold Mountain, Apollo Gold (pre-Brigus), Avion Gold, Sulliden Gold

**Variante C — Gemischt mit weiteren Matched Pairs:**
- 3 Success + 2 Failure mit thematischer Klammer

Lew wählt; Opus instanziiert dann die 5 Haiku-Prompts und legt los.

---

## Konsolidierung in Workflow v0.3

Falls Pipeline v2 in Batch 2 + 3 bewährt: dieses Dokument wird zu Workflow v0.3 §11–§13
konsolidiert (Haiku/Opus-Splitting + Bundling + Audit-Modi als feste Methoden).
Bis dahin bleibt es ein „Setup-Doc" außerhalb des Hauptworkflows.

---

*Setup erstellt 2026-05-15 nach Batch 1 Pipeline v1.*
