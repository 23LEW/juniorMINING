-- Batch 4: 5 Companies (Kaminak, Continental, NovaGold, Underworld, Virginia)
-- Schema Version: v1.3
-- Date: 2026-05-16
-- Execution: Use DB Browser → Execute SQL tab → Play → Write Changes

PRAGMA foreign_keys = ON;

-- ============================================================
-- COMPANY 1: Kaminak Gold (2005-2016)
-- ============================================================

INSERT INTO company (name, isin, country, stock_exchange, listing_year, delisting_year, primary_commodity, fraud_flag, success_label)
VALUES ('Kaminak Gold Corporation', NULL, 'Canada', 'TSX-V', 2005, 2016, 'Au', 0, 'success');

-- Kaminak persons
INSERT INTO person (vorname, nachname, education, country, production_ramp_up_experience, first_mention_year, bio_text)
VALUES ('Rob', 'Carpenter', 'Ph.D. P.Geo', 'Canada', 1, 2005, 'Co-Founder, CEO 2005-2013; 30+ years exploration');

INSERT INTO person (vorname, nachname, education, country, production_ramp_up_experience, first_mention_year, bio_text)
VALUES ('Eira', 'Thomas', 'B.Sc. Geology', 'Canada', 1, 2013, 'CEO Kaminak 2013-2016; 30+ years mining; 23 years diamond sector');

INSERT INTO person (vorname, nachname, education, country, production_ramp_up_experience, first_mention_year, bio_text)
VALUES ('Fred', 'Lightner', 'Colorado School Mines', 'Canada', 1, 2013, 'Director Mine Development 2013-2016; 45 years; led FS design');

-- Kaminak roles (get person IDs from previous inserts)
INSERT INTO role (person_id, company_id, role_type, start_date, end_date)
SELECT (SELECT id FROM person WHERE vorname='Rob' AND nachname='Carpenter' LIMIT 1),
       (SELECT id FROM company WHERE name='Kaminak Gold Corporation' LIMIT 1),
       'CEO', '2005-07-04', '2013-01-01';

INSERT INTO role (person_id, company_id, role_type, start_date, end_date)
SELECT (SELECT id FROM person WHERE vorname='Eira' AND nachname='Thomas' LIMIT 1),
       (SELECT id FROM company WHERE name='Kaminak Gold Corporation' LIMIT 1),
       'CEO', '2013-01-01', '2016-07-19';

INSERT INTO role (person_id, company_id, role_type, start_date, end_date)
SELECT (SELECT id FROM person WHERE vorname='Fred' AND nachname='Lightner' LIMIT 1),
       (SELECT id FROM company WHERE name='Kaminak Gold Corporation' LIMIT 1),
       'COO', '2013-01-01', '2016-07-19';

-- Kaminak project
INSERT INTO project (company_id, name, jurisdiction, primary_commodity, stage_at_acquisition, peak_stage)
SELECT (SELECT id FROM company WHERE name='Kaminak Gold Corporation' LIMIT 1),
       'Coffee Gold', 'Yukon Territory', 'Au', 'Discovery', 'FS';

-- Kaminak outcome
-- Score: 0.25*0.5 + 0.25*1.0 + 0.30*0.0 + 0.20*0.6 = 0.495
-- discovery_score=0.5 (Predecessor discovery, but FS derisking)
-- reserve_conversion_score=1.0 (PEA 2014, FS 2016, stable)
-- exit_production_score=0.0 (No production at exit)
-- peak_marketcap_score=0.6 (CAD 520M deal)
INSERT INTO outcome (company_id, discovery_score, reserve_conversion_score, exit_production_score, peak_marketcap_score, total_score, exit_type, exit_year, peak_marketcap_cad_million)
SELECT (SELECT id FROM company WHERE name='Kaminak Gold Corporation' LIMIT 1),
       0.5, 1.0, 0.0, 0.6, 0.495, 'M&A', 2016, 520;

-- Kaminak events
INSERT INTO event (company_id, event_type, event_date, description)
SELECT (SELECT id FROM company WHERE name='Kaminak Gold Corporation' LIMIT 1),
       'Discovery', '2010-01-01', 'Coffee Gold Discovery by Kaminak team via Shawn Ryan/RyanWood initial prospecting';

