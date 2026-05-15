-- ============================================================================
-- Pipeline-Batch 3 (Variante C2: 5 mittlere-Konfidenz Companies aus Konzeptpapier v0.4)
--   Sample-Validierung mit Korrekturen:
--     Aurcana          → failure (bestätigt)
--     Gold Mountain    → failure (bestätigt)
--     Apollo Gold      → ambivalent (Merger of Equals, kein klares Failure)
--     Avion Gold       → success (M&A 70% Premium, falsch klassifiziert in v0.4)
--     Sulliden Gold    → success (M&A 46.8% Premium, falsch klassifiziert in v0.4)
--   Schema-Voraussetzung: v1.3
--   Audit: docs/260515 Batch-3 Audit.md
-- ============================================================================
-- Konsequenzen für Konzeptpapier v0.5:
--   Negativ-Sample reduziert von 25 auf 23 (Aurcana + Gold Mountain bleiben)
--   Success-Sample erweitert um Avion + Sulliden auf 27
--   Apollo Gold als ambivalente Company markiert
-- ============================================================================

PRAGMA foreign_keys = ON;

-- ============================================================================
-- COMPANY 1: Aurcana Silver Corporation (failure)
-- ============================================================================

INSERT INTO company (name, isin, country, stock_exchange, listing_year, delisting_year,
    primary_commodity, commodity_2, commodity_3, fraud_flag, success_label)
VALUES ('Aurcana Silver Corporation', 'CA0519185064', 'Canada', 'TSX-V',
    2006, 2023, 'Ag', 'Cu', 'Zn', 0, 'failure');

INSERT INTO person (vorname, nachname, country, education,
    production_ramp_up_experience, first_mention_year, first_mention_source, bio_text)
VALUES
    ('Kevin', 'Drover', 'Canada', NULL,
     1, 2019, 'AURCANA-MGT-DROVER',
     'President + Chairman + CEO Aurcana 2019-2023, plus Interim CFO 2022-2023. 40+ Jahre internationale Mining-Erfahrung; vorher Glencairn Gold COO, Kinross VP Operations (6 Mines weltweit), Oracle Mining, Lac Minerals, BP Canada, Noranda, Dome Mines.'),
    ('Brian', 'Briggs', 'Canada', 'Professional Engineer (CO, WY)',
     1, 2019, 'GNW-AURCANA-COO-2019',
     'COO Aurcana 2019-2021 plus CEO Ouray Silver Mines 2018-2021. 30+ Jahre Mining-Industrie (Shell Mining, Rio Tinto, Junior Miner). Underground + Surface Development NA + Africa.'),
    ('Charles', 'Andrew', 'USA',
     'Degree Accounting Midwest College; BS Accounting Regis College',
     0, 2019, 'AURCANA-MGT-ANDREW',
     'CFO Aurcana 2019-2022. Mining Finance Background (Rosemont Copper, Queenstake Resources, PolyMet Mining).'),
    ('Nils', 'von Fersen', 'Canada',
     'PGeo (Professional Geoscientist), Qualified Person',
     0, 2012, 'GNW-AURCANA-DRILL-2013',
     'VP Exploration Aurcana 2012-2013; danach Consulting Geologist bis ~2015. Geological Mapping, Geochemistry, Logging, Mineral Exploration. QP für Technical Disclosures.');

INSERT INTO role (person_id, company_id, role_type, start_date, end_date) VALUES
    ((SELECT id FROM person WHERE vorname='Kevin' AND nachname='Drover'),
     (SELECT id FROM company WHERE name='Aurcana Silver Corporation'),
     'President', '2019', '2023'),
    ((SELECT id FROM person WHERE vorname='Kevin' AND nachname='Drover'),
     (SELECT id FROM company WHERE name='Aurcana Silver Corporation'),
     'Chairman', '2019', '2023'),
    ((SELECT id FROM person WHERE vorname='Kevin' AND nachname='Drover'),
     (SELECT id FROM company WHERE name='Aurcana Silver Corporation'),
     'CEO', '2019', '2023'),
    ((SELECT id FROM person WHERE vorname='Kevin' AND nachname='Drover'),
     (SELECT id FROM company WHERE name='Aurcana Silver Corporation'),
     'CFO', '2022', '2023'),
    ((SELECT id FROM person WHERE vorname='Brian' AND nachname='Briggs'),
     (SELECT id FROM company WHERE name='Aurcana Silver Corporation'),
     'COO', '2019', '2021'),
    ((SELECT id FROM person WHERE vorname='Charles' AND nachname='Andrew'),
     (SELECT id FROM company WHERE name='Aurcana Silver Corporation'),
     'CFO', '2019', '2022'),
    ((SELECT id FROM person WHERE vorname='Nils' AND nachname='von Fersen'),
     (SELECT id FROM company WHERE name='Aurcana Silver Corporation'),
     'VP Exploration', '2012', '2013');

