# Batch 5 Task Brief — 5 Diverse Success-Companies

**Datum:** 2026-05-16  
**Status:** Planning Phase  
**Workflow:** Pipeline v3 + Token-Optimization Strategy  

---

## Batch Scope (APPROVED)

**5 Companies — Diversity Focus:**

| # | Company | Commodity | Type | Region | Exit Expected |
|---|---------|-----------|------|--------|----------------|
| 1 | Pretium Resources | Au | M&A | South America (Peru) | 2020 (Yamana) |
| 2 | Detour Gold | Au | M&A + Production | Canada (Ontario) | 2019 (Kirkland Lake) |
| 3 | Sabina Gold & Silver | Au + Ag | Production | Canada (Yukon) | 2020s (Hackett River) |
| 4 | Great Bear Resources | Au | Exploration Stage | Canada (BC/Yukon) | Active/Pending |
| 5 | Osisko Mining | Au | Production + Evolution | Canada (Quebec) | 2020 (Merger) |

**Diversity Metrics:**
- ✅ Exit Types: M&A (3), Production (2), Exploration (1)
- ✅ Commodities: Gold-primary (4), Multi-metal (1)
- ✅ Geography: Canada (4), South America (1)
- ✅ Timeline: 2015-2025 cluster
- ✅ Company Profile: Mix Junior-to-Intermediate

---

## Research Requirements

**Per Company Minimum:** 15 Sources (Pipeline v3 §4)  
**Total Expected:** ~75-90 sources  

**Source Types (Mix Required):**
- Press releases (company, acquirer)
- SEC/SEDAR filings (AIF, MD&A, technical reports)
- Mining news (Mining.com, Northern Miner, Mining Weekly)
- Technical reports (NI 43-101)
- Academic/industry publications
- News archives (Globe & Mail, Reuters, etc.)

---

## Delivery Checklist

**Research Phase:**
- [ ] Pretium Resources: ~15 sources (CEO, M&A deal, technical)
- [ ] Detour Gold: ~15 sources (M&A, production ramp, people)
- [ ] Sabina Gold & Silver: ~15 sources (development, permits, people)
- [ ] Great Bear Resources: ~15 sources (discovery, exploration, funding)
- [ ] Osisko Mining: ~15 sources (production, merger, evolution)

**Database Integration:**
- [ ] SQL Insert file created and tested (local Python)
- [ ] All persons identified and cross-linked (no duplicates)
- [ ] Outcome scores calculated with explicit formulas
- [ ] Events documented (Discovery, PEA/PFS/FS, M&A, Production Start, etc.)

**Documentation:**
- [ ] Audit file: `260517 Batch 5 Audit.md` (1-2 pages, minimal)
- [ ] Sources CSV: 75-90 rows added to sources.csv
- [ ] Git commit + push

**Total Token Budget Target:** 8,000 tokens (~$0.12)

---

## New Workflow Rules (Token Optimization)

### For this Batch:

1. **Sources saved immediately** after each Agent-call
   - Format: `260517 [Company] Quellen.md`
   - Location: `/docs/research/`
   - Includes: Citation, URL, Accessed Date, Source Type

2. **SQL Template pre-prepared**
   - User creates skeleton `260517 Batch 5 Insert Template.sql`
   - Claude fills data, tests locally, delivers

3. **Minimal Audit** (not 500KB document)
   - 1-2 page summary
   - Scores + key decisions
   - References to Quick-Reference Index

4. **Local Python execution**
   - No manual DB Browser steps
   - Verify → execute → report results

5. **Memory + Index utilization**
   - Refer to `260516 Projekt Status Quick Reference.md`
   - Check Memory for prior decisions before questioning

---

## Timeline Estimate

- **Research:** 4-6 hours (Haiku agents, 5 sequential calls)
- **SQL Preparation:** 1-2 hours (template + data entry)
- **Database Integration:** 1 hour (Python insert + verify)
- **Audit + Documentation:** 1 hour
- **Total:** ~7-10 hours, compressed into ~8K tokens

---

## Known Constraints

- **Great Bear Resources:** May still be active (no M&A exit) → classify as 'Active' or 'Pending'
- **Osisko Mining:** Complex merger history (Osisko Gold → Osisko Mining merger 2020) — clarify parent/child relationships
- **Sabina Gold & Silver:** Hackett River still in development (PFS stage 2023) — may be 'Active' not 'Success'

---

## Go/No-Go Decision

✅ **APPROVED** — Batch 5 Scope locked. Ready for Phase 2.2 (SQL Template) + Phase 2.3 (Source Protocol).

---

*Task Brief created 2026-05-16. Next: SQL Template + Source Protocol setup.*
