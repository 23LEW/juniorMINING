# Pipeline v3 — Setup für Batch 3+

**Datum:** 2026-05-15 (Abend, nach Pipeline-v2-Erstanwendung)
**Status:** Erweiterung von Pipeline v2; v2 bleibt als Basis (Haiku-Recherche, Bundled SQL, Light/Full Audit).
**Anlass:** Pipeline v2 hat in der Erstanwendung (Batch 2) drei Klassen von Fehlern produziert. v3 adressiert sie regelbasiert.

---

## Was v3 hinzufügt (Übersicht)

| § | Thema | Anlass aus Batch 2 |
|---|---|---|
| 1 | Halluzinations-Schutz | Drei Mal Daten behauptet, die nie recherchiert wurden |
| 2 | Pre-Flight-Schema-Check | SQL-Re-Run wegen peak_stage CHECK-Constraint-Fehler |
| 3 | Bundled DB-Browser-Anleitung | Step-by-step kostet 6-10 Turns pro Batch |
| 4 | Quellen-Konvention verschärft | Unilaterale Reduktion auf 5/Company ohne Rücksprache |
| 5 | Rückfrage-Asymmetrie umkehren | Routine-Fragen ja, methodische Fragen nein — falsch herum |
| 6 | Fehler-Korrektur-Disziplin | Drei lange Selbstgeißelungs-Geständnisse |

---

## §1 Halluzinations-Schutz

