# Workflow v0.2 — Änderungsnotizen

Sammlung von methodischen Punkten, die beim Phase-2-Daten-Eintrag aufkommen
und im nächsten Workflow-Update (v0.2) bedacht werden sollten.

Format: Markdown, damit unkompliziert anhängbar während der Daten-Erfassung.
Vor Erstellung von Workflow v0.2 als .docx wird diese Datei in eine Gliederung
übersetzt und die Punkte zusammengeführt.

---

## Offene Punkte aus dem ersten Matched Pair (Aurelian, 2026-05-14)

### 1. Personen-Scope: Schlüssel-Feldgeologen mit Discovery-Beitrag

**Anlass:** Julio Soto bei Aurelian/FDN.
**Issue:** Workflow v0.1 §3 + Konzeptpapier v0.4 begrenzt Personen-Scope auf
„C-Level + Chairman + VP Exploration/Chief Geologist + Cornerstone-Investoren".
Julio Soto war Feldgeologe (kein VP/Chief), aber seine Beobachtung war
discovery-kritisch.
**Vorschlag v0.2:** Vierte Personenkategorie aufnehmen — „Schlüssel-Feldgeologen
mit Discovery-Beitrag". Operationalisierung nötig: Wer qualifiziert? Kriterien:
namentliche Nennung in NI 43-101 als „discoverer", oder in PDAC Discovery Award,
oder als Erst-Autor des Technical Report bei Resource Estimate.

### 2. Projekt-Hierarchie: Konzession vs. Deposit

**Anlass:** Aurelians „Cordillera del Cóndor / Condor Project" (Konzession,
Greenfield ab ~2004) vs. „Fruta del Norte" (Deposit, entdeckt 2006 innerhalb
der Konzession).
**Issue:** Das Schema kennt nur eine Hierarchie-Ebene `project`. Eine Junior
hat aber typisch 1 Konzession mit 1–3 Deposits. Eine flache Repräsentation
verliert Information (Konzessions-Start, mehrere Deposits in einer Konzession).
**Vorschlag v0.2:** Zwei-Ebenen-Modell diskutieren — entweder neue Tabelle
`concession` als Eltern-Tabelle von `project`, oder `parent_project_id` als
Self-Reference in `project`. Vor Phase 3 entscheiden.

### 3. Mehrfach-Rollen pro Person/Company

**Anlass:** Bei Aurelian: Anderson (CEO + Founder), Barron (Founder + VP
Exploration + Cornerstone Investor).
**Issue:** Workflow v0.1 §3 sagt nichts zur Mehrfach-Rollen-Behandlung.
**Vorschlag v0.2:** §3 ergänzen um den Satz „Pro Person/Company-Kombination
werden alle quellenfest belegten Rollen aus dem Workflow-Scope eingetragen.
Mehrere Zeilen in der `role`-Tabelle sind erlaubt und erwünscht, wo
analytisch relevant (z.B. Operator-Founder vs. reiner Founder)."

### 4. Personen mit nur NULL-Disambiguierungsdaten

**Anlass:** Julio Soto — kein `birth_year`, kein `education`, nur Land und
Discovery-Jahr.
**Issue:** Bei späterer Cross-Company-Analyse („taucht diese Person auch
bei Company X auf?") kann eine Person ohne Disambiguierungs-Felder kaum
re-identifiziert werden. Bei lokalen Geologen aus Schwellenländern wird das
häufig der Fall sein.
**Vorschlag v0.2:** Operationelle Anmerkung in §4 — Personen mit nur
NULL-Disambiguierung können nur dann sicher als „seriell erfolgreich" oder
„seriell scheiternd" gelabelt werden, wenn der Name selbst extrem selten ist
oder die Quellen explizit auf Identität verweisen. Andernfalls: konservativ
zwei Einträge anlegen.

### 5. Premium-Lookback-Periode: 20-Tage vs. 30-Tage VWAP

**Anlass:** Workflow v0.1 §7.3 spezifiziert „30-Tage-VWAP". Die Kinross/Aurelian-
Primärquelle (PR vom 24.07.2008) berichtet Premium auf 20-Tage-VWAP — kanadische
Industrie-Konvention.
**Issue:** Bei direkter Anwendung der Workflow-Regel gibt es eine Differenz
zwischen der gemeldeten Premium-Kennzahl und der Workflow-spezifizierten.
Bei großen Premiums (Aurelian: 63 %) irrelevant; bei Grenzfällen kritisch.
**Vorschlag v0.2:** Eine Konvention festlegen — entweder strikt 30-Tage
(eigene Neuberechnung aus historischen Kursdaten, falls Quelle 20-Tage liefert),
oder „die Lookback-Periode der Primärquelle akzeptieren" (mit Vermerk in
sources.csv). Klare Entscheidung dokumentieren.

