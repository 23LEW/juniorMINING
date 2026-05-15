# Pipeline-Batch 1 — Audit

**Datum:** 2026-05-15
**Workflow-Version:** v0.2
**Schema-Version:** v1.2
**Batch-Scope:** 5 Failure-Companies

---

## Übersicht

| # | Company | Status nach Recherche | Total-Score | Bemerkung |
|---|---|---|---|---|
| 1 | Crystallex International | **FLAGGED** (Schema-Lücken) | 0.495 | Matched Pair zu Aurelian; 4 Event-Typen fehlen im Schema v1.2 |
| 2 | Colossus Minerals | **READY** | 0.245 | Sussman-Reverse-Causation bestätigt; sauberer Insolvenz-Pfad |
| 3 | Carpathian Gold | **HOLD** (Konzeptpapier-Korrektur nötig) | 0.555 | **Titaro/Allied Gold-Prämisse falsch** — Konsequenz für v0.4-Sample |
| 4 | Allied Nevada Gold | **READY** | 0.45 | Ch.11 2015; Hycroft existierender Deposit, kein Greenfield |
| 5 | Banro Corporation | **READY** | 0.495 | CCAA 2017; DRC Security-Vorfälle materiell für Failure-Story |

**Bereitschaft für SQL-Eintrag:** 3 von 5 sofort, 2 mit offenen Entscheidungen.

---

## Pro Company

### 1. Crystallex International Corporation

**Stammdaten:** Kanada, TSX+NYSE-Amex (KRY), 1984–2012 (CCAA Dez 2011, Delisting Jan 2012). Au+Ag. fraud_flag=0. exit_type=Insolvency, exit_year=2011.

**Persons (9, alle web-verifiziert):**
- Marc Oppenheimer (CEO/President 1995–2003)
- Robert Fung (Chairman 1998–2009, CEO 2008–2009; Banker)
- Todd Bruce (CEO/President 2003–2007; IAMGOLD-Veteran, production_ramp_up=1)
- Gordon Thompson (CEO/President 2007–2008-06-03; resigned nach Permit-Denial)
- Kenneth (Ken) Thomas (COO ~2005–~2007; Barrick-Veteran, production_ramp_up=1)
- Robert (Bob) Crombie (CFO+President 2011–2012, durch CCAA)
- Hemdat Sawh (CFO ~2008–~2011)
- Richard Spencer (VP Exploration 2004–2008; PhD-Geologe; späterer Gründer Aurania Resources)
- Luis Felipe Cottin (President Crystallex Venezuela-Tochter ~2005–~2011)

**Project:** Las Cristinas (Venezuela Bolívar, Au-Cu, Brownfield→FS, FS 2003+2005, Resource 20.8 Moz M&I + 6.3 Moz Inferred). Plus Tomi, Lo Increible, Revemin Mill, Albino (kleinere Operations).

**Outcome:** Discovery 0.5 (signifikante Erweiterung via Spencer-Team, +6.6 Moz Reserven), Reserve-Conversion 1.0 (FS), Exit 0.0 (CCAA), Peak-MarketCap 0.6 (~1.0–1.5 Mrd CAD, borderline 0.6/1.0). **Total 0.495.** peak_marketcap_cad_million ≈ 1200 (estimate).

**Events (12):** IPO 1984; M&A Las Cristinas 1997; M&A Tomi-Erwerb 2000-08; M&A MOC mit CVG 2002-09-17; FS 2003 + 2005; Resource Estimate 2007-11; **Permit Granted 2007-06-14**; **Permit Denied 2008-04-14**; **MOC Termination/Expropriation 2011-02**; Insolvency 2011-12-23; Delisting 2012-01-06; **ICSID Arbitration Award 2016-04-04** (USD 1.386 Mrd Schadensersatz).

**ZWEIFELSFÄLLE / FLAGS:**
- **Schema-Lücke (4 Event-Typen fehlen):** Permit Granted, Permit Denied, Expropriation, Arbitration Award. Diese Events sind zentral für die Failure-Story.
- **Discovery-Score borderline:** 0.0 (kein Greenfield) vs. 0.5 (Reserven-Extension). Konvention v0.2 erlaubt 0.5; konservativ wäre 0.0.
- **Peak-MarketCap borderline:** Best estimate 1.0–1.5 Mrd CAD. 0.6 oder 1.0?
- **Founder NULL:** Die 1984–1995-Periode ist intransparent; kein Founder identifiziert.
- **Revemin Mill:** Schema kennt nur project (Deposit-zentriert); Mill ist Infrastruktur, nicht Lagerstätte.