INSERT INTO event (company_id, event_type, event_date, description)
SELECT (SELECT id FROM company WHERE name='Kaminak Gold Corporation' LIMIT 1),
       'PEA', '2014-06-01', 'Positive Preliminary Economic Assessment: NPV $522M pre-tax, IRR 32.8%, AISC US$688/oz';

INSERT INTO event (company_id, event_type, event_date, description)
SELECT (SELECT id FROM company WHERE name='Kaminak Gold Corporation' LIMIT 1),
       'FS', '2016-01-01', 'Feasibility Study: NPV $455M after-tax, IRR 37%, AISC US$550/oz; bankable feasibility';

INSERT INTO event (company_id, event_type, event_date, description)
SELECT (SELECT id FROM company WHERE name='Kaminak Gold Corporation' LIMIT 1),
       'M&A', '2016-05-12', 'Goldcorp announces friendly acquisition: CAD $2.62/share, 0.10896 Goldcorp shares per Kaminak share';

INSERT INTO event (company_id, event_type, event_date, description)
SELECT (SELECT id FROM company WHERE name='Kaminak Gold Corporation' LIMIT 1),
       'M&A', '2016-07-19', 'Goldcorp completes acquisition; Kaminak delisted; deal value CAD $520M; 40% VWAP premium';

-- ============================================================
-- COMPANY 2: Continental Gold (2010-2020)
-- ============================================================

INSERT INTO company (name, isin, country, stock_exchange, listing_year, delisting_year, primary_commodity, fraud_flag, success_label)
VALUES ('Continental Gold Inc.', 'CA21146A1084', 'Canada', 'TSX', 2010, 2020, 'Au', 0, 'success');

-- Continental persons (Ari Sussman exists from Colossus, reuse)
-- Insert others
INSERT INTO person (vorname, nachname, education, country, production_ramp_up_experience, first_mention_year, bio_text)
VALUES ('León', 'Teicher', 'MBA Stanford', 'Canada', 1, 2014, 'Chairman/Exec Chair 2014-2020; Former CEO Cerrejón Coal 2006-2012 (Colombia); Fulbright Scholar');

INSERT INTO person (vorname, nachname, education, country, production_ramp_up_experience, first_mention_year, bio_text)
VALUES ('Donald', 'Gray', 'BS Mining Eng, MS Civil Eng MIT, MBA Auburn', 'Canada', 1, 2015, 'COO 2015-2020; 40+ years mining eng & ops; EVP Ops Tahoe Resources; led Buritica completion');

INSERT INTO person (vorname, nachname, education, country, production_ramp_up_experience, first_mention_year, bio_text)
VALUES ('Paul', 'Begin', 'CA MBA', 'Canada', 0, 2013, 'CFO 2013-2020; 15+ years senior finance; CFO Hanfeng Evergreen; public markets experience');

-- Continental roles
INSERT INTO role (person_id, company_id, role_type, start_date, end_date)
SELECT (SELECT id FROM person WHERE vorname='Ari' AND nachname='Sussman' LIMIT 1),
       (SELECT id FROM company WHERE name='Continental Gold Inc.' LIMIT 1),
       'CEO', '2010-06-01', '2020-03-05';

INSERT INTO role (person_id, company_id, role_type, start_date, end_date)
SELECT (SELECT id FROM person WHERE vorname='León' AND nachname='Teicher' LIMIT 1),
       (SELECT id FROM company WHERE name='Continental Gold Inc.' LIMIT 1),
       'Chairman', '2014-04-01', '2020-03-05';

INSERT INTO role (person_id, company_id, role_type, start_date, end_date)
SELECT (SELECT id FROM person WHERE vorname='Donald' AND nachname='Gray' LIMIT 1),
       (SELECT id FROM company WHERE name='Continental Gold Inc.' LIMIT 1),
       'COO', '2015-01-01', '2020-03-05';

INSERT INTO role (person_id, company_id, role_type, start_date, end_date)
SELECT (SELECT id FROM person WHERE vorname='Paul' AND nachname='Begin' LIMIT 1),
       (SELECT id FROM company WHERE name='Continental Gold Inc.' LIMIT 1),
       'CFO', '2013-01-01', '2020-03-05';

