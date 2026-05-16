{\rtf1\ansi\ansicpg1252\cocoartf2822
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\paperw11900\paperh16840\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0

\f0\fs24 \cf0 # Junior Mining DB \'97 Projekt Status\
\
## \uc0\u55357 \u56522  Datenbank-\'dcbersicht (Stand 2026-05-16)\
- **Pfad:** /Users/lew/Dokumente/Business/JuniorMiner/JuniorMining/data/junior_mining.db\
- **Companies:** 22 (Batches 1-4 komplett)\
- **Persons:** 90\
- **Roles:** 140+\
- **Outcomes:** 21\
- **Events:** 187\
- **Sources:** 403\
\
## \uc0\u55357 \u56615  Schema v1.3\
Erlaubte Werte (CHECK-Constraints):\
- **success_label:** 'success', 'failure', 'ambivalent', 'pending'\
- **role_type:** CEO, Chairman, CFO, COO, President, VP Exploration, Chief Geologist, Project Geologist, Cornerstone Investor, Founder\
- **stage_at_acquisition:** Greenfield, Brownfield, Discovery, PEA, PFS, FS, Construction, Production\
- **exit_type:** M&A, Production, Insolvency, Delisting, Active\
- **event_type:** PEA, PFS, FS, Discovery, M&A, Delisting, Insolvency, Industry Award, IPO, Production Start, Resource Estimate, Exchange Upgrade, Permit Granted, Permit Denied, Expropriation, Arbitration Award\
\
## \uc0\u55357 \u56523  Batch-Status\
| Batch | Companies | Status | Sources |\
|-------|-----------|--------|---------|\
| 1 | Aurelian, Crystallex, Colossus, Allied Nevada, Banro | \uc0\u9989  | 90 |\
| 2 | Probe Mines, Pretium, Reservoir | \uc0\u9989  | 85 |\
| 3 | Aurcana, Gold Mountain, Apollo, Avion, Sulliden | \uc0\u9989  | 85 |\
| 4 | Kaminak, Continental, NovaGold, Underworld, Virginia | \uc0\u9989  | 91 |\
| 5 | TBD | \uc0\u9203  | \'97 |\
\
## \uc0\u9888 \u65039  Bekannte Issues & Workarounds\
- **Journal-Datei-Lock:** `rm /Users/lew/Dokumente/Business/JuniorMiner/JuniorMining/data/junior_mining.db-journal`\
- **DB \'f6ffnen fehlgeschlagen:** Alte DB als backup umbenennen, neue DB kopieren\
- **Sources verloren:** Jetzt immer nach Agent-Output speichern\
\
## \uc0\u55356 \u57263  Pipeline v3 Regeln (Quick Check)\
\uc0\u9989  Min. 15 Quellen pro Company  \
\uc0\u9989  Alle Agent-Outputs sofort speichern  \
\uc0\u9989  Score-Formeln im SQL-Kommentar  \
\uc0\u9989  Pre-Flight-Check vor SQL-Execute  \
\uc0\u9989  R\'fcckfrage bei methodischen Entscheidungen  \
\
## \uc0\u55357 \u56592  Dateibenennung\
Format: `YYMMDD Wer/Was Zweck`  \
Beispiele:\
- `260516 Batch 4 Audit.md`\
- `260517 Kaminak Quellen.md` (NEW)}