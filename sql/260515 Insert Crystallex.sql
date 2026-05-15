-- ============================================================================
-- Insert: Crystallex International Corporation
--   Sample: FAILURE
--   Matched Pair: zu Aurelian Resources (beide Au Suedamerika)
-- ============================================================================
-- Schema-Voraussetzung: v1.3 (event_type um 'Permit Granted', 'Permit Denied',
--                       'Expropriation', 'Arbitration Award' erweitert)
-- Audit: docs/260515 Batch-1 Audit.md (Abschnitt 1)
-- Reihenfolge: company -> person -> role -> project -> outcome -> event
-- ============================================================================

PRAGMA foreign_keys = ON;

-- 1) company
INSERT INTO company (
    name, isin, country, stock_exchange,
    listing_year, delisting_year,
    primary_commodity, commodity_2, commodity_3,
    fraud_flag, success_label
) VALUES (
    'Crystallex International Corporation', NULL, 'Canada', 'TSX → NYSE-AMEX',
    1984, 2012,
    'Au', 'Ag', NULL,
    0, 'failure'
);

-- 2) person (8 Personen mit Exekutiv-Rollen; reine Direktoren ausgeschlossen
-- per Workflow v0.2 §3.1; Luis Felipe Cottin als President der venezolanischen
-- Tochter nicht aufgenommen, da Rolle nicht parent-Crystallex).
INSERT INTO person (vorname, nachname, country, education,
    production_ramp_up_experience, first_mention_year, first_mention_source, bio_text)
VALUES
    ('Marc', 'Oppenheimer', 'USA', NULL,
     0, 1995, 'SEC-CRY-2013-20F',
     'Former President/CEO of Crystallex (Feb 1995 – Sep 2003), Vice Chairman to May 2004. Prior career: merchant banking; Chase Manhattan Bank, Midlantic National Bank. Later EVP/CFO/COO at IDT Corporation.'),

    ('Robert', 'Fung', 'Canada', 'University of Toronto (degree unconfirmed)',
     0, 1998, 'MS-CRY-2026-bio',
     'Veteran investment banker; Vice Chairman of Gordon Capital Corp 1980-1998. Key role in Petro-Canada privatization. Chairman of Crystallex from Feb 1998; assumed CEO role June 2008 after Thompson resignation.'),

    ('Todd', 'Bruce', 'Canada', NULL,
     1, 2003, 'TWST-CRY-2004-interview',
     'President & CEO of Crystallex from Sep 2003. Previously President & COO of IAMGOLD Corp 1996-2003 (oversaw commercial production of Sadiola 1997 and Yatela 2001). Earlier 1980-1996 at Johannesburg Consolidated Investment Co. (SA).'),

    ('Gordon', 'Thompson', NULL, NULL,
     0, 2007, 'MW-CRY-2008-press',
     'President & CEO of Crystallex ca. 2007-2008. Resigned 3 Jun 2008 after Venezuelan environmental permit denial in April 2008. [country/education not confirmed in available sources]'),

    ('Kenneth', 'Thomas', 'Canada',
     'PhD Project Implementation Delft University of Technology; MSc Management Imperial College London',
     1, 2005, 'CIM-CRY-2010-award',
     'COO of Crystallex (Venezuela/Uruguay operations) ca. 2005-2007. 46+ years industry; senior roles at Barrick Gold 1987-2001 (VP Metallurgy to SVP Technical Services). CIM Selwyn G. Blaylock Medal 2001; past CIM president.'),

    ('Robert', 'Crombie', 'Canada',
     'BCom (Honours) Queen''s University; MSc Mineral Economics Penn State',
     0, 2000, 'MS-CRY-2026-bio',
     '12-year Crystallex veteran (Senior VP Corporate Development, VP Finance). Promoted to President, Acting CFO and VP 2011-2012 during CCAA proceedings. Prior: VP Corporate Finance at Chase Manhattan Bank Toronto until 1999; Corona Corporation 1989-1992.'),

    ('Hemdat', 'Sawh', 'Canada', 'Chartered Accountant (CPA, CA)',
     0, 2008, 'MS-CRY-2026-bio',
     'Chartered Accountant with 16+ years at Grant Thornton LLP. Served as CFO of Crystallex ca. 2008-2011 (between Crombie tenure). Subsequent CFO roles at Goldbelt Resources, Americas Gold & Silver, Wesdome Gold Mines.'),

    ('Richard', 'Spencer', 'Canada',
     'PhD Geology; P.Geo. (Ontario); Chartered Geologist (UK)',
     0, 2004, 'SEC-CRY-2007-AIF',
     'VP Exploration at Crystallex 2004-2008; led Las Cristinas exploration where team added 6.6 Moz to gold reserves via in-fill drilling. Qualified Person for NI 43-101 disclosure. 10 years prior Ecuador experience. Later founded/led Aurania Resources.');

