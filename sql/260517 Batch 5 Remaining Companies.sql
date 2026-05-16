-- Batch 5: Remaining 4 Companies (Pretium already exists)
-- Only insert: Detour, Sabina, Great Bear, Osisko
-- Schema Version: v1.3
-- Date: 2026-05-17

PRAGMA foreign_keys = ON;

-- ============================================================
-- COMPANY 2: DETOUR GOLD CORP.
-- ============================================================

INSERT INTO company (name, isin, country, stock_exchange, listing_year, delisting_year, primary_commodity, fraud_flag, success_label)
VALUES ('Detour Gold Corp.', NULL, 'Canada', 'TSX', 2007, 2020, 'Au', 0, 'success');

-- Detour Gold Persons
INSERT INTO person (vorname, nachname, education, country, production_ramp_up_experience, first_mention_year, bio_text)
VALUES ('Gerald', 'Panneton', NULL, 'Canada', 1, 2006, 'Founder of Detour Gold, visionary in development of Detour Lake deposit');

INSERT INTO person (vorname, nachname, education, country, production_ramp_up_experience, first_mention_year, bio_text)
VALUES ('Mick', 'McMullen', NULL, 'Canada', 1, 2019, 'CEO Detour Gold (2019-2020), led company through acquisition by Kirkland Lake Gold');

INSERT INTO person (vorname, nachname, education, country, production_ramp_up_experience, first_mention_year, bio_text)
VALUES ('Jaco', 'Crouse', NULL, 'Canada', 1, 2019, 'CFO Detour Gold (2019-2020), financial management during M&A process');

-- Detour Gold Roles
INSERT INTO role (person_id, company_id, role_type, start_date, end_date)
SELECT (SELECT id FROM person WHERE vorname='Mick' AND nachname='McMullen' LIMIT 1),
       (SELECT id FROM company WHERE name='Detour Gold Corp.' LIMIT 1),
       'CEO', '2019-05-15', '2020-01-31';

INSERT INTO role (person_id, company_id, role_type, start_date, end_date)
SELECT (SELECT id FROM person WHERE vorname='Jaco' AND nachname='Crouse' LIMIT 1),
       (SELECT id FROM company WHERE name='Detour Gold Corp.' LIMIT 1),
       'CFO', '2019-05-15', '2020-01-31';

-- Detour Gold Project
INSERT INTO project (company_id, name, jurisdiction, primary_commodity, stage_at_acquisition, peak_stage)
SELECT (SELECT id FROM company WHERE name='Detour Gold Corp.' LIMIT 1),
       'Detour Lake', 'Ontario, Canada', 'Au', 'Production', 'Production';

-- Detour Gold Outcome
INSERT INTO outcome (company_id, discovery_score, reserve_conversion_score, exit_production_score, peak_marketcap_score, total_score, exit_type, exit_year, peak_marketcap_cad_million)
SELECT (SELECT id FROM company WHERE name='Detour Gold Corp.' LIMIT 1),
       80, 90, 100, 100, 92.5, 'M&A', 2020, 4900;

-- Detour Gold Events
INSERT INTO event (company_id, event_type, event_date, description)
SELECT (SELECT id FROM company WHERE name='Detour Gold Corp.' LIMIT 1),
       'PFS', '2010-06-30', 'Preliminary Feasibility Study filed on Detour Lake';

INSERT INTO event (company_id, event_type, event_date, description)
SELECT (SELECT id FROM company WHERE name='Detour Gold Corp.' LIMIT 1),
       'FS', '2013-01-15', 'Feasibility Study completed for Detour Lake project';

INSERT INTO event (company_id, event_type, event_date, description)
SELECT (SELECT id FROM company WHERE name='Detour Gold Corp.' LIMIT 1),
       'Production Start', '2013-08-07', 'Detour Lake Mine achieves commercial production (811 oz Au/day)';