INSERT INTO project (company_id, name, jurisdiction, primary_commodity, commodity_2, commodity_3,
    deposit_type, stage_at_acquisition, peak_stage, parent_project_id)
VALUES
    ((SELECT id FROM company WHERE name='Aurcana Silver Corporation'),
     'La Negra Mine', 'Mexico, Queretaro State',
     'Ag', 'Cu', 'Zn',
     'Polymetallic Skarn (Manto, Chimney Veins, Breccia)',
     'Brownfield', 'Production', NULL),
    ((SELECT id FROM company WHERE name='Aurcana Silver Corporation'),
     'Shafter Silver Project', 'USA, Texas (Presidio County)',
     'Ag', NULL, NULL,
     'Silver-bearing vein / epithermal',
     'Greenfield', 'Production', NULL),
    ((SELECT id FROM company WHERE name='Aurcana Silver Corporation'),
     'Revenue-Virginius Mine', 'USA, Colorado (Ouray)',
     'Ag', 'Au', 'Cu',
     'Polymetallic vein (historic producing)',
     'Brownfield', 'Production', NULL);

-- Outcome Aurcana: Discovery 0.5 (Resource-Erweiterung La Negra Drill 2013),
-- Reserve-Conversion 0.3 (Resource Estimate Shafter 2016, kein FS pre-Production),
-- Exit-Production 0.4 (Restrukturierung mit Fortbestand bis 2023; La Negra-Verlust 2016 +
-- Revenue-Virginius Production Dez 2021), Peak-MarketCap 0.3 (~CAD 150M peak 2012-2014).
-- Total = 0.25*0.5 + 0.25*0.3 + 0.30*0.4 + 0.20*0.3 = 0.125+0.075+0.12+0.06 = 0.38
-- Korrektur ggue. Haiku: PMC 0.3 statt 0.0 (CAD 150M > 50M-Schwelle).
INSERT INTO outcome (company_id, discovery_score, reserve_conversion_score,
    exit_production_score, peak_marketcap_score, total_score, exit_type, exit_year,
    peak_marketcap_cad_million)
VALUES ((SELECT id FROM company WHERE name='Aurcana Silver Corporation'),
    0.5, 0.3, 0.4, 0.3, 0.38, 'Insolvency', 2023, 150.0);

INSERT INTO event (company_id, event_type, event_date, description) VALUES
    ((SELECT id FROM company WHERE name='Aurcana Silver Corporation'),
     'IPO', '2006',
     'Initial TSX Venture Exchange Listing als Aurcana Corporation (AUN). Exaktes Datum nicht verifiziert (Range 2006-2007).'),
    ((SELECT id FROM company WHERE name='Aurcana Silver Corporation'),
     'M&A', '2006',
     'Erwerb La Negra Mine von Penoles (99.9% Ownership, Queretaro Mexico).'),
    ((SELECT id FROM company WHERE name='Aurcana Silver Corporation'),
     'Production Start', '2007-06',
     'La Negra Mine Restart bei 1,000 tpd.'),
    ((SELECT id FROM company WHERE name='Aurcana Silver Corporation'),
     'M&A', '2008-07',
     'Erwerb Shafter Silver Project von Silver Standard.'),
    ((SELECT id FROM company WHERE name='Aurcana Silver Corporation'),
     'Production Start', '2012-12',
     'Shafter Mine Commercial Production Start (Texas); plus La Negra Mill-Expansion auf 2,500 tpd.'),
    ((SELECT id FROM company WHERE name='Aurcana Silver Corporation'),
     'Production Start', '2014',
     'La Negra Peak Production 3.7 Moz Ag-eq.'),
    ((SELECT id FROM company WHERE name='Aurcana Silver Corporation'),
     'Insolvency', '2015-10',
     'Support Agreement mit Orion Mine Finance fuer Debt-Restrukturierung.'),
    ((SELECT id FROM company WHERE name='Aurcana Silver Corporation'),
     'M&A', '2016-01',
     'Completion Restrukturierung: La Negra Mine an Orion Mine Finance transferred; USD 38.7M Schulden eliminiert.'),
    ((SELECT id FROM company WHERE name='Aurcana Silver Corporation'),
     'Resource Estimate', '2016-01',
     'Shafter Updated Resource Estimate: 10.17 Moz Indicated Ag + 6.51 Moz Inferred Ag.'),
    ((SELECT id FROM company WHERE name='Aurcana Silver Corporation'),
     'M&A', '2018-12',
     'Akquisition Ouray Silver Mines (Revenue-Virginius Colorado); Reverse Takeover, CAD 116M+ deemed market cap.'),
    ((SELECT id FROM company WHERE name='Aurcana Silver Corporation'),
     'Production Start', '2021-12',
     'Revenue-Virginius Mine: erste Concentrate-Shipment (Colorado); November 2021 Rock-Movement-Vorfall, Briggs-Resignation kurz danach.'),
    ((SELECT id FROM company WHERE name='Aurcana Silver Corporation'),
     'Insolvency', '2022-03',
     'Default auf USD 28M Mercuria-Loan; Receivership-Petition.'),
    ((SELECT id FROM company WHERE name='Aurcana Silver Corporation'),
     'Delisting', '2023-04',
     'TSX-Venture Trading Suspension (single director governance failure, Going-Concern-Doubt, Continuous-Disclosure-Default).'),
    ((SELECT id FROM company WHERE name='Aurcana Silver Corporation'),
     'Insolvency', '2023-08',
     'Asset-Auktion: Revenue-Virginius Mine fuer USD 1.8M verkauft (Glaeubiger ausstehend USD 60M+).');