-- Continental project
INSERT INTO project (company_id, name, jurisdiction, primary_commodity, stage_at_acquisition, peak_stage)
SELECT (SELECT id FROM company WHERE name='Continental Gold Inc.' LIMIT 1),
       'Buritica', 'Tolima, Colombia', 'Au', 'Discovery', 'Production';

-- Continental outcome
-- Score: 0.25*0.85 + 0.25*0.90 + 0.30*1.0 + 0.20*0.95 = 0.9275
-- discovery_score=0.85 (Continental's own exploration team)
-- reserve_conversion_score=0.90 (2012: 1.64M oz → 2019: 3.7M oz; successful growth)
-- exit_production_score=1.0 (First Pour H1 2020, Commercial Prod 2021)
-- peak_marketcap_score=0.95 (2019 peak ~CAD 926M, exit CAD 1.4B)
INSERT INTO outcome (company_id, discovery_score, reserve_conversion_score, exit_production_score, peak_marketcap_score, total_score, exit_type, exit_year, peak_marketcap_cad_million)
SELECT (SELECT id FROM company WHERE name='Continental Gold Inc.' LIMIT 1),
       0.85, 0.90, 1.0, 0.95, 0.9275, 'M&A', 2020, 1400;

-- Continental events
INSERT INTO event (company_id, event_type, event_date, description)
SELECT (SELECT id FROM company WHERE name='Continental Gold Inc.' LIMIT 1),
       'IPO', '2010-06-01', 'Continental Gold IPO on TSX (Ticker: CNL); ~CAD $1B raised during tenure';

INSERT INTO event (company_id, event_type, event_date, description)
SELECT (SELECT id FROM company WHERE name='Continental Gold Inc.' LIMIT 1),
       'FS', '2019-01-01', 'Updated NI 43-101 Feasibility Study; resource estimate 3.7M oz M&I + Inferred';

INSERT INTO event (company_id, event_type, event_date, description)
SELECT (SELECT id FROM company WHERE name='Continental Gold Inc.' LIMIT 1),
       'M&A', '2019-12-02', 'Zijin Mining announces all-cash offer: CAD 1.4B (CAD $5.50/share); 29% premium VWAP';

INSERT INTO event (company_id, event_type, event_date, description)
SELECT (SELECT id FROM company WHERE name='Continental Gold Inc.' LIMIT 1),
       'M&A', '2020-03-05', 'Zijin Mining completes acquisition; Continental Gold delisted from TSX';

INSERT INTO event (company_id, event_type, event_date, description)
SELECT (SELECT id FROM company WHERE name='Continental Gold Inc.' LIMIT 1),
       'Production Start', '2020-06-30', 'Buritica first gold pour achieved (H1 2020 per schedule)';

INSERT INTO event (company_id, event_type, event_date, description)
SELECT (SELECT id FROM company WHERE name='Continental Gold Inc.' LIMIT 1),
       'Production Start', '2021-05-01', 'Zijin Continental Gold commercial production start at Buritica';

-- ============================================================
-- COMPANY 3: NovaGold Resources (1987-Active 2026)
-- ============================================================

INSERT INTO company (name, country, stock_exchange, listing_year, primary_commodity, fraud_flag, success_label)
VALUES ('NovaGold Resources Inc.', 'Canada', 'TSX/NYSE', 1987, 'Au', 0, 'pending');

INSERT INTO person (vorname, nachname, education, country, first_mention_year, bio_text)
VALUES ('Rick', 'Van Nieuwenhuyse', 'P.Geo', 'Canada', 1984, 'Founder CEO 1984-2012; VP Exploration Placer Dome 1990-1997; 35+ years');

INSERT INTO person (vorname, nachname, country, first_mention_year, bio_text)
VALUES ('Greg', 'Lang', 'Canada', 2012, 'President & CEO 2012-2026; joined from Barrick (was President Barrick Gold North America); 35+ years');

INSERT INTO role (person_id, company_id, role_type, start_date, end_date)
SELECT (SELECT id FROM person WHERE vorname='Rick' AND nachname='Van Nieuwenhuyse' LIMIT 1),
       (SELECT id FROM company WHERE name='NovaGold Resources Inc.' LIMIT 1),
       'Founder', '1984-01-01', '2012-01-01';

INSERT INTO role (person_id, company_id, role_type, start_date, end_date)
SELECT (SELECT id FROM person WHERE vorname='Greg' AND nachname='Lang' LIMIT 1),
       (SELECT id FROM company WHERE name='NovaGold Resources Inc.' LIMIT 1),
       'CEO', '2012-01-01', NULL;

INSERT INTO project (company_id, name, jurisdiction, primary_commodity, stage_at_acquisition, peak_stage)
SELECT (SELECT id FROM company WHERE name='NovaGold Resources Inc.' LIMIT 1),
       'Donlin Gold', 'Alaska, USA', 'Au', 'Brownfield', 'FS';

INSERT INTO project (company_id, name, jurisdiction, primary_commodity, stage_at_acquisition, peak_stage)
SELECT (SELECT id FROM company WHERE name='NovaGold Resources Inc.' LIMIT 1),
       'Galore Creek', 'British Columbia, Canada', 'Cu', 'PFS', 'PFS';

-- NovaGold outcome (PENDING — Active Developer, no exit)
-- Score: 0.25*0.5 + 0.25*0.7 + 0.30*0.0 + 0.20*0.8 = 0.46
-- discovery_score=0.5 (Acquired, not original discoverer)
-- reserve_conversion_score=0.7 (FS Donlin 2012, PFS Galore in progress)
-- exit_production_score=0.0 (No production; development stage)
-- peak_marketcap_score=0.8 (May 2026: ~CAD 4.7B market cap)
INSERT INTO outcome (company_id, discovery_score, reserve_conversion_score, exit_production_score, peak_marketcap_score, total_score, exit_type, exit_year, peak_marketcap_cad_million)
SELECT (SELECT id FROM company WHERE name='NovaGold Resources Inc.' LIMIT 1),
       0.5, 0.7, 0.0, 0.8, 0.46, 'Active', 2026, 4700;

INSERT INTO event (company_id, event_type, event_date, description)
SELECT (SELECT id FROM company WHERE name='NovaGold Resources Inc.' LIMIT 1),
       'Discovery', '2001-11-01', 'NovaGold acquires 70% interest in Donlin Gold from Placer Dome (US$12M); 2006 Barrick JV';

INSERT INTO event (company_id, event_type, event_date, description)
SELECT (SELECT id FROM company WHERE name='NovaGold Resources Inc.' LIMIT 1),
       'FS', '2012-01-01', 'Donlin Gold Feasibility Study filed; 33.8 Million oz Au reserves';

INSERT INTO event (company_id, event_type, event_date, description)
SELECT (SELECT id FROM company WHERE name='NovaGold Resources Inc.' LIMIT 1),
       'Discovery', '2003-01-01', 'NovaGold acquires Galore Creek from Stikine Copper (~US$20M); Teck partnership 2007';

INSERT INTO event (company_id, event_type, event_date, description)
SELECT (SELECT id FROM company WHERE name='NovaGold Resources Inc.' LIMIT 1),
       'M&A', '2018-08-01', 'NovaGold sells 50% Galore Creek to Newmont for US$275M; Newmont-Teck partnership continues';

INSERT INTO event (company_id, event_type, event_date, description)
SELECT (SELECT id FROM company WHERE name='NovaGold Resources Inc.' LIMIT 1),
       'Permit Granted', '2025-11-14', 'Alaska Supreme Court upholds Donlin Gold state water rights & pipeline ROW permits';

-- ============================================================
-- COMPANY 4: Underworld Resources (2005-2010)
-- ============================================================

INSERT INTO company (name, country, stock_exchange, listing_year, delisting_year, primary_commodity, fraud_flag, success_label)
VALUES ('Underworld Resources Inc.', 'Canada', 'TSX-V', 2005, 2010, 'Au', 0, 'success');

INSERT INTO person (vorname, nachname, country, first_mention_year, bio_text)
VALUES ('Adrian', 'Fleming', 'Canada', 2005, 'Co-Founder, President 2005-2010; led discovery and resource definition of Golden Saddle');

INSERT INTO person (vorname, nachname, country, first_mention_year, bio_text)
VALUES ('Robert', 'McLeod', 'Canada', 2005, 'VP Exploration, Director 2005-2010; 30+ years experience; led resource definition');

INSERT INTO role (person_id, company_id, role_type, start_date, end_date)
SELECT (SELECT id FROM person WHERE vorname='Adrian' AND nachname='Fleming' LIMIT 1),
       (SELECT id FROM company WHERE name='Underworld Resources Inc.' LIMIT 1),
       'CEO', '2005-01-01', '2010-06-30';

INSERT INTO role (person_id, company_id, role_type, start_date, end_date)
SELECT (SELECT id FROM person WHERE vorname='Robert' AND nachname='McLeod' LIMIT 1),
       (SELECT id FROM company WHERE name='Underworld Resources Inc.' LIMIT 1),
       'VP Exploration', '2005-01-01', '2010-06-30';

INSERT INTO project (company_id, name, jurisdiction, primary_commodity, stage_at_acquisition, peak_stage)
SELECT (SELECT id FROM company WHERE name='Underworld Resources Inc.' LIMIT 1),
       'White Gold', 'Yukon Territory', 'Au', 'Discovery', 'Discovery';

-- Underworld outcome
-- Score: 0.25*0.7 + 0.25*0.6 + 0.30*0.0 + 0.20*0.7 = 0.465
-- discovery_score=0.7 (Property optioned 2007, discovery 2008-2009 by UW drilling; 1.41M oz)
-- reserve_conversion_score=0.6 (Initial resource 2009, no PEA/PFS/FS before Kinross)
-- exit_production_score=0.0 (No production; exploration stage)
-- peak_marketcap_score=0.7 (CAD 139.2M deal, estimated CAD 95-110M pre-offer; 50% of Kaminak)
INSERT INTO outcome (company_id, discovery_score, reserve_conversion_score, exit_production_score, peak_marketcap_score, total_score, exit_type, exit_year, peak_marketcap_cad_million)
SELECT (SELECT id FROM company WHERE name='Underworld Resources Inc.' LIMIT 1),
       0.7, 0.6, 0.0, 0.7, 0.465, 'M&A', 2010, 139.2;

INSERT INTO event (company_id, event_type, event_date, description)
SELECT (SELECT id FROM company WHERE name='Underworld Resources Inc.' LIMIT 1),
       'Discovery', '2008-01-01', 'Underworld discovers Golden Saddle deposit, White Gold District Yukon; 18m @ 4.35 g/t Au';

INSERT INTO event (company_id, event_type, event_date, description)
SELECT (SELECT id FROM company WHERE name='Underworld Resources Inc.' LIMIT 1),
       'Resource Estimate', '2009-06-23', 'Initial resource estimate: 1.41M oz Au (1.0M oz Indicated Golden Saddle + 0.41M oz Inferred Arc)';

INSERT INTO event (company_id, event_type, event_date, description)
SELECT (SELECT id FROM company WHERE name='Underworld Resources Inc.' LIMIT 1),
       'M&A', '2010-03-16', 'Kinross & Underworld sign definitive agreement; 0.141 KGC shares + CAD $0.01 per UW share';

INSERT INTO event (company_id, event_type, event_date, description)
SELECT (SELECT id FROM company WHERE name='Underworld Resources Inc.' LIMIT 1),
       'M&A', '2010-06-30', 'Kinross completes acquisition; Underworld delisted; deal value CAD $139.2M; 50.2% VWAP premium');