**Quellen verwendet:** 21 (SEC EDGAR Filings, ICSID-Award via italaw, The Globe and Mail, Mining Weekly, CIM, Wikipedia, Hughes Hubbard).

---

### 2. Colossus Minerals Inc.

**Stammdaten:** Kanada (Ontario, inkorporiert 2006-02-09), TSX (CSI), 2008–2014 (BIA-Insolvenz Jan 2014, Delisting Feb 2014). Au+Pd+Pt. fraud_flag=0. exit_type=Insolvency, exit_year=2014.

**Persons (10, alle web-verifiziert):**
- Ari Sussman (Founder + CEO 2006–2011, Chairman 2006–2012-10-15; promoter/dealmaker; *vor* Continental Gold)
- John Frostiak (Chairman 2012–2014+; Barrick-Veteran, production_ramp_up=1)
- Claudio Mancuso (President+CEO 2011-03 bis 2013-11; vorher Agnico-Eagle VP Treasurer)
- David Massola (CFO ~2012–2014, Interim CEO 2013-11-15 bis 2014; BHP-Diamonds-Veteran)
- Paulo de Tarso Serpa Fagundes (COO ~2011–2014; Yamana-Veteran, production_ramp_up=1)
- Vic Wall (VP Exploration + Founder; PhD-Geologe, Australier; verstorben; ScienceDirect-Paper-Memoriam)
- Patrick Anderson (Director ab ~2013; *derselbe* Anderson aus Aurelian!)
- David D'Onofrio (Founder, Director 2006–~2013; später CEO White Gold)
- Tom Bruington (Director ab 2014-04-30, post-Restrukturierung)
- John Budreski (Director ab 2014-04-30, post-Restrukturierung)

**Project:** Serra Pelada (Brasilien Pará Carajás, Au-Pd-Pt, hydrothermal epigenetisch, Brownfield→Construction; 75% JV mit COOMIGASP-Garimpeiros-Kooperative; Wasserzufluss bei Untertageentwicklung Spätstadium).

**Outcome:** Discovery 0.5 (historisch artisanaler Bereich, aber NI 43-101 Resource Estimate Dez 2013 unter Colossus), Reserve-Conversion 0.0 (NUR Inferred+Indicated Dez 2013; kein PEA/PFS/FS — Sprung direkt in Untertageentwicklung), Exit 0.0 (BIA/Insolvenz), Peak-MarketCap 0.6 (~700 Mio CAD, gut innerhalb 250–1B). **Total 0.245.** peak_marketcap_cad_million ≈ 700.

**Events (7):** IPO 2008-02; Discovery-Drillerfolge 2009–2011; Streaming-Deal Sandstorm 2012-09 (USD 75 Mio); Resource Estimate 2013-12-20; Insolvency 2014-01-14 (BIA); Delisting 2014-02-21; Restrukturierung-Implementierung 2014-04-30.

**ZWEIFELSFÄLLE / FLAGS:**
- **Sussman-Reverse-Causation BESTÄTIGT:** Sussman *verließ* Colossus vor der operativen Katastrophe (Okt 2012); Insolvenz Jan 2014 unter Mancuso/Massola. Sein späterer Continental-Gold-Erfolg (Verkauf an Zijin C$1.4B 2020) ist post-Colossus. Klassischer Fall für „bet on the jockey".
- **Patrick Anderson Cross-Link interessant:** Anderson (Aurelian-Founder, Mining Person of the Year 2008) trat 2013 Colossus-Board bei — *nach* Aurelian-Erfolg, *vor* Colossus-Failure. Datenpunkt für die Hypothese: erfolgreicher Discoverer trat sinkender Company bei.
- **Reserve-Conversion 0.0 trotz NI 43-101:** Sprung Discovery→Construction ohne PEA/PFS/FS ist nach Workflow korrekt mit 0.0 bewertet. Das ist *die* governance-Failure-Signatur, die unsere DB erkennen soll.
- **75% JV-Struktur** mit COOMIGASP: notable structural risk factor (artisanal-cooperative-JV), nicht im Schema abbildbar.