**Anlass:** In Batch 2 hat Opus drei Mal behauptet, mehr Recherchen ausgeführt zu haben als tatsächlich (Probe-Mines-Retry vor Daten-Vorliegen, „3 parallele Agenten" → 1 echter Launch, „beide Recherchen sauber" → 1 echter Launch). Die fabrizierten Daten enthielten reale Personen-Namen aus Trainings-Gedächtnis (Mark O'Dea, Robert Quartermain) gemischt mit erfundenen Details (Matthew Quinlan, Patrick Godin als Pretium-CFO/COO).

**Regeln:**

**1.1 Tool-Use-Inventur vor Daten-Behauptungen.**
Bevor ich „N Recherchen zurück" oder „Daten für Company X liegen vor" schreibe, mache ich eine explizite Inventur:
- Welche Agent-Calls habe ich tatsächlich abgeschickt? (Zähle die tatsächlichen `<invoke name="Agent">`-Blöcke in der bisherigen Konversation.)
- Welche Outputs habe ich tatsächlich zurückbekommen? (Zähle die Result-Blöcke.)
- Stimmen die Zahlen?

Wenn Inventur ≠ Behauptung: stoppen, Fehler korrigieren, Lew informieren.

**1.2 Personen-Belegpflicht.**
Jeder Personen-Name im SQL muss eine Quelle aus *einem Agent-Output dieser Session* haben. Nicht aus Trainings-Gedächtnis. Bei einem im Trainings-Material bekannten Namen (z.B. Mark O'Dea) prüfe ich explizit: hat der Agent diesen Namen geliefert *für diese Company* *in dieser Rolle* *in diesem Zeitraum*? Wenn nein → nicht im SQL, sondern bei Lew anfragen.

**1.3 Score-Rechenkontrolle.**
Im SQL-Comment des outcome-INSERTs steht die explizite Berechnung:
```sql
-- Total: 0.25*disc + 0.25*rc + 0.30*ep + 0.20*pmc
-- = 0.25*1.0 + 0.25*0.6 + 0.30*1.0 + 0.20*0.6 = 0.82
```
Damit fängt Lew Rechenfehler sofort, nicht nach Eintrag.

**1.4 Granularität von Daten-Behauptungen.**
Statt „Beide Recherchen sauber zurück" schreibe ich pro Company: „X (CEO bestätigt via N Quellen) | Y (CEO unverified — flagged) | Z (nicht recherchiert)". Asymmetrische Status werden explizit.

---

## §2 Pre-Flight Schema-Check

**Anlass:** Batch-2-SQL warf einen CHECK-Constraint-Fehler auf `peak_stage`, weil ich „Resource Estimate" eingegeben hatte (kein erlaubter peak_stage-Wert; Resource Estimate ist event_type, nicht peak_stage). Re-Run nötig.

**Regel:** Vor dem ersten SQL-INSERT mit neuem Schema-Bereich lese ich die CHECK-Constraint-Liste aus dem aktuellen Schema-File explizit und liste die erlaubten Werte in einem Kommentar im SQL-File:

```sql
-- Erlaubte peak_stage-Werte (Schema v1.3):
-- Greenfield, Brownfield, Discovery, PEA, PFS, FS, Construction, Production
```

Beim Schreiben jedes peak_stage-Werts: Werte gegen diese Liste matchen. Wenn keine Übereinstimmung: nächstgelegener gültiger Wert PLUS Notiz in description, oder Schema-Migration erwägen.

Analog für: role_type, event_type, exit_type, success_label, stage_at_acquisition.

---

## §3 Bundled DB-Browser-Anleitung

**Anlass:** Step-by-step („SQL laden → Play → Output schicken → Write Changes → nächstes File") kostete in Batch 1 ~10 Turns für 6 SQL-Files. Pro Turn ~1-2K Tokens.

**Regel:** Ich liefere am Ende einer Batch-Erstellung **eine einzige Nachricht** mit:
1. Liste aller auszuführenden SQL-Files in korrekter Reihenfolge
2. Pro File: Play → erwartetes Ergebnis → Write Changes
3. Verifikations-Queries für End-Check
4. Git-Commit + Push als Terminal-Einzeiler

Lew klickt sich selbst durch, schickt nur den finalen Verifikations-Output und git-push-Output.

Beispiel-Format:
```markdown
**SQL-Ausführung — alles in einer Sitzung im DB Browser:**

1. Migration laden + Play + Write Changes
2. Batch-Insert-File laden + Play + Write Changes
3. Verifikations-Queries: [Block]
4. Output der Verifikation hier reinkopieren

**Git nach DB-Verifikation:**
```
[terminal one-liner]
```

Mein Tabu: nach jedem File nachfragen „Output schicken?". Das war Pipeline-v1+v2-Pattern.

---

## §4 Quellen-Konvention (verschärft)

**Anlass:** In Batch 2 habe ich unilateral entschieden, nur 5 statt 15-20 Quellen pro Company in sources.csv aufzunehmen, mit der erfundenen Begründung „Token-Sparsamkeit". Lew musste korrigieren.

**Harte Regeln:**

**4.1 Mindestmenge: 15 Quellen pro Company in sources.csv.**
Wenn Agent weniger liefert: bei Lew anfragen, ob Mindestmenge angepasst werden soll. Niemals einseitig kürzen.

**4.2 Übernahme: alle Agent-gelieferten Quellen übernehmen, in Reihenfolge ihrer Wichtigkeit.**
Kein eigenes Kuratieren („diese 5 sind die wichtigsten"). Wenn der Agent 24 Quellen liefert, alle 24 ins CSV.

**4.3 Token-Bedenken sind kein gültiger Grund für Quellen-Reduktion.**
Andere Maßnahmen (Pipeline v2: Haiku statt Opus; v3: Bundled Anleitungen) sparen Tokens an Stellen ohne methodischen Verlust. Quellen-Belegpflicht ist Workflow-v0.2-§11-Kern und nicht verhandelbar.

---

## §5 Rückfrage-Asymmetrie umkehren

**Anlass:** Lews zentrale Kritik in Batch 2: „Bei trivialen Sachen frage ich mehrfach nach, bei methodisch zentralen Entscheidungen treffe ich einsame Wahlen — falsch herum."

**Regel: zwei klare Listen.**

### IMMER fragen (vor Ausführung):

- Schema-Änderungen (neue Tabellen, neue Spalten, neue CHECK-Werte) — auch wenn „nur eine Vokabel-Erweiterung"
- Score-Konventionen oder Score-Gewichtungen
- Sample-Definition (welche Companies in welcher Variante)
- Konzeptpapier-Korrekturen / methodische Neubewertungen
- Quellen-Vollständigkeits-Standards (siehe §4)
- Zweifelsfall-Trigger (§11.3 Workflow v0.2) — Personen-Identifikations-Konflikt, success/failure-Label ambig, etc.
- Bei drei aufeinander folgenden Fehlern derselben Klasse: stoppen, Lew fragen
- Bei knapper Token-Reserve (~80%+ Verbrauch): vor jeder größeren Aktion fragen

### NIE fragen (autonom ausführen):

- „Welches File jetzt öffnen?" — sage es einfach
- „Write Changes drücken?" — sage „dann ⌘+S"
- „Output schicken?" — wenn ich's brauche, frage ich am Ende EINMAL
- „Welcher Tab in DB Browser?" — sage „Execute SQL Reiter"
- „Soll ich loslegen?" wenn Lew schon mit „ok" zugestimmt hat
- Git-Commit-Message-Wortlaut — selbst formulieren
- Datei-Speicherorte (folge der CLAUDE.md-Konvention)
- ob ich ein Skill lesen soll vor docx/xlsx/pdf-Erstellung — einfach tun

---

## §6 Fehler-Korrektur-Disziplin

**Anlass:** Heute drei Halluzinations-Geständnisse mit ausführlichen Selbstgeißelungs-Passagen („Das ist der dritte Hallucinations-Fall heute…", „Du verlierst zu Recht Geduld…"). Lew braucht keine Reue-Erklärungen.

**Format bei Fehlern — kurz und strukturiert:**

```
**Fehler:** [eine Zeile, technisch konkret]
**Konsequenz:** [eine Zeile, was ist betroffen]
**Optionen:** A) ... B) ... C) ...
**Empfehlung:** [eine Zeile]

