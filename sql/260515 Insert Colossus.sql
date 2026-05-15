-- ============================================================================
-- Insert: Colossus Minerals Inc.
--   Sample: FAILURE
--   Methodisch: Reverse-Causation-Test fuer Ari Sussman (verlaesst Colossus
--   Okt 2012, Insolvenz Jan 2014 unter Mancuso/Massola; Sussmans spaeterer
--   Continental-Gold-Erfolg post-Colossus).
-- ============================================================================
-- Schema-Voraussetzung: v1.3
-- Audit: docs/260515 Batch-1 Audit.md (Abschnitt 2)
-- ============================================================================

PRAGMA foreign_keys = ON;

-- 1) company
INSERT INTO company (
    name, isin, country, stock_exchange,
    listing_year, delisting_year,
    primary_commodity, commodity_2, commodity_3,
    fraud_flag, success_label
) VALUES (
    'Colossus Minerals Inc.', 'CA19681L1094', 'Canada', 'TSX',
    2008, 2014,
    'Au', 'Pd', 'Pt',
    0, 'failure'
);

-- 2) person (7 Personen mit Exekutiv-Rollen; reine Directors ausgeschlossen.
-- Hinweis: Patrick Anderson (Aurelian-Founder, Mining Person of the Year 2008)
-- trat 2013 dem Colossus-Board bei. Per Workflow-Scope (Non-Exec-Directors
-- ausgespart) NICHT erfasst — methodisch beachtenswerter Datenpunkt zu
-- Personen-Cross-Links im Audit-Log dokumentiert.)
INSERT INTO person (vorname, nachname, country, education,
    production_ramp_up_experience, first_mention_year, first_mention_source, bio_text)
VALUES
    ('Ari', 'Sussman', 'Canada', NULL,
     0, 2006, 'SEDAR-CSI-AIF',
     'Founder/CEO Colossus Minerals (2006-2011), Chairman 2006-2012. Assembled Serra Pelada project with geologist Vic Wall. Verliess Colossus Okt 2012; spaeter Founder/CEO Continental Gold (2010-2020, verkauft an Zijin C$1.4B 2020), dann Collective Mining. Promoter-Profil.'),

    ('John', 'Frostiak', 'Canada', 'P.Eng. Ontario; member CIM',
     1, 2007, 'SEDAR-CSI-AIF',
     '30+ years Barrick Gold als Corporate Project Manager. Leitete Prozessanlagen-Entwicklung bei Pierina (Peru), Bulyanhulu (Tansania), Cowal (Australien). Colossus-Board seit Sept 2007. Uebernahm Chairman-Rolle 2012-10-15 nach Sussman-Abgang.'),

    ('Claudio', 'Mancuso', 'Canada', NULL,
     0, 2011, 'PR-CSI-2011-MANCUSO',
     'President & CEO Colossus Maerz 2011 bis Nov 2013. Vorher knapp 10 Jahre bei Agnico-Eagle Mines, zuletzt VP Treasurer (ab Jan 2009). Hands-on CEO; haeufig vor Ort am Serra Pelada.'),

    ('David', 'Massola', 'Canada', NULL,
     1, 2012, 'SEDAR-CSI-AIF',
     'CFO Colossus ab ~2012, Interim CEO 15.11.2013 durch Restrukturierung. 20+ Jahre bei BHP-Billiton inkl. VP Finance BHP Diamonds. Spaeter CFO/Executive-Rollen bei Fortune Minerals.'),

    ('Paulo', 'Fagundes', 'Brazil',
     'BSc Universidade Federal do Rio Grande do Sul; MBA University of São Paulo',
     1, 2011, 'WEB-BUSEX-CSI',
     'Brasilianischer Bergbau-Manager (Paulo de Tarso Serpa Fagundes). Decades operating experience in Pará. Hatte Mienen fuer Yamana Gold gebaut vor Colossus-COO-Rolle. Lokale Beziehungen + portugiesische Management-Faehigkeit.'),

    ('Vic', 'Wall', 'Australia',
     'PhD Geology (Australien)',
     0, 2006, 'SEDAR-CSI-AIF',
     'Senior VP Exploration Colossus; reinterpretierte Serra-Pelada-Geologie und steuerte Drill-Targeting. Co-Winner Goldcorp Challenge 2001. Gruendender geologischer Partner mit Sussman; auch Co-Founder Continental Gold als Special Advisor. Verstorben; ScienceDirect-Paper zu Serra Pelada-Geochemie seinem Andenken gewidmet (Berni et al. 2014, Economic Geology v.109).'),

    ('David', 'D''Onofrio', 'Canada', NULL,
     0, 2006, 'SEDAR-CSI-AIF',
     'Founding director of Colossus Minerals. Spaeter CEO bei White Gold Corp. Per Workflow-Scope hier nur als Founder erfasst (Director-Rolle ausgeschlossen).');