**Quellen verwendet:** 15 (KSV Advisory, Globenewswire, Yahoo Finance, ScienceDirect-Akademisches Paper, Bus-Ex, Mining.com, Helius Minerals).

---

### 3. Carpathian Gold Inc.

**STATUS: HOLD — Konzeptpapier-Korrektur erforderlich**

**Stammdaten:** Kanada (Toronto), TSX (CPN), 2003–2016 (renamed Euro Sun Mining Aug 2016). Au+Cu. fraud_flag=0. exit_type=?? (Schema-Lücke), exit_year=2016.

**Persons (10, alle web-verifiziert):**
- **Dino Titaro** (Founder + President+CEO 2003-01–2014-01; M.Sc. Geology Western Ontario, P.Geo; vorher A.C.A. Howe International Consultancy 1986–2003)
- Guy Charette (EVP+Interim CEO 2010–2016-05; Wertpapierrechts-Anwalt)
- Rishi Tibriwal (CFO 2012-07–~2016)
- Linda Prager (CFO ~pre-2012 bis 2012-07)
- Randall Ruff (COO/EVP Exploration 2002–2016)
- John Hick (Director pre-2014 bis 2016-09)
- Julio Carvalho (Director ~2012 bis 2016-09; Brasilien-Link)
- Scott Moore (Interim CEO 2016-05 bis 2016-08; Forbes & Manhattan COO)
- Stan Bharti (Cornerstone Investor + Director 2016-05; Forbes & Manhattan Chairman, production_ramp_up=1)
- Barrick Gold Corp. (Corporate Cornerstone Investor 2011-08-12, 9% via CAD 20 Mio)

**Projects (zwei Haupt):**
- Rovina Valley (Rumänien Hunedoara, Au-Cu Porphyry; 3 Deposits: Rovina, Colnic, Ciresata; Greenfield→PEA-only unter Carpathian; FS erst 2021 unter Euro Sun)
- Riacho dos Machados RDM (Brasilien Minas Gerais, Au orogenic; Brownfield-Vale-legacy→FS 2011-04→Production Dez 2013→commercial Q4 2014→ZWANGSABGABE an Brio Gold Apr 2016)

**Outcome:** Discovery 0.5 (Rovina-Porphyry-Delineation eigene Leistung), Reserve-Conversion 1.0 (RDM FS, in Produktion), Exit 0.4 (RDM erreichte Produktion, aber Asset an Lender verloren), Peak-MarketCap 0.3 (~220–280 Mio CAD, borderline 0.3/0.6). **Total 0.555.** peak_marketcap_cad_million ≈ 250.

**Events (~10–13):** IPO 2003; Discovery Rovina-Porphyry 2006–2008; M&A RDM-Erwerb 2008-10-30; PEA RDM 2009-08-12; PEA Rovina 2010-03-23; FS RDM 2011-04-06; Cornerstone Barrick 2011-08-12; Resource Estimate Rovina 2012-08-31; Production Start RDM 2013-12-24; Commercial RDM 2014-Q4; Restrukturierung 2015-11; M&A RDM-Verlust an Brio 2016-04-29; Cornerstone Forbes & Manhattan 2016-05-09; Name Change 2016-08-18.

**KRITISCHER ZWEIFELSFALL:**

> **Die Konzeptpapier-v0.4-Prämisse zu Dino Titaro ist faktisch falsch.**
>
> Konzeptpapier v0.4 §8.2 listet Titaro als „ambivalente Person" mit der Geschichte:
> *„Allied Gold (Erfolg) ↔ Carpathian Gold (Failure)"*
>
> **Verifizierter Befund:** Titaros tatsächliche Karriere vor Carpathian Gold war:
> 1. Getty Mines (Geologe, 1980–1986)
> 2. **A.C.A. Howe International Limited** (geologische Beratungsfirma, sein eigenes Unternehmen, 1986–2003)
> 3. Gründer Carpathian Gold 2003
>
> Sein „Allied Gold"-Bezug ist *zeitlich NACH* Carpathian: Er wurde Director von **Allied Gold Corporation** (Peter Marrones afrikanischer Au-Produzent, SPAC-Listing 2023) — und das ist eine **andere Firma** als das historische Allied Gold Limited (Australien, PNG/Solomon Islands, von St Barbara 2012 übernommen).
>
> **Es gibt keine öffentlich verifizierbare Verbindung zwischen Dino Titaro und dem historischen australischen Allied Gold.** Die Reverse-Causation-Prämisse ist nicht haltbar.

