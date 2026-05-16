# Batch 4 — Task Brief (kurz)

**Adressat:** Claude-Session (Haiku/Sonnet, NICHT Opus erforderlich)

## Vor Start lesen
1. `docs/260515 Pipeline v3 Setup.md` — Halluzinations-Schutz, §1.1 Inventur, §2 Pre-Flight-Check, §4 Quellen ≥15
2. `docs/260515 Workflow Junior-Mining-DB v0.2.docx` — Konventionen, Score-Kriterien §7, Role-Vokabel §3.1
3. `docs/260515 Batch-3 Audit.md` — letzter Vorgang als Muster
4. `sql/260514 SQL-Schema Junior-Mining-DB v1.sql` — CHECK-Constraints

## Companies (alle success-erwartet)
1. **Kaminak Gold** — Au, Coffee Gold Yukon, M&A Goldcorp 2016 CAD 520M, Eira Thomas CEO
2. **Continental Gold** — Au, Buritica Kolumbien, M&A Zijin 2020 CAD 1.4 Mrd, **Ari Sussman post-Colossus**
3. **NovaGold Resources** — Au, frühe Phase pre-Donlin/Galore-Creek
4. **Underworld Resources** — Au, White Gold District Yukon, M&A Kinross 2010
5. **Virginia Mines** — Au, Eleonore Quebec, M&A Goldcorp 2006 + Virginia-Hecla-Spin-off

## Cross-Link-Prüfung beim Eintragen
Person bereits in `person`-Tabelle? Wiederverwenden (neue role-Zeile), NICHT duplizieren. Speziell prüfen:
- **Ari Sussman** (existiert ab Colossus) → muss bei Continental Gold mit role verknüpft werden
- Andere serielle Personen analog

## Ausführung
- 1 Haiku-Agent pro Company sequenziell. Output: strukturierte Markdown nach Schema in Workflow v0.2 §3-§9
- Schema-Pre-Flight: `PRAGMA table_info(...)` lesen, CHECK-Werte gegen Input verifizieren
- DB-Schreibung direkt via Python sqlite3, BEGIN/COMMIT/ROLLBACK atomar
- DB-Pfad: `/sessions/<session>/mnt/JuniorMining/data/junior_mining.db`
- sources.csv anhängen: ≥15 pro Company, format aus existierender Datei

## Deliverables
1. SQL-Inserts committed in DB (16 → 21 Companies)
2. `data/sources.csv` erweitert (~75 Zeilen)
3. `docs/260515 Batch 4 Audit.md` mit Score-Tabelle + Cross-Links + Flags
4. KEIN git commit — Lew macht selbst

## NICHT tun
- Personen aus Trainings-Wissen behaupten (nur Recherche-Output verwenden)
- "5 Agenten gelauncht" ohne Inventur-Zählung
- Schema-Migrationen ohne Lew-Rücksprache
- Eigene git operations

## Bei fertig
Kurzer Status: 5 Companies, Score-Tabelle, Cross-Links gefunden, Audit-File-Pfad, vorgeschlagener git commit (eine Zeile). Lew reviewt und committet.