INSERT INTO event (company_id, event_type, event_date, description)
SELECT (SELECT id FROM company WHERE name='Detour Gold Corp.' LIMIT 1),
       'M&A', '2020-01-31', 'Kirkland Lake Gold completes acquisition of Detour Gold for CAD 4.9B (29% VWAP premium)';

-- ============================================================
-- COMPANY 3: SABINA GOLD & SILVER CORP.
-- ============================================================

INSERT INTO company (name, isin, country, stock_exchange, listing_year, delisting_year, primary_commodity, fraud_flag, success_label)
VALUES ('Sabina Gold & Silver Corp.', NULL, 'Canada', 'TSX', 1966, 2023, 'Au', 0, 'success');

-- Sabina Gold & Silver Persons
INSERT INTO person (vorname, nachname, education, country, production_ramp_up_experience, first_mention_year, bio_text)
VALUES ('Bruce', 'McLeod', NULL, 'Canada', 1, 2015, 'CEO Sabina Gold & Silver (2015-2023), 30+ years mining experience, led Back River development and B2Gold acquisition');

-- Sabina Gold & Silver Roles
INSERT INTO role (person_id, company_id, role_type, start_date, end_date)
SELECT (SELECT id FROM person WHERE vorname='Bruce' AND nachname='McLeod' LIMIT 1),
       (SELECT id FROM company WHERE name='Sabina Gold & Silver Corp.' LIMIT 1),
       'CEO', '2015-01-01', '2023-04-19';

-- Sabina Gold & Silver Project
INSERT INTO project (company_id, name, jurisdiction, primary_commodity, stage_at_acquisition, peak_stage)
SELECT (SELECT id FROM company WHERE name='Sabina Gold & Silver Corp.' LIMIT 1),
       'Back River (Goose Mine)', 'Nunavut, Canada', 'Au', 'Construction', 'Construction';

-- Sabina Gold & Silver Outcome
INSERT INTO outcome (company_id, discovery_score, reserve_conversion_score, exit_production_score, peak_marketcap_score, total_score, exit_type, exit_year, peak_marketcap_cad_million)
SELECT (SELECT id FROM company WHERE name='Sabina Gold & Silver Corp.' LIMIT 1),
       75, 85, 90, 80, 83, 'M&A', 2023, 1200;

-- Sabina Gold & Silver Events
INSERT INTO event (company_id, event_type, event_date, description)
SELECT (SELECT id FROM company WHERE name='Sabina Gold & Silver Corp.' LIMIT 1),
       'PFS', '2013-06-15', 'Preliminary Feasibility Study on Back River Gold Project');

INSERT INTO event (company_id, event_type, event_date, description)
SELECT (SELECT id FROM company WHERE name='Sabina Gold & Silver Corp.' LIMIT 1),
       'FS', '2015-05-20', 'Feasibility Study on Back River Gold Project completed and positive');

INSERT INTO event (company_id, event_type, event_date, description)
SELECT (SELECT id FROM company WHERE name='Sabina Gold & Silver Corp.' LIMIT 1),
       'FS Update', '2021-03-05', 'Updated Feasibility Study for Goose Project filed (NI 43-101)');

INSERT INTO event (company_id, event_type, event_date, description)
SELECT (SELECT id FROM company WHERE name='Sabina Gold & Silver Corp.' LIMIT 1),
       'Construction Decision', '2022-09-07', 'Formal construction decision for Goose Gold Mine announced');

INSERT INTO event (company_id, event_type, event_date, description)
SELECT (SELECT id FROM company WHERE name='Sabina Gold & Silver Corp.' LIMIT 1),
       'M&A', '2023-04-19', 'B2Gold Corp. completes acquisition of Sabina Gold & Silver for CAD 1.2B (45% shareholder premium)';

-- ============================================================
-- COMPANY 4: GREAT BEAR RESOURCES LTD.
-- ============================================================

INSERT INTO company (name, isin, country, stock_exchange, listing_year, delisting_year, primary_commodity, fraud_flag, success_label)
VALUES ('Great Bear Resources Ltd.', NULL, 'Canada', 'TSX-V', 2010, 2022, 'Au', 0, 'success');