**Weitere Flags:**
- **Schema-Lücke exit_type:** Carpathian wurde NICHT delisted — sondern umbenannt zu Euro Sun. „Delisting" passt nicht; „M&A" auch nicht ganz. Eventuell neuer Wert „Restructuring/Rebrand" oder als „Active" mit zusätzlichem Vermerk.
- **Peak-MarketCap borderline:** 220–280 Mio CAD, score 0.3 vs. 0.6. Konservativ 0.3 vorgeschlagen.
- **RDM-Erfolg vs. Carpathian-Failure:** Komplex — RDM existiert heute noch (über Equinox Gold), Carpathian-als-Vehikel scheiterte. Exit-Score 0.4 trägt diesem Mixed-Outcome Rechnung.

**Quellen verwendet:** 16 (GlobeNewswire, Mining.com, Yahoo Finance, Marketwired, Equinox Gold SEC, Allied Gold Bio, Mining Watch Romania, Wikipedia).

---

### 4. Allied Nevada Gold Corp.

**Stammdaten:** USA (Reno NV), TSX+NYSE-Amex/NYSE-MKT (ANV), 2007–2015 (Ch.11 Mar 2015). Au+Ag. fraud_flag=0 (mit Hinweis auf Securities-Class-Action). exit_type=Insolvency, exit_year=2015. **Spin-off von Vista Gold 2007.**