-- 3) role (12 Rollen)
INSERT INTO role (person_id, company_id, role_type, start_date, end_date) VALUES
    ((SELECT id FROM person WHERE vorname='Ari' AND nachname='Sussman'),
     (SELECT id FROM company WHERE name='Colossus Minerals Inc.'),
     'CEO', '2006-02-09', '2011'),

    ((SELECT id FROM person WHERE vorname='Ari' AND nachname='Sussman'),
     (SELECT id FROM company WHERE name='Colossus Minerals Inc.'),
     'Chairman', '2006-12-15', '2012-10-15'),

    ((SELECT id FROM person WHERE vorname='Ari' AND nachname='Sussman'),
     (SELECT id FROM company WHERE name='Colossus Minerals Inc.'),
     'Founder', '2006-02-09', '2012-10-15'),

    ((SELECT id FROM person WHERE vorname='John' AND nachname='Frostiak'),
     (SELECT id FROM company WHERE name='Colossus Minerals Inc.'),
     'Chairman', '2012-10-15', '2014'),

    ((SELECT id FROM person WHERE vorname='Claudio' AND nachname='Mancuso'),
     (SELECT id FROM company WHERE name='Colossus Minerals Inc.'),
     'President', '2011-03', '2013-11'),

    ((SELECT id FROM person WHERE vorname='Claudio' AND nachname='Mancuso'),
     (SELECT id FROM company WHERE name='Colossus Minerals Inc.'),
     'CEO', '2011-03', '2013-11-15'),

    ((SELECT id FROM person WHERE vorname='David' AND nachname='Massola'),
     (SELECT id FROM company WHERE name='Colossus Minerals Inc.'),
     'CFO', '2012', '2014'),

    ((SELECT id FROM person WHERE vorname='David' AND nachname='Massola'),
     (SELECT id FROM company WHERE name='Colossus Minerals Inc.'),
     'CEO', '2013-11-15', '2014'),

    ((SELECT id FROM person WHERE vorname='Paulo' AND nachname='Fagundes'),
     (SELECT id FROM company WHERE name='Colossus Minerals Inc.'),
     'COO', '2011', '2014'),

    ((SELECT id FROM person WHERE vorname='Vic' AND nachname='Wall'),
     (SELECT id FROM company WHERE name='Colossus Minerals Inc.'),
     'VP Exploration', '2006', '2013'),

    ((SELECT id FROM person WHERE vorname='Vic' AND nachname='Wall'),
     (SELECT id FROM company WHERE name='Colossus Minerals Inc.'),
     'Founder', '2006', NULL),

    ((SELECT id FROM person WHERE vorname='David' AND nachname='D''Onofrio'),
     (SELECT id FROM company WHERE name='Colossus Minerals Inc.'),
     'Founder', '2006', NULL);

