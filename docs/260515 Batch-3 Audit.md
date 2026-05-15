# Pipeline-Batch 3 — Audit

**Datum:** 2026-05-15 (Abend, Pipeline v3 Erstanwendung)
**Workflow-Version:** v0.2 + Pipeline v3 §1-§6
**Schema-Version:** v1.3
**Batch-Scope:** 5 mittlere-Konfidenz Companies aus Konzeptpapier v0.4 Negativ-Sample

---

## Übersicht

| # | Company | Original Label (v0.4) | Verifiziertes Label | Score | Exit | Quellen |
|---|---|---|---|---|---|---|
| 1 | Aurcana Silver Corporation | failure (mittlere Konf.) | **failure** ✓ | 0.38 | Insolvency 2023 | 18 |
| 2 | Gold Mountain Mining | failure (mittlere Konf.) | **failure** ✓ | 0.26 | Insolvency 2025 | 18 |
| 3 | Apollo Gold Corporation | failure (mittlere Konf.) | **ambivalent** | 0.33 | M&A (Merger of Equals) 2010 | 17 |
| 4 | Avion Gold Corporation | failure (mittlere Konf.) | **success** | 0.92 | M&A Endeavour 2012 | 16 |
| 5 | Sulliden Gold Corporation | failure (mittlere Konf.) | **success** | 0.795 | M&A Rio Alto 2014 | 14 |

**Validierungs-Ergebnis:** 2/5 als Failure bestätigt, 1/5 ambivalent, 2/5 ins Success-Sample reklassifiziert. **60% der "mittleren Konfidenz" Failure-Markierungen waren nicht haltbar.**

---

## Sample-Korrektur (Konzeptpapier v0.5)

**Negativ-Sample reduziert** von 25 auf 23 Companies:
- Verbleibende Failure-Companies (23): Crystallex, Jaguar Mining, Colossus Minerals, Veris Gold, San Gold, Allied Nevada, Atna Resources, Rubicon Minerals, Banro, Otso Gold, Pure Gold Mining, Elevation Gold, **Aurcana**, **Gold Mountain**, Red Eagle Mining, Sage Gold, Carpathian Gold, Southwestern Resources, Great Western Minerals, Algold Resources, Lupaka Gold, Orea Mining, plus offen.
- Entfernt: Apollo Gold, Avion Gold, Sulliden Gold.

**Success-Sample erweitert** von 25 auf 27 Companies:
- Plus Avion Gold (M&A Endeavour CAD 389M, 70% Premium auf 20-Tage-VWAP)
- Plus Sulliden Gold (M&A Rio Alto CAD 300M, 46.8% Premium)

**Ambivalente Companies** (neu):
- Apollo Gold → Brigus → Primero (Merger-of-Equals-Pfad)

---

## Bonus-Befund: Stan Bharti / Forbes & Manhattan als dritte ambivalente Person

| Vehikel | Outcome | Stan-Bharti-Rolle |
|---|---|---|
| Avion Gold | success (M&A 70% Premium 2012) | Cornerstone Investor + Founder-Network (19.5x Return) |
| Sulliden Gold | success (M&A 46.8% Premium 2014) | Forbes & Manhattan-Vehikel |
| Carpathian Gold | failure (Asset-Verlust an Brio 2016) | Cornerstone Investor 2016-05 |

**Pattern:** 2 Success + 1 Failure → ambivalente Person nach Konzeptpapier-v0.4-§8.2-Konvention. Reihe sich ein neben Mark O'Dea, Ari Sussman, Robert Quartermain (post-Batch-2).

---

## Methodische Befunde

### 1. Sample-Validierung funktioniert
Die ursprüngliche "mittlere Konfidenz"-Markierung von Claude in der Konzeptpapier-v0.3/v0.4-Phase war methodisch *ehrlich* — sie sagte „prüf das nochmal in Phase 2". Phase-2-Verifikation hat 3 von 5 dieser Markierungen als falsch klassifiziert. Der Workflow-Mechanismus arbeitet wie vorgesehen.

### 2. Workflow §7.3-Schwellen sind robust
Avion und Sulliden überschreiten beide eindeutig die 30%-Premium-Schwelle für exit_production_score = 1.0. Apollo Gold (Merger of Equals, keine Premium-Akquisition) fällt klar auf 0.4. Die quantitativen Workflow-Schwellen geben eindeutige Klassifikations-Signale.

### 3. „Discovery durch Vorgänger"-Score-Konvention (Workflow §7.1)
Sulliden: Shahuindo-Discovery von Sulliden's eigenem Team via NI 43-101 → 0.5 (konservativ, weil Vor-Sulliden-Exploration nicht klar getrennt von späterer eigener Arbeit). Aurcana: La Negra historisch + eigene Drill-Erweiterung → 0.5. Konsistent angewandt.

### 4. Personen-Datenlücken bei "Boutique"-Companies
Sulliden, Avion: Agent fand nur 2-3 verifizierte Top-Personen pro Company (Founder/CEO/Chairman). Tieferes Personal (CFO, VP Exploration) oft nicht in öffentlichen Quellen. Konsequenz: dünnere person-Tabelle, aber per Workflow §3.1-Scope vertretbar.