-- ============================================================================
-- COMPANY 2: Gold Mountain Mining Corporation (failure)
-- ============================================================================

INSERT INTO company (name, isin, country, stock_exchange, listing_year, delisting_year,
    primary_commodity, commodity_2, commodity_3, fraud_flag, success_label)
VALUES ('Gold Mountain Mining Corporation', 'CA38065L1058', 'Canada', 'TSX-V',
    2020, 2025, 'Au', 'Ag', NULL, 0, 'failure');

INSERT INTO person (vorname, nachname, country, education,
    production_ramp_up_experience, first_mention_year, first_mention_source, bio_text)
VALUES
    ('Kevin', 'Smith', 'Canada', NULL,
     0, 2020, 'GMTN-RSD-INTERVIEW',
     'CEO Gold Mountain Mining Dec 2020 - Jun 2023. Fuehrte Company durch Development, Permitting, Commissioning (Feb 2022 first ore delivery). Investor Communications + Strategic Partnerships (New Gold OPA).'),
    ('Howard', 'Jones', 'Canada', NULL,
     1, 2023, 'JMN-GMTN-JONES',
     'Founding Board Member Gold Mountain; Interim CEO Jun 2023 - Jul 2023. Vorher Comptroller BoNS Europe/ME ops; Head Corpdev Pembina Pipeline. Resignation Jul 2023 wegen Health Reasons.'),
    ('Ronald', 'Woo', 'Canada', NULL,
     0, 2023, 'JMN-GMTN-WOO',
     'CEO Gold Mountain Mining Jul 2023 - Nov 2024. Resignation Nov 2024.'),
    ('Bruce', 'Sifton', 'Canada', NULL,
     0, 2024, 'JMN-GMTN-SIFTON',
     'Director; Interim CEO Nov 2024 - Jul 2025 (Receivership). Tenure beendet durch Receivership-Order.'),
    ('Wylie', 'Hui', 'Canada', NULL,
     1, 2024, 'JMN-GMTN-HUI',
     'CFO + Chairman Gold Mountain Nov 2024 - Jul 2025. 25+ Jahre Mining-Finance/Ops. Vorher CFO Eastern Platinum, Tintina (Black Butte Cu), BQE Water, Sombrero Resources, Tier One Silver, Fury Gold, Torq Resources.');

INSERT INTO role (person_id, company_id, role_type, start_date, end_date) VALUES
    ((SELECT id FROM person WHERE vorname='Kevin' AND nachname='Smith'),
     (SELECT id FROM company WHERE name='Gold Mountain Mining Corporation'),
     'CEO', '2020-12-23', '2023-06-26'),
    ((SELECT id FROM person WHERE vorname='Howard' AND nachname='Jones'),
     (SELECT id FROM company WHERE name='Gold Mountain Mining Corporation'),
     'CEO', '2023-06-26', '2023-07-31'),
    ((SELECT id FROM person WHERE vorname='Ronald' AND nachname='Woo'),
     (SELECT id FROM company WHERE name='Gold Mountain Mining Corporation'),
     'CEO', '2023-07-31', '2024-11'),
    ((SELECT id FROM person WHERE vorname='Bruce' AND nachname='Sifton'),
     (SELECT id FROM company WHERE name='Gold Mountain Mining Corporation'),
     'CEO', '2024-11', '2025-07-31'),
    ((SELECT id FROM person WHERE vorname='Wylie' AND nachname='Hui'),
     (SELECT id FROM company WHERE name='Gold Mountain Mining Corporation'),
     'CFO', '2024-11', '2025-07-31'),
    ((SELECT id FROM person WHERE vorname='Wylie' AND nachname='Hui'),
     (SELECT id FROM company WHERE name='Gold Mountain Mining Corporation'),
     'Chairman', '2024-11', '2025-07-31');