-- 3) role (15 Rollen)
INSERT INTO role (person_id, company_id, role_type, start_date, end_date) VALUES
    ((SELECT id FROM person WHERE vorname='Marc' AND nachname='Oppenheimer'),
     (SELECT id FROM company WHERE name='Crystallex International Corporation'),
     'CEO', '1995-02', '2003-09-22'),

    ((SELECT id FROM person WHERE vorname='Marc' AND nachname='Oppenheimer'),
     (SELECT id FROM company WHERE name='Crystallex International Corporation'),
     'President', '1995-02', '2003-09-22'),

    ((SELECT id FROM person WHERE vorname='Robert' AND nachname='Fung'),
     (SELECT id FROM company WHERE name='Crystallex International Corporation'),
     'Chairman', '1998-02-12', '2009'),

    ((SELECT id FROM person WHERE vorname='Robert' AND nachname='Fung'),
     (SELECT id FROM company WHERE name='Crystallex International Corporation'),
     'CEO', '2008-06-03', '2009'),

    ((SELECT id FROM person WHERE vorname='Todd' AND nachname='Bruce'),
     (SELECT id FROM company WHERE name='Crystallex International Corporation'),
     'CEO', '2003-09-22', '2007'),

    ((SELECT id FROM person WHERE vorname='Todd' AND nachname='Bruce'),
     (SELECT id FROM company WHERE name='Crystallex International Corporation'),
     'President', '2003-09-22', '2007'),

    ((SELECT id FROM person WHERE vorname='Gordon' AND nachname='Thompson'),
     (SELECT id FROM company WHERE name='Crystallex International Corporation'),
     'CEO', '2007', '2008-06-03'),

    ((SELECT id FROM person WHERE vorname='Gordon' AND nachname='Thompson'),
     (SELECT id FROM company WHERE name='Crystallex International Corporation'),
     'President', '2007', '2008-06-03'),

    ((SELECT id FROM person WHERE vorname='Kenneth' AND nachname='Thomas'),
     (SELECT id FROM company WHERE name='Crystallex International Corporation'),
     'COO', '2005', '2007'),

    ((SELECT id FROM person WHERE vorname='Robert' AND nachname='Crombie'),
     (SELECT id FROM company WHERE name='Crystallex International Corporation'),
     'CFO', '2011', '2012'),

    ((SELECT id FROM person WHERE vorname='Robert' AND nachname='Crombie'),
     (SELECT id FROM company WHERE name='Crystallex International Corporation'),
     'President', '2011', '2012'),

    ((SELECT id FROM person WHERE vorname='Hemdat' AND nachname='Sawh'),
     (SELECT id FROM company WHERE name='Crystallex International Corporation'),
     'CFO', '2008', '2011'),

    ((SELECT id FROM person WHERE vorname='Richard' AND nachname='Spencer'),
     (SELECT id FROM company WHERE name='Crystallex International Corporation'),
     'VP Exploration', '2004', '2008');

-- 4) project (Las Cristinas als Haupt-Projekt; weitere Operations (Tomi, Lo
-- Increible, Albino) und Revemin Mill in description erwaehnt aber nicht
-- separat eingetragen — Workflow-Pragmatik fuer Phase 2.)
INSERT INTO project (
    company_id, name, jurisdiction,
    primary_commodity, commodity_2, commodity_3,
    deposit_type, stage_at_acquisition, peak_stage,
    parent_project_id
) VALUES (
    (SELECT id FROM company WHERE name='Crystallex International Corporation'),
    'Las Cristinas',
    'Venezuela, Bolívar State (Km 88, El Dorado)',
    'Au', 'Cu', NULL,
    'Shear-zone hosted / porphyry Au-Cu',
    'Brownfield',
    'FS',
    NULL
);

-- 5) outcome
-- Discovery 0.5: keine eigene Greenfield-Discovery, aber Spencer-Team
--   addierte 6.6 Moz Au-Reserven via in-fill drilling (Workflow §7.1).
-- Reserve-Conversion 1.0: SNC-Lavalin FS 2003 + Update 2005, Proven+Probable
--   Reserves 16.9 Moz Au.
-- Exit-Production 0.0: CCAA 2011, Total-Verlust Equity.
-- Peak-MarketCap 0.6: ~1.0-1.5 Mrd CAD in 2006-2007 (peak share price
--   ~CAD 4.99-7, ~250-300M shares); konservativ unterer Bucket.
-- Total: 0.25*0.5 + 0.25*1.0 + 0.30*0.0 + 0.20*0.6 = 0.495
INSERT INTO outcome (
    company_id,
    discovery_score, reserve_conversion_score,
    exit_production_score, peak_marketcap_score,
    total_score, exit_type, exit_year,
    peak_marketcap_cad_million
) VALUES (
    (SELECT id FROM company WHERE name='Crystallex International Corporation'),
    0.5, 1.0, 0.0, 0.6,
    0.495, 'Insolvency', 2011,
    1200.0
);