-- Great Bear Resources Persons
INSERT INTO person (vorname, nachname, education, country, production_ramp_up_experience, first_mention_year, bio_text)
VALUES ('Chris', 'Taylor', 'M.Sc., P.Geo', 'Canada', 1, 2010, 'Founder, President & CEO Great Bear Resources (2010-2022), Mining Person of the Year 2021, structural/economic geologist with 20+ years mining experience');

INSERT INTO person (vorname, nachname, education, country, production_ramp_up_experience, first_mention_year, bio_text)
VALUES ('Bob', 'Singh', 'P.Sc., P.Geo', 'Canada', 1, 2010, 'VP Exploration Great Bear Resources (2010+), economic geologist with 25+ years exploration experience, UBC graduate');

INSERT INTO person (vorname, nachname, education, country, production_ramp_up_experience, first_mention_year, bio_text)
VALUES ('Calum', 'Morrison', NULL, 'Canada', 1, 2019, 'VP Business Development / CFO Great Bear Resources (~2019-2022), 15+ years mining finance, ex-Teck Corp development');

-- Great Bear Resources Roles
INSERT INTO role (person_id, company_id, role_type, start_date, end_date)
SELECT (SELECT id FROM person WHERE vorname='Chris' AND nachname='Taylor' LIMIT 1),
       (SELECT id FROM company WHERE name='Great Bear Resources Ltd.' LIMIT 1),
       'CEO', '2010-01-01', '2022-02-24';

INSERT INTO role (person_id, company_id, role_type, start_date, end_date)
SELECT (SELECT id FROM person WHERE vorname='Bob' AND nachname='Singh' LIMIT 1),
       (SELECT id FROM company WHERE name='Great Bear Resources Ltd.' LIMIT 1),
       'VP Exploration', '2010-01-01', '2022-02-24';

INSERT INTO role (person_id, company_id, role_type, start_date, end_date)
SELECT (SELECT id FROM person WHERE vorname='Calum' AND nachname='Morrison' LIMIT 1),
       (SELECT id FROM company WHERE name='Great Bear Resources Ltd.' LIMIT 1),
       'CFO', '2019-01-01', '2022-02-24';

-- Great Bear Resources Project
INSERT INTO project (company_id, name, jurisdiction, primary_commodity, stage_at_acquisition, peak_stage)
SELECT (SELECT id FROM company WHERE name='Great Bear Resources Ltd.' LIMIT 1),
       'Dixie Project', 'Red Lake District, Ontario, Canada', 'Au', 'Discovery', 'FS';

-- Great Bear Resources Outcome
INSERT INTO outcome (company_id, discovery_score, reserve_conversion_score, exit_production_score, peak_marketcap_score, total_score, exit_type, exit_year, peak_marketcap_cad_million)
SELECT (SELECT id FROM company WHERE name='Great Bear Resources Ltd.' LIMIT 1),
       90, 85, 75, 85, 83.25, 'M&A', 2022, 1800;

-- Great Bear Resources Events
INSERT INTO event (company_id, event_type, event_date, description)
SELECT (SELECT id FROM company WHERE name='Great Bear Resources Ltd.' LIMIT 1),
       'Discovery', '2019-01-01', 'Dixie Project discovery at Red Lake District (major gold discovery by Great Bear Resources)');

INSERT INTO event (company_id, event_type, event_date, description)
SELECT (SELECT id FROM company WHERE name='Great Bear Resources Ltd.' LIMIT 1),
       'Resource Estimate', '2023-02-12', 'Initial Mineral Resource Estimate for Great Bear Gold Project (post-acquisition by Kinross)');

INSERT INTO event (company_id, event_type, event_date, description)
SELECT (SELECT id FROM company WHERE name='Great Bear Resources Ltd.' LIMIT 1),
       'PEA', '2024-09-01', 'Preliminary Economic Assessment for Great Bear Gold Project filed');