INSERT INTO project (company_id, name, jurisdiction, primary_commodity, commodity_2, commodity_3,
    deposit_type, stage_at_acquisition, peak_stage, parent_project_id)
VALUES
    ((SELECT id FROM company WHERE name='Gold Mountain Mining Corporation'),
     'Elk Gold Project', 'Canada, BC (Merritt, Osprey Lake Batholith)',
     'Au', 'Ag', NULL,
     'Mesothermal, intrusive-related gold vein system',
     'Brownfield', 'Production', NULL);

-- Outcome Gold Mountain: Discovery 0.5 (Resource-Erweiterung +519 koz 2021, neue Elusive-Zone),
-- Reserve-Conversion 0.3 (PEA 2020+ updates, kein FS), Exit-Production 0.0 (Receivership,
-- Mine in Care&Maintenance, Equity-Total-Verlust), Peak-MarketCap 0.3 (~CAD 75M peak 2021).
-- Total = 0.25*0.5 + 0.25*0.3 + 0.30*0.0 + 0.20*0.3 = 0.125+0.075+0+0.06 = 0.26
INSERT INTO outcome (company_id, discovery_score, reserve_conversion_score,
    exit_production_score, peak_marketcap_score, total_score, exit_type, exit_year,
    peak_marketcap_cad_million)
VALUES ((SELECT id FROM company WHERE name='Gold Mountain Mining Corporation'),
    0.5, 0.3, 0.0, 0.3, 0.26, 'Insolvency', 2025, 75.0);

INSERT INTO event (company_id, event_type, event_date, description) VALUES
    ((SELECT id FROM company WHERE name='Gold Mountain Mining Corporation'),
     'M&A', '2020-12-23',
     'Reverse Takeover: Freeform Capital Partners + Bayshore Minerals → renamed Gold Mountain Mining (GMTN).'),
    ((SELECT id FROM company WHERE name='Gold Mountain Mining Corporation'),
     'IPO', '2021-03-02',
     'TSX-V Listing als Gold Mountain Mining Corporation (post-RTO).'),
    ((SELECT id FROM company WHERE name='Gold Mountain Mining Corporation'),
     'M&A', '2021-01-26',
     '3-year Ore Purchase Agreement mit New Gold Inc.: 70,000 tpa Elk Ore zu New Afton Mill (Kamloops).'),
    ((SELECT id FROM company WHERE name='Gold Mountain Mining Corporation'),
     'Permit Granted', '2021-06',
     'BC Ministry issues Draft Mining Permit (Mines Act); erster Gold-Mining-Permit BC seit ~10 Jahren.'),
    ((SELECT id FROM company WHERE name='Gold Mountain Mining Corporation'),
     'Discovery', '2021-09',
     'Neue High-Grade Au-Zone Elusive Zone (5km SW Siwash-North-Resource); Scale comparable to Siwash North.'),
    ((SELECT id FROM company WHERE name='Gold Mountain Mining Corporation'),
     'Resource Estimate', '2021-10-21',
     'NI 43-101 Resource Update: 806 koz M&I @ 5.8 g/t Au-eq + 262 koz Inferred @ 5.4 g/t (24% M&I Increase YoY).'),
    ((SELECT id FROM company WHERE name='Gold Mountain Mining Corporation'),
     'Production Start', '2022-02-03',
     'Erste Ore-Shipment zu New Afton Mill; Transition zu Revenue Generation.'),
    ((SELECT id FROM company WHERE name='Gold Mountain Mining Corporation'),
     'Insolvency', '2025-07-31',
     'BC Supreme Court appoints MNP Ltd. als Receiver; Default auf CAD 11.1M Obligations (Nhwelmen CAD 4.8M + Convertible Debenture CAD 6.3M).'),
    ((SELECT id FROM company WHERE name='Gold Mountain Mining Corporation'),
     'Delisting', '2025-09-12',
     'TSX delisted Gold Mountain Mining securities.');


-- ============================================================================
-- COMPANY 3: Apollo Gold Corporation (ambivalent)
-- ============================================================================

INSERT INTO company (name, isin, country, stock_exchange, listing_year, delisting_year,
    primary_commodity, commodity_2, commodity_3, fraud_flag, success_label)