### 6. Reserve-Conversion-Gewicht bei Sell-to-Major-Strategie

**Anlass:** Aurelian: Discovery 1.0, Reserve-Conversion 0.0, Exit 1.0,
MarketCap 1.0 → Total 0.75 statt 1.0. Die 0.0 deckelt einen sonst „perfekten"
Junior-Erfolg.
**Issue:** Wenn die zentrale Hypothese „Bet on the jockey" sich auf
*Junior-Erfolg* bezieht (= Discovery + Sale at Premium), dann bestraft die
25%-Gewichtung der Reserve-Conversion die idealtypischen Sell-to-Major-Stories.
Methodisch ist das v0.1-Verhalten korrekt (die Company hat die Reservenarbeit
nicht selbst gemacht), aber die Gewichtung ist diskutabel.
**Vorschlag v0.2:** Kein Reflex-Update der Gewichtung — die Workflow-Regel
„empirische Kalibrierung in Phase 3" greift hier. Aber: Diskutieren, ob
eine *alternative Score-Definition* parallel berechnet werden sollte,
die Reserve-Conversion entweder weglässt oder als „bedingten Faktor" behandelt
(„nur scoren, wenn die Company bis zur Produktion gegangen wäre").

### 7a. Exchange-Upgrade als event_type fehlt

**Anlass:** Aurelian graduierte zwischen 2003 (TSX-V-Listing) und 2008 (Delisting)
von TSX-V zu TSX. Dieser Schritt ist ein signifikantes Ereignis für eine Junior
(Liquiditäts-Schwelle, Eligibility für US-Investoren), kann aber im Schema v1.1
nicht als eigener Event-Typ erfasst werden.
**Issue:** `event_type` CHECK-Constraint hat nur: `PEA`, `PFS`, `FS`, `Discovery`,
`M&A`, `Delisting`, `Insolvency`, `PDAC Award`, `IPO`, `Production Start`,
`Resource Estimate`.
**Vorschlag v0.2:** Schema-Migration v1.1 → v1.2, neuer event_type
`Exchange Upgrade`. Bei Aurelian dann nachträglich eintragen.
**Status v0.1:** Bewusst nicht eingetragen.

### 7b. „Mining Persons of the Year" / Industry-Awards als event_type

**Anlass:** The Northern Miner verlieh „Mining Persons of the Year 2008" an
Anderson, Barron, Leary. Das ist *kein* PDAC-Award, sondern eine separate
Branchen-Auszeichnung.
**Issue:** Schema v1.1 hat nur `PDAC Award` als Award-Event-Type. Andere
Industry-Awards (TNM MOTY, Mines & Money, S&P Platts) passen nicht sauber rein.
**Vorschlag v0.2:** Schema-Migration v1.1 → v1.2: `PDAC Award` zu
`Industry Award` umbenennen (oder zusätzlich aufnehmen) und in der
`description` den konkreten Award benennen.
**Status v0.1:** TNM MOTY wird als `PDAC Award` eingetragen, mit Disclaimer
in der description.

### 7. Peak-MarketCap als Bucket vs. exakter Wert

**Anlass:** Aurelian Peak-MarketCap nur qualitativ einsortiert (>1 Mrd CAD).
**Issue:** Workflow §7.4 verlangt nur Bucket-Zuordnung (0.0 / 0.3 / 0.6 / 1.0).
Für Phase-3-Regression wäre der exakte numerische Wert wertvoll, um die
Bucket-Grenzen empirisch zu kalibrieren.
**Vorschlag v0.2:** Optionale zusätzliche Spalte `peak_marketcap_cad_million`
in der `outcome`-Tabelle einführen. Schema-Migration v1.1 → v1.2.

---

## Konventionen für diese Datei

- Pro Pair, das den Workflow stresst, einen Abschnitt anlegen
- Punkte numerieren über den gesamten Workflow hinweg (nicht pro Pair neu beginnen)
- Bei jedem Punkt: Anlass, Issue, Vorschlag v0.2
- Wenn ein Punkt in v0.2 umgesetzt ist: hier mit „RESOLVED in v0.2 § X" markieren,
  nicht löschen (Audit-Trail)
