# Batch 5 Quellen-Sammel-Protokoll

**Zweck:** Jede Agent-Recherche sofort dokumentieren (Token-Sparmaßnahme)  
**Format:** Nach JEDER Agent-Recherche ausfüllen und speichern  
**Ablauf:** Agent-Output → Quellen-Datei → SQL später  

---

## Company 1: Pretium Resources

**Status:** ⏳ Pending  
**Expected Sources:** ~15  

**Quellen (nach Agent-Recherche eintragen):**

```
1. [URL] — [Citation] (accessed 2026-05-17, [press/filing/web/academic])
2. [URL] — [Citation] (accessed 2026-05-17, [type])
...
15. [URL] — [Citation] (accessed 2026-05-17, [type])
```

**Key Data Points (für SQL später):**
- CEO/Founder: [Name]
- M&A Partner: [Company]
- Deal Value: [Currency]
- Deal Date: [YYYY-MM-DD]
- Exit Year: 2020

---

## Company 2: Detour Gold

**Status:** ⏳ Pending  
**Expected Sources:** ~15  

**Quellen (nach Agent-Recherche eintragen):**

```
1. [URL] — [Citation] (accessed 2026-05-17, [type])
2. [URL] — [Citation] (accessed 2026-05-17, [type])
...
15. [URL] — [Citation] (accessed 2026-05-17, [type])
```

**Key Data Points (für SQL später):**
- CEO: [Name]
- M&A Acquirer: Kirkland Lake Gold
- Deal Value: [CAD Amount]
- Production Start: [Date]
- Exit Year: 2019

---

## Company 3: Sabina Gold & Silver

**Status:** ⏳ Pending  
**Expected Sources:** ~15  

**Quellen (nach Agent-Recherche eintragen):**

```
1. [URL] — [Citation] (accessed 2026-05-17, [type])
2. [URL] — [Citation] (accessed 2026-05-17, [type])
...
15. [URL] — [Citation] (accessed 2026-05-17, [type])
```

**Key Data Points (für SQL später):**
- Primary Project: Hackett River (Au + Ag)
- Founder/CEO: [Name]
- Status: Production development
- Stage: PFS/DFS
- Notable: Multi-commodity (Au + Ag)

---

## Company 4: Great Bear Resources

**Status:** ⏳ Pending  
**Expected Sources:** ~15  

**Quellen (nach Agent-Recherche eintragen):**

```
1. [URL] — [Citation] (accessed 2026-05-17, [type])
2. [URL] — [Citation] (accessed 2026-05-17, [type])
...
15. [URL] — [Citation] (accessed 2026-05-17, [type])
```

**Key Data Points (für SQL später):**
- Primary Project: [Project Name]
- Founder/CEO: [Name]
- Status: Exploration/Discovery
- Notable: Active (no M&A exit) → classify as 'Active' in DB
- Discovery Year: [YYYY]

---

## Company 5: Osisko Mining

**Status:** ⏳ Pending  
**Expected Sources:** ~15  

**Quellen (nach Agent-Recherche eintragen):**

```
1. [URL] — [Citation] (accessed 2026-05-17, [type])
2. [URL] — [Citation] (accessed 2026-05-17, [type])
...
15. [URL] — [Citation] (accessed 2026-05-17, [type])
```

**Key Data Points (für SQL später):**
- Primary Projects: [List]
- M&A/Merger: Osisko Gold → Osisko Mining (2020)
- Production Status: Production
- CEO/Founder: [Name]
- Exit Type: Corporate Evolution/M&A

---

## Format für jede Quelle

**Vorlage (Copy-Paste für jede Quelle):**

```
[SOURCE_NUMBER]. [URL] — [Citation/Title], [Author if relevant], [Date]
   accessed: 2026-05-17
   type: [press/filing/web/academic/other]
   note: [Optional: Relevanz für diese Company]
```

**Beispiel:**

```
1. https://www.sedarplus.ca/csa-party/records/document.html?id=abc123 
   — Pretium Resources Inc., Annual Information Form (AIF) 2019
   accessed: 2026-05-17
   type: filing
   note: CEO Walcott, M&A timing and deal structure
```

---

## Workflow

1. **Agent macht Recherche:** Haiku-Agent für 1 Company
2. **Output erhalten:** Agent liefert ~15+ Quellen zurück
3. **Speichern (SOFORT):** Diese Datei aktualisieren mit allen Quellen
4. **Format:** Alle Quellen in Sektion der Company eintragen
5. **Repeat:** Nächste Company, nächster Agent, gleicher Prozess
6. **Final:** Nach allen 5 Companies → Alle Quellen sind dokumentiert
7. **CSV später:** Alle Quellen aus diesem Protokoll → sources.csv

---

## Status Summary

| Company | Status | Sources Found | Ready for SQL |
|---------|--------|----------------|----------------|
| 1. Pretium | ⏳ | — | ❌ |
| 2. Detour | ⏳ | — | ❌ |
| 3. Sabina | ⏳ | — | ❌ |
| 4. Great Bear | ⏳ | — | ❌ |
| 5. Osisko | ⏳ | — | ❌ |

---

*Protokoll erstellt 2026-05-17. Update nach jeder Agent-Recherche.*