VALUES ('Apollo Gold Corporation', NULL, 'Canada', 'TSX → NYSE-Amex',
    2002, 2010, 'Au', NULL, NULL, 0, 'ambivalent');

INSERT INTO person (vorname, nachname, country, education,
    production_ramp_up_experience, first_mention_year, first_mention_source, bio_text)
VALUES
    ('R. David', 'Russell', 'USA', 'Mining Engineer Montana Tech',
     1, 2000, 'WALLMINE-RUSSELL',
     'Founder Apollo Gold 2002 (via Nevoro Gold 1999-2002 + International Pursuit Merger). 30+ Jahre Mining-Erfahrung. Vorher VP/COO Getchell Gold (akq. Placer Dome 1999 USD 1.1B), VP US Operations LAC Minerals/Barrick. Resignation Juni 2010 bei Linear-Merger.'),
    ('Wade', 'Dawe', 'Canada', NULL,
     1, 2003, 'TWST-DAWE',
     'Founder Linear Resources 2000 → Linear Gold CEO 2003-2010 (CAD 75M+ raised). Nach Apollo-Linear-Merger Jun 2010 CEO Brigus Gold 2010-2014. Negotiierte Brigus-Verkauf an Primero USD 351M.');

INSERT INTO role (person_id, company_id, role_type, start_date, end_date) VALUES
    ((SELECT id FROM person WHERE vorname='R. David' AND nachname='Russell'),
     (SELECT id FROM company WHERE name='Apollo Gold Corporation'),
     'Founder', '2002', NULL),
    ((SELECT id FROM person WHERE vorname='R. David' AND nachname='Russell'),
     (SELECT id FROM company WHERE name='Apollo Gold Corporation'),
     'CEO', '2002', '2010-06'),
    ((SELECT id FROM person WHERE vorname='R. David' AND nachname='Russell'),
     (SELECT id FROM company WHERE name='Apollo Gold Corporation'),
     'President', '2002', '2010-06'),
    ((SELECT id FROM person WHERE vorname='Wade' AND nachname='Dawe'),
     (SELECT id FROM company WHERE name='Apollo Gold Corporation'),
     'CEO', '2010-06', '2010-06');

INSERT INTO project (company_id, name, jurisdiction, primary_commodity, commodity_2, commodity_3,
    deposit_type, stage_at_acquisition, peak_stage, parent_project_id)
VALUES
    ((SELECT id FROM company WHERE name='Apollo Gold Corporation'),
     'Black Fox Complex', 'Canada, Ontario (Timmins)',
     'Au', NULL, NULL,
     'Archean greenstone-hosted gold',
     'Brownfield', 'Production', NULL),
    ((SELECT id FROM company WHERE name='Apollo Gold Corporation'),
     'Florida Canyon + Montana Tunnels', 'USA, Nevada + Montana',
     'Au', NULL, NULL,
     'Heap-Leach Operations (Pegasus-Legacy)',
     'Brownfield', 'Production', NULL);

-- Outcome Apollo Gold: Discovery 0.0 (keine eigene Discovery; Pegasus-Legacy + Black-Fox-
-- Brownfield-Akquisition), Reserve-Conversion 0.6 (Black Fox FS bis 2009), Exit-Production 0.4
-- (Merger of Equals mit Linear; Apollo-CEO Russell resigniert; Vehikel besteht als Brigus fort),
-- Peak-MarketCap 0.3 (Standalone schaetz CAD 100-200M peak 2007-2009).
-- Total = 0.25*0.0 + 0.25*0.6 + 0.30*0.4 + 0.20*0.3 = 0+0.15+0.12+0.06 = 0.33
INSERT INTO outcome (company_id, discovery_score, reserve_conversion_score,
    exit_production_score, peak_marketcap_score, total_score, exit_type, exit_year,
    peak_marketcap_cad_million)
VALUES ((SELECT id FROM company WHERE name='Apollo Gold Corporation'),
    0.0, 0.6, 0.4, 0.3, 0.33, 'M&A', 2010, 150.0);