-- 6) event (13 Events; nutzt 4 neue Schema-v1.3-Typen: Permit Granted,
-- Permit Denied, Expropriation, Arbitration Award)
INSERT INTO event (company_id, event_type, event_date, description) VALUES
    ((SELECT id FROM company WHERE name='Crystallex International Corporation'),
     'IPO', '1984',
     'TSX Listing. Crystallex urspruenglich in BC inkorporiert 1984; spaeter unter CBCA fortgefuehrt 1998. Exaktes TSX-Listing-Datum nicht aus oeffentlichen Quellen verifiziert.'),

    ((SELECT id FROM company WHERE name='Crystallex International Corporation'),
     'M&A', '1997',
     'Erwerb initialer Rechte am Las-Cristinas-Konzessionsgebiet, Venezuela (Quelle: Crystallex press release).'),

    ((SELECT id FROM company WHERE name='Crystallex International Corporation'),
     'M&A', '2000-08',
     'Erwerb Tomi-Goldoperationen von Bolivar Goldfields Ltd. (16 km NE von El Callao, Bolívar). Producing asset.'),

    ((SELECT id FROM company WHERE name='Crystallex International Corporation'),
     'M&A', '2002-09-17',
     'Mine Operation Contract (MOC) mit Corporación Venezolana de Guayana (CVG) für Las Cristinas Cristinas 4-7 Konzessionen unterzeichnet.'),

    ((SELECT id FROM company WHERE name='Crystallex International Corporation'),
     'FS', '2003',
     'SNC-Lavalin schliesst Positive Feasibility Study fuer Las Cristinas ab.'),

    ((SELECT id FROM company WHERE name='Crystallex International Corporation'),
     'FS', '2005',
     'Updated Feasibility Study Las Cristinas. Im selben Jahr (Feb 2005) Albino-Konzession durch MIBM terminiert.'),

    ((SELECT id FROM company WHERE name='Crystallex International Corporation'),
     'Permit Granted', '2007-06-14',
     'Crystallex meldet Abschluss des Permitting-Prozesses und Erteilung der Umweltgenehmigung durch das venezolanische Umweltministerium.'),

    ((SELECT id FROM company WHERE name='Crystallex International Corporation'),
     'Resource Estimate', '2007-11-15',
     'NI 43-101 Technical Report (Mine Development Associates): 20.761 Moz M&I + 6.276 Moz Inferred bei 1.03 g/t / 0.85 g/t Au.'),

    ((SELECT id FROM company WHERE name='Crystallex International Corporation'),
     'Permit Denied', '2008-04-14',
     'Venezuelanisches Umweltministerium verweigert die finale Umweltgenehmigung fuer Las Cristinas. Ausloeser des Failure-Pfades; CEO Gordon Thompson tritt am 03.06.2008 zurueck.'),

    ((SELECT id FROM company WHERE name='Crystallex International Corporation'),
     'Expropriation', '2011-02',
     'Venezuela kuendigt einseitig den Las Cristinas Mine Operation Contract. Effektive Enteignung der Konzessionsrechte. Anstoss zum spaeteren ICSID-Verfahren.'),

    ((SELECT id FROM company WHERE name='Crystallex International Corporation'),
     'Insolvency', '2011-12-23',
     'Crystallex erhaelt CCAA-Schutz von Ontario Superior Court; Ernst & Young als Monitor. USD 100 Mio Notes defaulted.'),

    ((SELECT id FROM company WHERE name='Crystallex International Corporation'),
     'Delisting', '2012-01-06',
     'Delisting der Stammaktien von Toronto Stock Exchange (TSX) zum Handelsschluss 06.01.2012.'),

    ((SELECT id FROM company WHERE name='Crystallex International Corporation'),
     'Arbitration Award', '2016-04-04',
     'ICSID Tribunal (Case ARB(AF)/11/2) erkennt Crystallex USD 1.202 Mrd Schadensersatz + Zinsen zu (Gesamtwert ~USD 1.386 Mrd) gegen Venezuela. Erloese gingen an Glaeubiger, nicht an Stamm-Equity.');

-- Verifikation: SELECT name, success_label FROM company WHERE name LIKE 'Cryst%';