**Persons (9, alle web-verifiziert, mit Lücken bei Geburtsjahren):**
- Robert (Bob) Buchan (Founder + Chairman 2007–2015; Kinross-Gründer; BSc Mining Heriot-Watt 1969, MSc Mining Queen's 1972; production_ramp_up=1)
- Scott Caldwell (President+CEO 2007-05-10 bis 2013-07; BSc Mining Arizona; vorher EVP+COO Kinross; production_ramp_up=1)
- Randy Buffington (COO 2013-02 bis 2013-07, dann President+CEO 2013-07 bis 2015; MSc Civil UNR; vorher SVP Operations Coeur d'Alene; production_ramp_up=1)
- Stephen Jones (EVP+CFO 2012-03 bis 2015; CPA Texas A&M; vorher Katanga Mining)
- Hal Kirby (VP+CFO 2007-05 bis 2012-03; vorher VP+Controller Kinross)
- Carl Pescio (Co-Founder + Cornerstone Investor + Director 2007–~2015; Nevada-Prospector; 16.2% Anteilseigner)
- Michael Richings, Terry Palmer, W. Durand Eppler (Initial-Board-Direktoren 2007; biographische Details begrenzt)

**Project:** Hycroft Mine (Nevada Sulphur District; Au+Ag epithermal hot-spring; Past-Producing seit 1998 stillgelegt; Restart 2008; Mill-Expansion FS 2011/2012 nie gebaut). Plus Hasbrouck Mountain, Mountain View, Wildcat, Three Hills (alle Nevada Exploration), Maverick Springs JV.

**Outcome:** Discovery 0.0 (Hycroft = existierender Past-Producer-Asset, kein Greenfield; alle Sekundär-Properties known historic prospects), Reserve-Conversion 1.0 (PFS 2011 + FS 2011/2012 für Hycroft Mill-Expansion + aktive Heap-Leach-Produktion seit 2008), Exit 0.0 (Ch.11 2015, Equity wiped out), Peak-MarketCap 1.0 (Peak ~USD 3.3 Mrd Mai 2011 ≈ CAD 3.3 Mrd, weit über 1 Mrd-Schwelle). **Total 0.45.** peak_marketcap_cad_million ≈ 3300.

**Events (~8):** Spin-off/IPO 2007-05-10; Resource Estimate 2008; Production Start 2008-12; PFS 2011; FS 2011-09; FS Update 2012; Insolvency 2015-03-10; Delisting 2015-03; Ch.11 Plan Confirmation 2015-10-08 (emerging als Hycroft Mining Corp.).

**ZWEIFELSFÄLLE / FLAGS:**
- **Buchan-Cross-Link:** Kinross-Gründer wechselt zu Allied Nevada. Erfolgsperson → erfolgloses Vehikel? Spannender Datenpunkt für die Hypothese.
- **Wickenburg-Projekt: existiert nicht** (war in meinem ursprünglichen Brief; ist in Arizona, nicht Nevada). Korrigiert.
- **Discovery 0.0 vs. Reserve-Conversion 1.0:** Charakteristisch für Past-Producer-Acquirer-Stories. Nicht problematisch, aber zeigt: hohe technische Reife ohne eigenen Discovery-Track.
- **Securities Class Action** (IN RE ALLIED NEVADA GOLD CORP. SECURITIES LITIGATION): keine Fraud-Verurteilung, fraud_flag=0 belassen.
- **VP Exploration / Chief Geologist** nicht namentlich verifizierbar (heavily operations-fokussiert).

**Quellen verwendet:** 19 (SEC EDGAR S-1, Kroll Court Records, Bloomberg, JDSupra, Law360, UCLA-LoPucki BRD, Mining.com, Wikipedia, Queen's Encyclopedia).

---

### 5. Banro Corporation

**Stammdaten:** Kanada (Toronto), TSX+NYSE-AM (BAA), Listing 1996 als Banro Resource Corp. → renamed Banro Corporation Jan 2001 → BAA-Ticker seit 2005 → CCAA Dez 2017 → Delisting Jan 2018. Pure Au. fraud_flag=0. exit_type=Delisting, exit_year=2018.

**Persons (10+):**
- Arnold Kondrat (Founder 1994; EVP + Director 1994–2017; University of Western Ontario; production_ramp_up=1)
- Bernard van Rooyen (Director 1996–2018, Ex-Chairman; Südafrika)
- Peter Cowley (President+CEO 2004–2008; Geologe, vorher Ashanti Geita-Discovery; production_ramp_up=1)
- Mike Prinsloo (President+CEO 2007–2010-09-16; vorher Gold Fields Driefontein MD; production_ramp_up=1)
- Simon Village (Chairman 2004–2018, Interim P+CEO 2010 und 2012–2013; Ex-WGC Managing Director)
- John Clarke (President+CEO ~2013/2014–2018; PhD Metallurgy Cambridge; vorher Nevsun Bisha; production_ramp_up=1)
- Brett Richards (Chairman+CEO ab 2018-05-07, post-CCAA; Katanga Mining-Veteran; production_ramp_up=1)
- Donat Madilo (CFO 2007–2014; dann SVP Commercial/DRC 2014–2018)
- Dan Bansah (VP Exploration ~2007–~2014; M.Sc. Leicester; Chartered AusIMM)
- Bubaka Rudahya (Group Chief Geologist DRC ~2010+)
- Geoffrey Farr (VP+General Counsel)
- **Cornerstone post-CCAA 2018:** Gramercy Funds Management LLC + Baiyin International Investment Ltd. (chinesisch)

**Projects (4 im Twangiza-Namoya Gold Belt):**
- Twangiza (DRC South-Kivu, Au orogenic; Brownfield→Production Sept 2012)
- Namoya (DRC Maniema, Au orogenic; Brownfield→Production Jan 2016; mit Militia-Vorfällen suspendiert)
- Lugushwa (DRC South-Kivu; Resource Estimate-only)
- Kamituga (DRC South-Kivu; historische Mobale-Operation, Resource 2005)

**Outcome:** Discovery 0.5 (SOMINKI-legacy aber Banro definierte moderne NI 43-101-Resourcen am Twangiza-Namoya-Belt), Reserve-Conversion 1.0 (FS Twangiza + FS Namoya 2013), Exit 0.0 (CCAA, Stamm-Equity wiped out, Delisting), Peak-MarketCap 0.6 (~US$900M–$1B in 2011–2012; CAD ~1.0 Mrd, borderline 0.6/1.0). **Total 0.495.** peak_marketcap_cad_million ≈ 1000.

**Events (~15):** Founding 1994-05-03; SOMINKI-Erwerb 1996; IPO 1996; Exchange Upgrade AMEX 2005-03-28; Exchange Upgrade TSX 2005-11-10; Resource Estimate 2005-02 (SRK NI 43-101); PEA Twangiza 2011-03-09; Production Start Twangiza 2011-Q4; **Commercial Production Twangiza 2012-09-01**; FS Namoya 2013-12-31; Commercial Production Namoya 2016-01; Security incidents 2017-03 + 2017-07; Insolvency CCAA 2017-12-22; Delisting 2018-01-22; Restrukturierung-Schluss 2018-05-04; Brett Richards CEO 2018-05-07.

**ZWEIFELSFÄLLE / FLAGS:**
- **Listing-Jahr-Ambiguität:** 1996 (Vorgänger Banro Resource Corp.) oder 2005 (aktueller Ticker BAA). Empfehlung: listing_year=1996, mit Vermerk.
- **CCAA mit Continuation:** Public-Equity wiped out, Underlying-Operations bestehen privat fort. Aus Investorensicht Total-Verlust → exit_type=Delisting + exit_score=0.0. Wenn „Restrukturierung mit Fortbestand" als 0.4-Bucket gewertet würde: exit_score=0.4, total_score=0.62. Konservativ 0.0.
- **DRC Security-Vorfälle:** Material für Failure-Narrativ (Kidnappings, Militia-Clashes, Namoya-Supply-Cutoff). Im Schema nicht direkt abbildbar als event_type — als description in vorhandenen Events (z.B. ein Insolvency-Event mit Beschreibung der Vorfälle) oder als Schema-Lücke flaggen.
- **Cornerstone-Investoren als Corporate Entities:** Gramercy + Baiyin sind Firmen, keine Personen. Schema-Tabelle `person` passt nicht; ggf. separater Cornerstone-Entity-Eintrag oder als description-Vermerk im Event.
- **Peak-MarketCap borderline:** 0.6/1.0. Konservativ 0.6.

**Quellen verwendet:** 19 (SEC Form 20-F, GlobeNewswire, FTI Consulting Court Filing, The Globe and Mail, Mining Review Africa, NGO/MiningWatch, Wikipedia, Heliyon-akademisch).

---

## Cross-Cutting Zweifelsfälle (Lew-Entscheidung)

### A. Konzeptpapier v0.4 §8.2 — Dino Titaro

**Befund:** Die „ambivalente Person"-Klassifikation für Dino Titaro (Allied Gold ↔ Carpathian Gold) ist verifiziert *nicht* haltbar.

**Optionen:**
- (A1) Titaro aus der „ambivalenten Personen"-Liste in v0.4 streichen → Konzeptpapier v0.5 nötig
- (A2) Konzeptpapier-Update verschieben, Carpathian trotzdem als reguläres Failure-Sample eintragen
- (A3) Carpathian aus Pilot-Sample entfernen (anderes Failure-Pair wählen)

**Meine Empfehlung:** (A2) — Carpathian eintragen als ein Failure (nicht als Reverse-Causation-Test), Korrektur in v0.5 vermerken. Datenqualität bleibt, Sample-Größe bleibt.

### B. Schema-Migration v1.2 → v1.3 (event_type-Erweiterung)

**Befund:** Crystallex-Story hat 4 zentrale Events, die im Schema fehlen. Banro-Security-Vorfälle und Carpathian-Restrukturierung ebenfalls problematisch.

**Konkrete Schema-Lücken:**
- `Permit Granted` (Crystallex 2007-06-14)
- `Permit Denied` (Crystallex 2008-04-14 — Failure-Auslöser)
- `Expropriation` (Crystallex 2011-02 — MOC Termination)
- `Arbitration Award` (Crystallex 2016-04-04 — USD 1.386 Mrd)
- ggf. `Security Incident` (Banro Militia-Vorfälle 2017)
- ggf. `Restructuring/Rebrand` (Carpathian → Euro Sun 2016)

**Optionen:**
- (B1) Migration v1.3 jetzt schreiben (4 oder 6 neue event_type-Werte) → Crystallex sauber eintragbar
- (B2) Events in `description` von vorhandenen event_types unterbringen (z.B. Permit Denied als „Resource Estimate" mit erklärender Description — semantisch falsch)
- (B3) Diese Events bei Crystallex weglassen (Informationsverlust)

**Meine Empfehlung:** (B1) — Migration v1.3 mit 4 neuen Event-Typen: `Permit Granted`, `Permit Denied`, `Expropriation`, `Arbitration Award`. Security Incident und Restructuring/Rebrand wären optional bzw. für später.

### C. Discovery-Score-Konvention bei Brownfield-Brownfield-Stories

**Befund:** Mehrere Companies (Crystallex Las Cristinas, Banro SOMINKI-Belt) hatten ältere Lagerstätten, die sie modernisiert/neu definiert haben. Discovery 0.0 oder 0.5?

**Konvention v0.2 §7.1:** 0.5 für „signifikante Erweiterung durch die Company (Strike-Extension, neue Zone, bedeutende Grade-Verbesserung)". Quantitatives Kriterium fehlt.

**Konkrete Fälle:**
- Crystallex: +6.6 Moz Reserven durch Spencer-Team — eindeutig 0.5
- Banro: NI 43-101 erstmals an Twangiza-Belt — 0.5 (eigentlich „first modern resource", aber Lagerstätten bekannt)
- Colossus Serra Pelada: NI 43-101 erstmals — 0.5
- Carpathian Rovina-Porphyry: Greenfield-Discovery durch Carpathian — 0.5 (Beleg via Wikipedia/SEDAR)
- Allied Nevada Hycroft: Past-Producer, keine eigene Discovery — 0.0

**Empfehlung:** Konvention so beibehalten; +6.6 Moz oder „erste moderne NI 43-101 Resource am Belt" als 0.5 zählen.

### D. Peak-MarketCap-Konvention bei Border-Cases

**Befund:** 3 von 5 Companies sind borderline zwischen Buckets (Crystallex 0.6/1.0, Banro 0.6/1.0, Carpathian 0.3/0.6).

**Konvention v0.2 §7.4:** Bucket-Schwellen 50/250/1000 Mio CAD. Exakter Wert in `peak_marketcap_cad_million` für Phase-3-Kalibrierung.

**Empfehlung:** Bei Borderline immer den *niedrigeren* Bucket nehmen (konservativ), exakten Wert speichern. Phase 3 kalibriert die Schwellen empirisch neu.

### E. Crystallex: Founder NULL

**Befund:** Die 1984–1995-Periode von Crystallex ist intransparent. Marc Oppenheimer trat erst 1995 ein. Kein eindeutiger Founder identifizierbar.

**Empfehlung:** Founder-Rolle leer lassen (NULL). Workflow §4 erlaubt das.

---

## Status der Lieferung

**Bereit für SQL-Generierung nach Lew-Entscheidung:**
- Crystallex (abhängig von B)
- Colossus Minerals (READY)
- Allied Nevada Gold (READY)
- Banro Corporation (READY)

**Hold bis Konzeptpapier-Entscheidung:**
- Carpathian Gold (abhängig von A)

**Pending:**
- 5 INSERT-SQL-Files
- sources.csv-Erweiterung um ~85 neue Quellen
- Git-Commit

---

## Empfehlungen für Lew

1. **A2** wählen — Carpathian eintragen, Konzeptpapier-Korrektur in v0.5 später.
2. **B1** wählen — Migration v1.3 schreiben mit 4 neuen event_types (Permit Granted, Permit Denied, Expropriation, Arbitration Award). Sequenz: erst Migration v1.3, dann alle 5 SQL-Inserts.
3. **C, D, E** wie empfohlen — keine Anpassung des Workflows nötig.

Bei OK auf 1+2: ich generiere Migration v1.3 + 5 SQL-Files + sources.csv + commit. Geschätzter Zeitaufwand danach: 20–30 Min meinerseits.

---

*Audit erstellt 2026-05-15. Workflow v0.2 §11.2.*