INSERT INTO event (company_id, event_type, event_date, description) VALUES
    ((SELECT id FROM company WHERE name='Apollo Gold Corporation'),
     'IPO', '2002',
     'Nevoro Gold (gegruendet 1999) + International Pursuit Merger 2002 → Apollo Gold Corp. (TSX:APG, NYSE-Amex:AGT). Uebernahm Pegasus-Gold-Legacy-Assets (Florida Canyon, Montana Tunnels, Diamond Hill).'),
    ((SELECT id FROM company WHERE name='Apollo Gold Corporation'),
     'Production Start', '2009-05',
     'Black Fox Open Pit Mine + Mill commences Production (Apollo-Ownership).'),
    ((SELECT id FROM company WHERE name='Apollo Gold Corporation'),
     'M&A', '2010-04-01',
     'Apollo Gold + Linear Gold Definitive Arrangement Agreement signed.'),
    ((SELECT id FROM company WHERE name='Apollo Gold Corporation'),
     'M&A', '2010-06-25',
     'Merger completion: Apollo+Linear → Brigus Gold Corp. Linear-CEO Wade Dawe → CEO Brigus; Apollo-CEO Russell resigniert. Stock-for-stock, no premium (Merger of Equals).'),
    ((SELECT id FROM company WHERE name='Apollo Gold Corporation'),
     'Delisting', '2010-06-25',
     'Apollo Gold (APG/AGT) delisted; ersetzt durch Brigus Gold (BRD/PPP).'),
    ((SELECT id FROM company WHERE name='Apollo Gold Corporation'),
     'M&A', '2014-03-05',
     'Brigus Gold (Nachfolger) an Primero Mining fuer CAD 220M (all-stock); Black Fox produzierte 2013 98.7k oz.');


-- ============================================================================
-- COMPANY 4: Avion Gold Corporation (success — Reklassifikation aus v0.4)
-- ============================================================================

INSERT INTO company (name, isin, country, stock_exchange, listing_year, delisting_year,
    primary_commodity, commodity_2, commodity_3, fraud_flag, success_label)
VALUES ('Avion Gold Corporation', NULL, 'Canada', 'TSX',
    2005, 2012, 'Au', NULL, NULL, 0, 'success');

INSERT INTO person (vorname, nachname, country, education,
    production_ramp_up_experience, first_mention_year, first_mention_source, bio_text)
VALUES
    ('John', 'Begeman', NULL, 'Professional Mining Engineer',
     1, 2008, 'ENDV-AVR-2012-CLOSE',
     'CEO + President Avion Gold 2008-2012. 30+ Jahre Mining-Erfahrung; vorher Zinifex/Wolfden. Fuehrte Tabakoto/Segala-Operations-Turnaround von distressed Nevsun-Asset zu profitable Production. Post-Akquisition Director Endeavour Mining 2012+.'),
    ('James', 'Coleman', 'Canada', 'Q.C. (Queens Counsel)',
     0, 2010, 'ENDV-AVR-2012-CLOSE',
     'Independent Chairman Avion Gold ~2010-2012. Legal Expertise + Corporate Governance. Board Member multiple Mining Companies. Post-Akquisition Director Endeavour Mining 2012+.');

INSERT INTO role (person_id, company_id, role_type, start_date, end_date) VALUES
    ((SELECT id FROM person WHERE vorname='John' AND nachname='Begeman'),
     (SELECT id FROM company WHERE name='Avion Gold Corporation'),
     'CEO', '2008', '2012-10-18'),
    ((SELECT id FROM person WHERE vorname='John' AND nachname='Begeman'),
     (SELECT id FROM company WHERE name='Avion Gold Corporation'),
     'President', '2008', '2012-10-18'),
    ((SELECT id FROM person WHERE vorname='James' AND nachname='Coleman'),
     (SELECT id FROM company WHERE name='Avion Gold Corporation'),
     'Chairman', '2010', '2012-10-18');

INSERT INTO project (company_id, name, jurisdiction, primary_commodity, commodity_2, commodity_3,
    deposit_type, stage_at_acquisition, peak_stage, parent_project_id)
VALUES
    ((SELECT id FROM company WHERE name='Avion Gold Corporation'),
     'Tabakoto + Segala', 'Mali, West Africa (Kayes Region)',
     'Au', NULL, NULL,
     'Underground (Tabakoto main pit + Segala underground)',
     'Brownfield', 'Production', NULL),
    ((SELECT id FROM company WHERE name='Avion Gold Corporation'),
     'Hounde + Kofi + Kenieba', 'Burkina Faso + Mali',
     'Au', NULL, NULL,
     'Exploration-Properties (1,600 km^2 Hounde)',
     'Greenfield', 'Discovery', NULL);

-- Outcome Avion: Discovery 1.0 (Resource-Expansion 1.0 Moz → 3.3 Moz innerhalb 2 Jahren;
-- Hounde High-Grade-Intercepts), Reserve-Conversion 1.0 (Tabakoto FS + Production 2009-2012),
-- Exit-Production 1.0 (M&A Endeavour Mining CAD 389M, 70% Premium auf 20-Tage-VWAP), Peak-
-- MarketCap 0.6 (CAD 389M Akquisitions-Wert).
-- Total = 0.25*1.0 + 0.25*1.0 + 0.30*1.0 + 0.20*0.6 = 0.25+0.25+0.30+0.12 = 0.92
INSERT INTO outcome (company_id, discovery_score, reserve_conversion_score,
    exit_production_score, peak_marketcap_score, total_score, exit_type, exit_year,
    peak_marketcap_cad_million)
