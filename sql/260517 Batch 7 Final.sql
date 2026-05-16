-- Batch 7: 2 NEW Success Companies (Exeter, Trelawney)
-- Frontier, Richfield, Aurizon, Romarco, Gold Eagle already exist
-- Date: 2026-05-17

PRAGMA foreign_keys = ON;

-- COMPANY 1: EXETER RESOURCES LIMITED
INSERT INTO company (name, isin, country, stock_exchange, listing_year, delisting_year, primary_commodity, fraud_flag, success_label) VALUES ('Exeter Resources Limited', NULL, 'Canada', 'TSX', 2006, 2017, 'Cu', 0, 'success');
INSERT INTO person (vorname, nachname, education, country, production_ramp_up_experience, first_mention_year, bio_text) VALUES ('Wendell', 'Zerb', NULL, 'Canada', 1, 2006, 'CEO Exeter Resources');
INSERT INTO person (vorname, nachname, education, country, production_ramp_up_experience, first_mention_year, bio_text) VALUES ('Bryce', 'Roxburgh', 'BSc Geology', 'Canada', 1, 2008, 'VP Exploration Exeter Resources');
INSERT INTO role (person_id, company_id, role_type, start_date, end_date) SELECT (SELECT id FROM person WHERE vorname='Wendell' AND nachname='Zerb' LIMIT 1), (SELECT id FROM company WHERE name='Exeter Resources Limited' LIMIT 1), 'CEO', '2006-01-01', '2017-08-15';
INSERT INTO role (person_id, company_id, role_type, start_date, end_date) SELECT (SELECT id FROM person WHERE vorname='Bryce' AND nachname='Roxburgh' LIMIT 1), (SELECT id FROM company WHERE name='Exeter Resources Limited' LIMIT 1), 'VP Exploration', '2008-01-01', '2017-08-15';
INSERT INTO project (company_id, name, jurisdiction, primary_commodity, stage_at_acquisition, peak_stage) SELECT (SELECT id FROM company WHERE name='Exeter Resources Limited' LIMIT 1), 'Caspiche', 'Region de Antofagasta, Chile', 'Cu', 'PEA', 'PEA';
INSERT INTO outcome (company_id, discovery_score, reserve_conversion_score, exit_production_score, peak_marketcap_score, total_score, exit_type, exit_year, peak_marketcap_cad_million) SELECT (SELECT id FROM company WHERE name='Exeter Resources Limited' LIMIT 1), 75, 80, 65, 70, 72.5, 'M&A', 2017, 247;
INSERT INTO event (company_id, event_type, event_date, description) SELECT (SELECT id FROM company WHERE name='Exeter Resources Limited' LIMIT 1), 'Discovery', '2010-05-15', 'Caspiche copper porphyry discovery in Chile');
INSERT INTO event (company_id, event_type, event_date, description) SELECT (SELECT id FROM company WHERE name='Exeter Resources Limited' LIMIT 1), 'Resource Estimate', '2012-11-30', 'Mineral resource: 1.1M tonnes Cu measured & indicated');
INSERT INTO event (company_id, event_type, event_date, description) SELECT (SELECT id FROM company WHERE name='Exeter Resources Limited' LIMIT 1), 'PEA', '2015-04-20', 'Preliminary Economic Assessment released');
INSERT INTO event (company_id, event_type, event_date, description) SELECT (SELECT id FROM company WHERE name='Exeter Resources Limited' LIMIT 1), 'M&A', '2017-08-15', 'Goldcorp acquires Exeter Resources for USD 247M';

-- COMPANY 2: TRELAWNEY MINING & EXPLORATION LIMITED
INSERT INTO company (name, isin, country, stock_exchange, listing_year, delisting_year, primary_commodity, fraud_flag, success_label) VALUES ('Trelawney Mining & Exploration Limited', NULL, 'Canada', 'TSX-V', 2005, 2012, 'Au', 0, 'success');
INSERT INTO person (vorname, nachname, education, country, production_ramp_up_experience, first_mention_year, bio_text) VALUES ('Greg', 'Gibson', NULL, 'Canada', 1, 2005, 'CEO Trelawney Mining');
INSERT INTO role (person_id, company_id, role_type, start_date, end_date) SELECT (SELECT id FROM person WHERE vorname='Greg' AND nachname='Gibson' LIMIT 1), (SELECT id FROM company WHERE name='Trelawney Mining & Exploration Limited' LIMIT 1), 'CEO', '2005-01-01', '2012-10-15';
INSERT INTO project (company_id, name, jurisdiction, primary_commodity, stage_at_acquisition, peak_stage) SELECT (SELECT id FROM company WHERE name='Trelawney Mining & Exploration Limited' LIMIT 1), 'Côté Lake', 'Ontario, Canada', 'Au', 'FS', 'Production';
INSERT INTO outcome (company_id, discovery_score, reserve_conversion_score, exit_production_score, peak_marketcap_score, total_score, exit_type, exit_year, peak_marketcap_cad_million) SELECT (SELECT id FROM company WHERE name='Trelawney Mining & Exploration Limited' LIMIT 1), 80, 85, 75, 70, 77.5, 'M&A', 2012, 608;
INSERT INTO event (company_id, event_type, event_date, description) SELECT (SELECT id FROM company WHERE name='Trelawney Mining & Exploration Limited' LIMIT 1), 'Discovery', '2007-01-30', 'Côté Lake gold discovery in Ontario');
INSERT INTO event (company_id, event_type, event_date, description) SELECT (SELECT id FROM company WHERE name='Trelawney Mining & Exploration Limited' LIMIT 1), 'Resource Estimate', '2009-06-15', 'Initial resource estimate: 2.9M oz Au');
INSERT INTO event (company_id, event_type, event_date, description) SELECT (SELECT id FROM company WHERE name='Trelawney Mining & Exploration Limited' LIMIT 1), 'PFS', '2010-12-01', 'Pre-Feasibility Study completed');
INSERT INTO event (company_id, event_type, event_date, description) SELECT (SELECT id FROM company WHERE name='Trelawney Mining & Exploration Limited' LIMIT 1), 'FS', '2012-02-15', 'Feasibility Study completed');
INSERT INTO event (company_id, event_type, event_date, description) SELECT (SELECT id FROM company WHERE name='Trelawney Mining & Exploration Limited' LIMIT 1), 'M&A', '2012-10-15', 'IAMGOLD acquires Trelawney Mining for CAD 608M';