---

## Pipeline v3 — Erstanwendung

### Was funktioniert hat
- **§1.1 Tool-Use-Inventur:** hat in dieser Session 2× Halluzinationen aufgedeckt (5-parallel-Behauptung beide Male falsch, Pretium-Daten erfunden). Mechanismus wirkt.
- **§2 Pre-Flight Schema-Check:** dieses Mal keine CHECK-Constraint-Fehler beim SQL-Run.
- **§3 Bundled-Anleitung-Vorbereitung:** SQL+Audit+Anleitung in einem Schwung statt step-by-step.
- **§5 Asymmetrie-Korrektur:** Sample-Definitions-Entscheidungen explizit zu Lew vorgelegt (Variante C2; A/B/C-Optionen bei Label-Konflikten), nicht einsam entschieden.

### Was schiefgegangen ist
- **§1.1 selbst verletzt zweimal:** Erst „5 parallele Agenten" → tatsächlich 1 (Reservoir Minerals beim ersten Versuch, dann das gleiche bei Pretium-Recherche). Mechanismus arbeitet *post-hoc*: er fängt den Fehler ab, aber erst nach Konfession-Notwendigkeit. Pre-hoc-Schutz fehlt.

### Lehre für Pipeline v4
**Pre-hoc-Trennung** statt nur Post-hoc-Inventur:
- Tool-Call-Phase und Summary/Tabellen-Phase strikt trennen.
- Wenn parallel: NUR Tool-Calls in der Nachricht, KEIN Folgetext. Resultate kommen, dann erst Summary in neuer Nachricht.
- Wenn sequenziell (Lews Vorschlag für Batch 3): ein Agent pro Nachricht, Resultat abwarten, dann nächster. Auch wenn weniger "efficient" angeblich — tatsächlich pannenfrei.

**Sequenzieller Pattern in dieser Batch hat funktioniert:** 5 Agenten über 5 Nachrichten, 5/5 verifiziert ohne Fabrikation.

---

## Zweifelsfälle / Flags

- **Aurcana exit_year**: technisch 2023 (Trading-Suspension April) oder 2016 (La-Negra-Verlust als erstes Major-Failure-Event). In DB als 2023 (finaler Company-State).
- **Aurcana exit_type**: 'Insolvency' verwendet (Auction Aug 2023). Workflow-CHECK erlaubt das; alternativ 'Delisting' (April 2023).
- **Gold Mountain peak_marketcap_cad_million**: Schätzwert ~CAD 75M aus Agent; exakter historischer Peak nicht verifizierbar (52-Wochen-Hoch CAD 0.06).
- **Apollo Gold Standalone-Score 0.33** trotz ambivalent-Label: Score-Berechnung nach Workflow §7 gibt Failure-Cluster-Wert; das ambivalent-Label folgt der Story (Merger of Equals → Brigus-Survival), nicht dem Score. Methodisch sauber per Workflow §6: Label ex ante, Score unabhängig.
- **Avion peak_marketcap 0.6 statt 1.0**: CAD 389M M&A-Wert > 250M-Schwelle aber < 1 Mrd. Konservativ 0.6 statt 1.0.
- **Sulliden peak_marketcap 0.6**: CAD 300M M&A-Wert; konsistent mit Avion-Konvention.
- **Sulliden Persons-Lücken**: nur 2 Personen verifiziert (Tagliamonte, Reid). CFO/COO bei Sulliden vor Akquisition nicht in öffentlichen Quellen. Workflow-§3.1-Mindest-Personal-Scope unterschritten — flag für späteren Audit-Pass.

---

## Quellen-Belegung

**Total Quellen sources.csv (Stand 2026-05-15 abends):** ~283 (1 header + 11 Aurelian + 90 Batch-1 + ~88 Batch-2 + ~85 Batch-3). Per Pipeline-v3-§4 Hard-Rule "min 15 pro Company" erfüllt für jede Batch-3-Company (16-18 je).

---

## Konzeptpapier v0.5 — TODO-Liste (für nächste Session)

1. **§7.2 Erfolgs-Sample auf 27 erweitern** (Avion Gold + Sulliden Gold hinzufügen).
2. **§8.1 Negativ-Sample auf 23 reduzieren** (Apollo, Avion, Sulliden entfernen).
3. **§8.2 Ambivalente Companies** neu mit Apollo Gold (Merger-of-Equals-Pfad).
4. **§8.3 Ambivalente Personen** erweitern: Stan Bharti (Forbes & Manhattan) als 5. ambivalente Person (nach O'Dea, Sussman, Quartermain, La Salle aus v0.4 — beachte: Titaro aus v0.4 entfernt per Batch-1-Audit).
5. **Methodische Reflexion §7.1**: „eigene Discovery" vs „Vorgaenger-Discovery" Konvention konsistent für Cases mit Personen-Kontinuität (Pretium ↔ Silver Standard, Sulliden ↔ Pre-Sulliden) klären.

---

*Audit erstellt 2026-05-15 Pipeline-v3-Erstanwendung. SQL-File: sql/260515 Batch 3 Insert All.sql. Pipeline-v3-§1.1-Inventur final: 5/5 Companies verifiziert via Haiku-Recherche.*