VALUES ((SELECT id FROM company WHERE name='Avion Gold Corporation'),
    1.0, 1.0, 1.0, 0.6, 0.92, 'M&A', 2012, 389.0);

INSERT INTO event (company_id, event_type, event_date, description) VALUES
    ((SELECT id FROM company WHERE name='Avion Gold Corporation'),
     'M&A', '2008-05',
     'Avion erwirbt 80% Tabakoto/Segala Mali (Distressed-Asset von Nevsun, vorher Stop 2007); Government Mali behaelt 20%.'),
    ((SELECT id FROM company WHERE name='Avion Gold Corporation'),
     'Discovery', '2009',
     'Resource-Expansion Tabakoto: 1.0 Moz → 2.6 Moz innerhalb 12 Monaten.'),
    ((SELECT id FROM company WHERE name='Avion Gold Corporation'),
     'Production Start', '2009-03',
     'First Gold Pour bei restartetem Tabakoto Mine; 51,290 oz Au 2009 produziert.'),
    ((SELECT id FROM company WHERE name='Avion Gold Corporation'),
     'Resource Estimate', '2010',
     'Resource Update: 3.3 Moz Au (incl. Hounde/Kofi-Akquisitionen).'),
    ((SELECT id FROM company WHERE name='Avion Gold Corporation'),
     'Production Start', '2010-2011',
     'Tabakoto Production: 87,630 oz (2010), 91,238 oz (2011).'),
    ((SELECT id FROM company WHERE name='Avion Gold Corporation'),
     'M&A', '2012-08-07',
     'Endeavour Mining Announcement: Akquisition Avion Gold fuer CAD 389M (All-Stock, 0.365 EDV-share/AVR-share); 70% Premium auf 20-Tage-VWAP, 56.4% Premium auf Schlusskurs.'),
    ((SELECT id FROM company WHERE name='Avion Gold Corporation'),
     'M&A', '2012-10-18',
     'Endeavour Mining schliesst Akquisition Avion ab; Begeman + Coleman join Endeavour Board.'),
    ((SELECT id FROM company WHERE name='Avion Gold Corporation'),
     'Delisting', '2012-10-18',
     'Avion Gold (AVR) delisted TSX nach Endeavour-Closing.'),
    ((SELECT id FROM company WHERE name='Avion Gold Corporation'),
     'Production Start', '2013-05',
     'Tabakoto Mill-Expansion 2,000 tpd → 4,000 tpd (post-Akquisition unter Endeavour); 125,231 oz Au 2013 produziert.');


-- ============================================================================
-- COMPANY 5: Sulliden Gold Corporation (success — Reklassifikation aus v0.4)
-- ============================================================================

INSERT INTO company (name, isin, country, stock_exchange, listing_year, delisting_year,
    primary_commodity, commodity_2, commodity_3, fraud_flag, success_label)
VALUES ('Sulliden Gold Corporation', NULL, 'Canada', 'TSX',
    2008, 2014, 'Au', 'Ag', NULL, 0, 'success');

INSERT INTO person (vorname, nachname, country, education,
    production_ramp_up_experience, first_mention_year, first_mention_source, bio_text)
VALUES
    ('Peter', 'Tagliamonte', 'Canada', NULL,
     1, 2013, 'MS-TAGLIAMONTE',
     'CEO + Chairman Sulliden Gold 2013-2014. Mining Executive; fuehrte Sulliden durch Shahuindo-Development (EIA-Approval Sept 2013) und M&A-Verhandlungen mit Rio Alto Mining.'),
    ('Justin', 'Reid', 'Canada', NULL,
     0, 2013, 'MS-TAGLIAMONTE',
     'President Sulliden Gold 2013-2014.');

INSERT INTO role (person_id, company_id, role_type, start_date, end_date) VALUES
    ((SELECT id FROM person WHERE vorname='Peter' AND nachname='Tagliamonte'),
     (SELECT id FROM company WHERE name='Sulliden Gold Corporation'),
     'CEO', '2013', '2014-08-05'),
    ((SELECT id FROM person WHERE vorname='Peter' AND nachname='Tagliamonte'),
     (SELECT id FROM company WHERE name='Sulliden Gold Corporation'),
     'Chairman', '2013', '2014-08-05'),
    ((SELECT id FROM person WHERE vorname='Justin' AND nachname='Reid'),
     (SELECT id FROM company WHERE name='Sulliden Gold Corporation'),
     'President', '2013', '2014-08-05');