-- ============================================================
-- COMPANY 5: Virginia Mines (1996-2015, Dual-exit: Goldcorp 2006 + Osisko 2015)
-- ============================================================

INSERT INTO company (name, country, stock_exchange, listing_year, delisting_year, primary_commodity, fraud_flag, success_label)
VALUES ('Virginia Mines Inc.', 'Canada', 'TSX', 1996, 2015, 'Au', 0, 'success');

INSERT INTO person (vorname, nachname, country, first_mention_year, bio_text)
VALUES ('André', 'Gaumond', 'Canada', 1996, 'Founder, President & CEO 1996-2006; led Eleonore from exploration to Goldcorp sale; 2005 Northern Miner Mining Person of the Year');

INSERT INTO person (vorname, nachname, country, first_mention_year, bio_text)
VALUES ('Paul', 'Archer', 'Canada', 1996, 'VP Exploration & Acquisitions 1996-2006; led exploration of Eleonore deposit');

INSERT INTO role (person_id, company_id, role_type, start_date, end_date)
SELECT (SELECT id FROM person WHERE vorname='André' AND nachname='Gaumond' LIMIT 1),
       (SELECT id FROM company WHERE name='Virginia Mines Inc.' LIMIT 1),
       'Founder', '1996-01-01', '2006-03-31';

