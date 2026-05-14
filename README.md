# Junior-Mining Erfolgs-Datenbank

Forschungsdatenbank zur Quantifizierung des Zusammenhangs zwischen
Personal-Track-Record und Erfolg bei Junior-Mining-Unternehmen.
Empirische Prüfung der Branchenheuristik "Bet on the jockey,
not the horse" (Rick Rule, Brent Cook, Eric Coffin).

## Status

Phase 1 abgeschlossen — Konzeptpapier v0.4 liegt vor.
Phase 2 in Vorbereitung: SQLite-Pilotdatenbank mit
25 erfolgreichen + 25 erfolglosen TSX/TSX-V Junior-Companies
(Edelmetalle, 2006–2026).

## Ordnerstruktur

- `docs/` — Konzeptpapiere und Entscheidungsdokumente
- `sql/` — SQL-Schema und Migrationen
- `scripts/` — Python-Scripts für Datenextraktion und Auswertung
- `data/` — SQLite-Datenbank-Datei (kommt in Phase 2)

## Software-Stack

SQLite + Python (siehe `docs/Entscheidung_Software-Stack.docx`).

## Aktuelles Konzeptpapier

`docs/Konzeptpapier_Junior-Mining-Erfolgs-Datenbank_v0.4.docx`

## Methodische Eckpfeiler

- Multi-Kriterien-Score (Discovery, Reserve-Conversion, M&A-Exit/Produktion, Peak-MarketCap)
- Empirische Gewichts-Kalibrierung statt heuristischer Vorgabe
- Negativ-Sample zur Survivorship-Bias-Korrektur
- Ambivalente Personen (in beiden Listen) zur Reverse-Causation-Mitigation