INSERT INTO project (company_id, name, jurisdiction, primary_commodity, commodity_2, commodity_3,
    deposit_type, stage_at_acquisition, peak_stage, parent_project_id)
VALUES
    ((SELECT id FROM company WHERE name='Sulliden Gold Corporation'),
     'Shahuindo', 'Peru, Cajamarca Region (Cajabamba)',
     'Au', 'Ag', NULL,
     'Open Pit Heap Leach (Oxide); Sulfide Phase 2 (Underground potential)',
     'Greenfield', 'FS', NULL);

-- Outcome Sulliden: Discovery 0.5 (eigene Resource-Definition Shahuindo via NI 43-101 +
-- Konzeptpapier-Konsistenz fuer team-led discoveries), Reserve-Conversion 1.0 (FS 2012 +
-- EIA-Approval Sept 2013), Exit-Production 1.0 (M&A Rio Alto USD 377M / CAD 300M, 46.8%
-- Premium auf 20-Tage-VWAP), Peak-MarketCap 0.6 (~CAD 350M peak 2013-2014, M&A-Wert CAD 300M).
-- Total = 0.25*0.5 + 0.25*1.0 + 0.30*1.0 + 0.20*0.6 = 0.125+0.25+0.30+0.12 = 0.795
INSERT INTO outcome (company_id, discovery_score, reserve_conversion_score,
    exit_production_score, peak_marketcap_score, total_score, exit_type, exit_year,
    peak_marketcap_cad_million)
VALUES ((SELECT id FROM company WHERE name='Sulliden Gold Corporation'),
    0.5, 1.0, 1.0, 0.6, 0.795, 'M&A', 2014, 350.0);

INSERT INTO event (company_id, event_type, event_date, description) VALUES
    ((SELECT id FROM company WHERE name='Sulliden Gold Corporation'),
     'IPO', '2008',
     'TSX-Listing Sulliden Gold Corp; Fokus auf Shahuindo-Au-Ag-Projekt Cajamarca Peru.'),
    ((SELECT id FROM company WHERE name='Sulliden Gold Corporation'),
     'FS', '2012',
     'Feasibility Study Shahuindo abgeschlossen.'),
    ((SELECT id FROM company WHERE name='Sulliden Gold Corporation'),
     'Industry Award', '2013-04',
     'Strategic Cornerstone Investment: Agnico-Eagle Mines investiert USD 24M (9.96% Stake @ CAD 0.89/share).'),
    ((SELECT id FROM company WHERE name='Sulliden Gold Corporation'),
     'Permit Granted', '2013-09',
     'Peruvian Ministry of Energy and Mines genehmigt Environmental Impact Assessment fuer Shahuindo.'),
    ((SELECT id FROM company WHERE name='Sulliden Gold Corporation'),
     'M&A', '2014-05-21',
     'Rio Alto Mining Announcement: Friendly Akquisition Sulliden fuer CAD 300M (USD 377M); 0.525 Rio-Alto-shares pro Sulliden-share; 46.8% Premium auf 20-Tage-VWAP.'),
    ((SELECT id FROM company WHERE name='Sulliden Gold Corporation'),
     'M&A', '2014-05-29',
     'Agnico-Eagle exits 8.6% Stake (26.97M shares) zu Rio Alto bei CAD 1.10/share.'),
    ((SELECT id FROM company WHERE name='Sulliden Gold Corporation'),
     'M&A', '2014-08-05',
     'Rio Alto Mining schliesst Sulliden-Akquisition ab (Court-Approved Arrangement).'),
    ((SELECT id FROM company WHERE name='Sulliden Gold Corporation'),
     'Delisting', '2014-08-05',
     'Sulliden Gold delisted TSX nach Rio-Alto-Closing.'),
    ((SELECT id FROM company WHERE name='Sulliden Gold Corporation'),
     'Production Start', '2015-11',
     'Shahuindo Commissioning startet unter Tahoe Resources (Rio Alto wurde April 2015 von Tahoe akquiriert).'),
    ((SELECT id FROM company WHERE name='Sulliden Gold Corporation'),
     'Production Start', '2015-12',
     'Erste Dorebars Shahuindo (December 2015).'),
    ((SELECT id FROM company WHERE name='Sulliden Gold Corporation'),
     'M&A', '2019-02-22',
     'Pan American Silver schliesst Tahoe-Akquisition ab (USD 1.1B); Shahuindo unter Pan-Am-Ownership 2019-heute, Production 2025 ~132 koz Au.');