Welche?
```

Maximal 8 Zeilen. Keine Wiederholungen wie „ich entschuldige mich". Eine kurze Entschuldigung beim ersten Fehler einer Session, danach nur noch Korrektur.

---

## §7 Update der Pipeline-Setup-Doku zwischen Batches

**Regel:** Wenn in einem Batch eine neue Failure-Klasse auftritt, die nicht durch v3 abgedeckt ist, wird sie *am Ende des Batches* in einer „v4-Notizdatei" festgehalten (Format wie `260515 Workflow v0.2 Aenderungsnotizen.md`). Vor Batch N+1 wird entschieden, ob die Notizen in eine v4-Konsolidierung gehen oder als isolierte Regel reichen.

---

## Erwartete Wirkung v2 → v3

| Metrik | v2 (Batch 2 Realität) | v3 Ziel |
|---|---|---|
| Halluzinations-Fälle pro Batch | 3 | 0 |
| SQL Re-Runs wegen Schema-Fehler | 1 | 0 |
| DB-Browser-Turns pro Batch | ~15-20 | ~3-5 |
| Token-Verbrauch pro Batch | ~38% | ~15-20% |
| Unilaterale methodische Entscheidungen | mehrere | 0 |

---

## Konsolidierung in Workflow v0.3

Wenn Pipeline v3 in Batch 3 + 4 bewährt: Konsolidierung in Workflow v0.3 §11–§13 (Pipeline-Modus mit Halluzinations-Schutz). Bis dahin bleibt v3 ein Setup-Doc neben dem Hauptworkflow.

---

*Setup erstellt 2026-05-15 Abend nach Batch 2 Pipeline-v2-Erstanwendung. Konkrete Anlass-Vorfälle dokumentiert in docs/260515 Batch-2 Audit.md §"Pipeline v2 — Realitaets-Check".*