INSERT INTO event (company_id, event_type, event_date, description)
SELECT (SELECT id FROM company WHERE name='Great Bear Resources Ltd.' LIMIT 1),
       'M&A', '2022-02-24', 'Kinross Gold Corporation completes acquisition of Great Bear Resources for CAD 1.8B (30% premium)';

-- ============================================================
-- COMPANY 5: OSISKO MINING INC.
-- ============================================================

INSERT INTO company (name, isin, country, stock_exchange, listing_year, delisting_year, primary_commodity, fraud_flag, success_label)
VALUES ('Osisko Mining Inc.', NULL, 'Canada', 'TSX', 2006, 2024, 'Au', 0, 'success');

-- Osisko Mining Persons
INSERT INTO person (vorname, nachname, education, country, production_ramp_up_experience, first_mention_year, bio_text)
VALUES ('Sean', 'Roosen', NULL, 'Canada', 1, 2003, 'Founder of Osisko Mining (2003), pioneer in Canadian gold discovery and development, Mining Person of the Year 2009');

INSERT INTO person (vorname, nachname, education, country, production_ramp_up_experience, first_mention_year, bio_text)
VALUES ('John', 'Burzynski', NULL, 'Canada', 1, 2003, 'Co-Founder & Executive Chairman Osisko Mining (2003-2024), VP Corporate Development background, Mining Person of the Year 2009');

INSERT INTO person (vorname, nachname, education, country, production_ramp_up_experience, first_mention_year, bio_text)
VALUES ('Robert', 'Wares', NULL, 'Canada', 1, 2015, 'CEO Osisko Mining (2015-2024), led company through Windfall development, ex-EVP & COO, Mining Person of the Year 2009');

-- Osisko Mining Roles
INSERT INTO role (person_id, company_id, role_type, start_date, end_date)
SELECT (SELECT id FROM person WHERE vorname='Robert' AND nachname='Wares' LIMIT 1),
       (SELECT id FROM company WHERE name='Osisko Mining Inc.' LIMIT 1),
       'CEO', '2015-01-01', '2024-10-25';

INSERT INTO role (person_id, company_id, role_type, start_date, end_date)
SELECT (SELECT id FROM person WHERE vorname='John' AND nachname='Burzynski' LIMIT 1),
       (SELECT id FROM company WHERE name='Osisko Mining Inc.' LIMIT 1),
       'Chairman', '2015-01-01', '2024-10-25';

-- Osisko Mining Project
INSERT INTO project (company_id, name, jurisdiction, primary_commodity, stage_at_acquisition, peak_stage)
SELECT (SELECT id FROM company WHERE name='Osisko Mining Inc.' LIMIT 1),
       'Windfall Gold Project', 'Lebel-sur-Quevillon, Quebec, Canada', 'Au', 'FS', 'FS';

-- Osisko Mining Outcome
INSERT INTO outcome (company_id, discovery_score, reserve_conversion_score, exit_production_score, peak_marketcap_score, total_score, exit_type, exit_year, peak_marketcap_cad_million)
SELECT (SELECT id FROM company WHERE name='Osisko Mining Inc.' LIMIT 1),
       95, 90, 85, 95, 90.75, 'M&A', 2024, 2160;

-- Osisko Mining Events
INSERT INTO event (company_id, event_type, event_date, description)
SELECT (SELECT id FROM company WHERE name='Osisko Mining Inc.' LIMIT 1),
       'FS', '2022-11-28', 'Osisko Mining delivers Positive Feasibility Study for Windfall Gold Project (811,000 t @ 11.4 g/t Au)');

INSERT INTO event (company_id, event_type, event_date, description)
SELECT (SELECT id FROM company WHERE name='Osisko Mining Inc.' LIMIT 1),
       'M&A', '2024-10-25', 'Gold Fields Limited completes acquisition of Osisko Mining Inc. for CAD 2.16B per share (55% VWAP premium)';