INSERT INTO role (person_id, company_id, role_type, start_date, end_date)
SELECT (SELECT id FROM person WHERE vorname='André' AND nachname='Gaumond' LIMIT 1),
       (SELECT id FROM company WHERE name='Virginia Mines Inc.' LIMIT 1),
       'CEO', '1996-01-01', '2006-03-31';

INSERT INTO role (person_id, company_id, role_type, start_date, end_date)
SELECT (SELECT id FROM person WHERE vorname='Paul' AND nachname='Archer' LIMIT 1),
       (SELECT id FROM company WHERE name='Virginia Mines Inc.' LIMIT 1),
       'VP Exploration', '1996-01-01', '2006-03-31';

INSERT INTO project (company_id, name, jurisdiction, primary_commodity, stage_at_acquisition, peak_stage)
SELECT (SELECT id FROM company WHERE name='Virginia Mines Inc.' LIMIT 1),
       'Eleonore', 'James Bay, Quebec', 'Au', 'Discovery', 'Production';

-- Virginia outcome (Dual-exit: Goldcorp 2006 + Osisko 2015)
-- Score: 0.25*1.0 + 0.25*0.8 + 0.30*1.0 + 0.20*1.0 = 0.95
-- discovery_score=1.0 (Virginia's own team discovered Eleonore 2004; 3M oz estimated)
-- reserve_conversion_score=0.8 (No FS before Goldcorp, rapid post-acq; PFS 2011, FS post-2012)
-- exit_production_score=1.0 (First pour Oct 2014 post-Goldcorp; commercial prod April 2015)
-- peak_marketcap_score=1.0 (Combined exit US$881M+/CAD 1.3B+; includes royalty upside)
INSERT INTO outcome (company_id, discovery_score, reserve_conversion_score, exit_production_score, peak_marketcap_score, total_score, exit_type, exit_year, peak_marketcap_cad_million)
SELECT (SELECT id FROM company WHERE name='Virginia Mines Inc.' LIMIT 1),
       1.0, 0.8, 1.0, 1.0, 0.95, 'M&A', 2006, 881;

INSERT INTO event (company_id, event_type, event_date, description)
SELECT (SELECT id FROM company WHERE name='Virginia Mines Inc.' LIMIT 1),
       'Discovery', '2004-01-01', 'Virginia Gold Mines discovers Eleonore/Roberto deposit; 2002 grab sample 22.9 g/t Au; 2004 core trench 15.8 g/t');