-- 4) project
INSERT INTO project (
    company_id, name, jurisdiction,
    primary_commodity, commodity_2, commodity_3,
    deposit_type, stage_at_acquisition, peak_stage,
    parent_project_id
) VALUES (
    (SELECT id FROM company WHERE name='Colossus Minerals Inc.'),
    'Serra Pelada',
    'Brazil, Pará State (Carajás region)',
    'Au', 'Pd', 'Pt',
    'Hydrothermal Au-Pd-Pt (epigenetisch, in Metasilstein)',
    'Brownfield',
    'Construction',
    NULL
);

-- 5) outcome
-- Discovery 0.5: NI 43-101 Resource Estimate Dez 2013 publiziert, aber
--   Lagerstaette war historisch artisanal abgebaut.
-- Reserve-Conversion 0.0: KEIN PEA/PFS/FS jemals abgeschlossen — Sprung
--   Discovery -> Construction. Governance-Failure-Signatur.
-- Exit 0.0: BIA-Insolvenz Jan 2014, Equity-Total-Verlust.
-- Peak-MarketCap 0.6: ~700 Mio CAD (~80M Aktien × CAD 9 April 2011).
-- Total: 0.25*0.5 + 0.25*0 + 0.30*0 + 0.20*0.6 = 0.245
INSERT INTO outcome (
    company_id,
    discovery_score, reserve_conversion_score,
    exit_production_score, peak_marketcap_score,
    total_score, exit_type, exit_year,
    peak_marketcap_cad_million
) VALUES (
    (SELECT id FROM company WHERE name='Colossus Minerals Inc.'),
    0.5, 0.0, 0.0, 0.6,
    0.245, 'Insolvency', 2014,
    700.0
);

-- 6) event
INSERT INTO event (company_id, event_type, event_date, description) VALUES
    ((SELECT id FROM company WHERE name='Colossus Minerals Inc.'),
     'IPO', '2008-02',
     'IPO und TSX-Listing (Symbol CSI); 17.2M Units + 2.58M over-allotment, Gross C$24.7M.'),

    ((SELECT id FROM company WHERE name='Colossus Minerals Inc.'),
     'Discovery', '2009',
     'High-Grade Drill-Intercepts Serra Pelada beginnen, u.a. 7.30 m mit 1,494.7 g/t Au, 516.6 g/t Pt, 558.9 g/t Pd (Drill-Programm 2009-2011 erweitert zentrale Mineralisierungszone).'),

    ((SELECT id FROM company WHERE name='Colossus Minerals Inc.'),
     'M&A', '2012-09',
     'Sandstorm Gold USD 75 Mio Long-Term-Precious-Metal-Streaming-Transaktion unterzeichnet (Streaming-Deal, kein klassisches M&A — als M&A kategorisiert mangels passendem event_type).'),

    ((SELECT id FROM company WHERE name='Colossus Minerals Inc.'),
     'Resource Estimate', '2013-12-20',
     'Erste NI 43-101 Mineral Resource Estimate (RPA: William E. Roscoe & Pierre Landry) bei 5 g/t Au cutoff. Indicated + Inferred. KEIN PEA/PFS/FS.'),

    ((SELECT id FROM company WHERE name='Colossus Minerals Inc.'),
     'Insolvency', '2014-01-14',
     'Notice of Intention unter Bankruptcy and Insolvency Act (BIA), Canada — NICHT CCAA. Duff & Phelps Restructuring Inc. als Proposal Trustee. Ausgeloest durch Zinszahlungs-Default auf Gold-linked Convertible Notes.'),

    ((SELECT id FROM company WHERE name='Colossus Minerals Inc.'),
     'Delisting', '2014-02-21',
     'TSX delisted CSI common shares, CSI.NT notes, CSI.WT.A + CSI.WT.B warrants wegen Failure to Meet Continued Listing Requirements.'),

    ((SELECT id FROM company WHERE name='Colossus Minerals Inc.'),
     'Insolvency', '2014-04-30',
     'Court-approved Proposal & Plan of Reorganization implementiert. 200:1 Share Consolidation; neue Stammaktien + Warrants an Glaeubiger ausgegeben. Equity de facto wiped out.');