INSERT INTO event (company_id, event_type, event_date, description)
SELECT (SELECT id FROM company WHERE name='Virginia Mines Inc.' LIMIT 1),
       'M&A', '2005-12-04', 'Goldcorp announces friendly acquisition of Virginia Gold Mines + Eleonore; US$420-425M deal');

INSERT INTO event (company_id, event_type, event_date, description)
SELECT (SELECT id FROM company WHERE name='Virginia Mines Inc.' LIMIT 1),
       'M&A', '2006-03-31', 'Goldcorp completes; shareholders receive 0.4 GG + 0.5 New Virginia per VGQ; Eleonore to Goldcorp');

INSERT INTO event (company_id, event_type, event_date, description)
SELECT (SELECT id FROM company WHERE name='Virginia Mines Inc.' LIMIT 1),
       'Production Start', '2014-10-01', 'Goldcorp/Newmont first gold pour at Eleonore (post-M&A production)');

INSERT INTO event (company_id, event_type, event_date, description)
SELECT (SELECT id FROM company WHERE name='Virginia Mines Inc.' LIMIT 1),
       'M&A', '2015-02-17', 'Osisko Gold Royalties completes acquisition of New Virginia Mines; CAD $461M; retained 2-3% NSR on Eleonore');

-- ============================================================
-- END OF BATCH 4 SQL INSERTS
-- ============================================================
-- Verification queries (execute after Play to verify insert success):
-- SELECT COUNT(*) FROM company WHERE success_label IN ('success', 'failure', 'ambivalent', 'pending');
-- SELECT name, success_label, exit_type FROM company WHERE listing_year >= 2005 ORDER BY listing_year DESC LIMIT 5;
-- SELECT company.name, outcome.total_score FROM company JOIN outcome ON company.id=outcome.company_id ORDER BY outcome.total_score DESC;
