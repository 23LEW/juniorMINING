#!/usr/bin/env python3
"""
build_viewer.py — Generiert docs/index.html aus data/junior_mining.db
Embedding aller Daten als JSON, keine Runtime-DB-Verbindung.

Usage:
    python3 scripts/build_viewer.py
"""

import sqlite3
import json
import os
from pathlib import Path
from html import escape

# Paths
REPO_ROOT = Path(__file__).parent.parent
DB_PATH = REPO_ROOT / "data" / "junior_mining.db"
OUTPUT_PATH = REPO_ROOT / "docs" / "index.html"


def read_db():
    """Liest alle Tabellen aus der Datenbank."""
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    cursor = conn.cursor()

    data = {}

    # Companies
    cursor.execute("""
        SELECT c.*, o.discovery_score, o.reserve_conversion_score,
               o.exit_production_score, o.peak_marketcap_score, o.total_score,
               o.exit_type, o.exit_year, o.peak_marketcap_cad_million
        FROM company c
        LEFT JOIN outcome o ON c.id = o.company_id
    """)
    data["companies"] = [dict(row) for row in cursor.fetchall()]

    # Persons
    cursor.execute("SELECT * FROM person ORDER BY nachname, vorname")
    data["persons"] = [dict(row) for row in cursor.fetchall()]

    # Projects
    cursor.execute("SELECT * FROM project")
    data["projects"] = [dict(row) for row in cursor.fetchall()]

    # Roles
    cursor.execute("SELECT * FROM role")
    data["roles"] = [dict(row) for row in cursor.fetchall()]

    # Events
    cursor.execute("SELECT * FROM event ORDER BY company_id, event_date")
    data["events"] = [dict(row) for row in cursor.fetchall()]

    conn.close()
    return data


def build_html(data):
    """Generiert komplettes HTML mit embedded JSON und inline JS/CSS."""

    # JSON escapen für embedding
    json_data = json.dumps(data, ensure_ascii=False, indent=2)
    json_safe = escape(json_data)

    html = f"""<!DOCTYPE html>
<html lang="de">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Junior-Mining DB — HTML Viewer</title>
    <script defer src="https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.js"></script>
    <style>
        * {{
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }}

        body {{
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
            background: #f5f5f5;
            color: #333;
            line-height: 1.5;
        }}

        header {{
            background: linear-gradient(135deg, #2c3e50 0%, #34495e 100%);
            color: white;
            padding: 2rem;
            text-align: center;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }}

        header h1 {{
            font-size: 2rem;
            margin-bottom: 0.5rem;
        }}

        header p {{
            font-size: 0.9rem;
            opacity: 0.9;
        }}

        nav {{
            background: white;
            border-bottom: 1px solid #ddd;
            sticky: top;
            top: 0;
            z-index: 100;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
        }}

        .nav-tabs {{
            display: flex;
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 1rem;
        }}

        .nav-tabs button {{
            flex: 1;
            padding: 1rem;
            border: none;
            background: none;
            cursor: pointer;
            font-size: 0.95rem;
            font-weight: 500;
            border-bottom: 3px solid transparent;
            transition: all 0.3s;
            color: #666;
        }}

        .nav-tabs button:hover {{
            color: #2c3e50;
            background: #f9f9f9;
        }}

        .nav-tabs button.active {{
            color: #2980b9;
            border-bottom-color: #2980b9;
        }}

        .container {{
            max-width: 1200px;
            margin: 2rem auto;
            padding: 0 1rem;
        }}

        .section {{
            display: none;
            background: white;
            border-radius: 8px;
            padding: 2rem;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }}

        .section.active {{
            display: block;
        }}

        .filters {{
            background: #f9f9f9;
            padding: 1.5rem;
            border-radius: 6px;
            margin-bottom: 2rem;
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
        }}

        .filter-group label {{
            display: block;
            font-size: 0.85rem;
            font-weight: 600;
            color: #666;
            margin-bottom: 0.5rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }}

        .filter-group input,
        .filter-group select {{
            width: 100%;
            padding: 0.75rem;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 0.95rem;
            font-family: inherit;
        }}

        table {{
            width: 100%;
            border-collapse: collapse;
            margin-top: 1rem;
        }}

        thead {{
            background: #f5f5f5;
            border-bottom: 2px solid #ddd;
        }}

        th {{
            padding: 1rem;
            text-align: left;
            font-weight: 600;
            color: #333;
            cursor: pointer;
            user-select: none;
            white-space: nowrap;
        }}

        th:hover {{
            background: #eee;
        }}

        td {{
            padding: 0.75rem 1rem;
            border-bottom: 1px solid #eee;
        }}

        tr:hover {{
            background: #fafafa;
        }}

        .status-badge {{
            display: inline-block;
            padding: 0.35rem 0.75rem;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 600;
            text-transform: capitalize;
        }}

        .status-success {{
            background: #d4edda;
            color: #155724;
        }}

        .status-failure {{
            background: #f8d7da;
            color: #721c24;
        }}

        .status-ambivalent {{
            background: #fff3cd;
            color: #856404;
        }}

        .clickable {{
            cursor: pointer;
            color: #2980b9;
            text-decoration: underline;
        }}

        .clickable:hover {{
            color: #1e5c96;
        }}

        .detail-view {{
            margin-top: 2rem;
        }}

        .detail-header {{
            border-bottom: 2px solid #2c3e50;
            padding-bottom: 1rem;
            margin-bottom: 1.5rem;
        }}

        .detail-header h2 {{
            color: #2c3e50;
            margin-bottom: 0.5rem;
        }}

        .grid {{
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }}

        .card {{
            background: #f9f9f9;
            padding: 1rem;
            border-radius: 6px;
            border-left: 4px solid #2980b9;
        }}

        .card-label {{
            font-size: 0.8rem;
            font-weight: 600;
            color: #999;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 0.5rem;
        }}

        .card-value {{
            font-size: 1.1rem;
            font-weight: 500;
            color: #333;
        }}

        .timeline {{
            margin-top: 2rem;
        }}

        .timeline-item {{
            display: flex;
            gap: 1.5rem;
            margin-bottom: 1.5rem;
            padding-bottom: 1.5rem;
            border-bottom: 1px solid #eee;
        }}

        .timeline-marker {{
            min-width: 100px;
            font-weight: 600;
            color: #2980b9;
        }}

        .timeline-content {{
            flex: 1;
        }}

        .timeline-content h4 {{
            margin-bottom: 0.3rem;
            color: #333;
        }}

        .timeline-content p {{
            color: #666;
            font-size: 0.95rem;
        }}

        .no-data {{
            text-align: center;
            padding: 2rem;
            color: #999;
            font-style: italic;
        }}

        .sort-indicator {{
            margin-left: 0.5rem;
            opacity: 0.6;
        }}

        @media (max-width: 768px) {{
            header h1 {{
                font-size: 1.5rem;
            }}

            .nav-tabs {{
                flex-wrap: wrap;
            }}

            .nav-tabs button {{
                flex: 0 0 50%;
            }}

            .filters {{
                grid-template-columns: 1fr;
            }}

            table {{
                font-size: 0.9rem;
            }}

            th, td {{
                padding: 0.5rem;
            }}

            .grid {{
                grid-template-columns: 1fr;
            }}
        }}
    </style>
</head>
<body>
    <div x-data="app()" x-init="init()">
        <header>
            <h1>📊 Junior-Mining DB</h1>
            <p>Interactive Database Viewer — Daten von {{{{ companies.length }}}} Companies, {{{{ persons.length }}}} Personen</p>
        </header>

        <nav>
            <div class="nav-tabs">
                <button @click="activeTab = 'overview'" :class="{{active: activeTab === 'overview'}}">
                    Overview
                </button>
                <button @click="activeTab = 'detail'" :class="{{active: activeTab === 'detail'}}">
                    Company-Detail
                </button>
                <button @click="activeTab = 'persons'" :class="{{active: activeTab === 'persons'}}">
                    Personen
                </button>
                <button @click="activeTab = 'crosslinks'" :class="{{active: activeTab === 'crosslinks'}}">
                    Cross-Links
                </button>
            </div>
        </nav>

        <div class="container">
            <!-- ===== OVERVIEW TAB ===== -->
            <div class="section" :class="{{active: activeTab === 'overview'}}">
                <h2>Companies Übersicht</h2>

                <div class="filters">
                    <div class="filter-group">
                        <label>Status</label>
                        <select x-model="filters.status">
                            <option value="">Alle</option>
                            <option value="success">Success</option>
                            <option value="failure">Failure</option>
                            <option value="ambivalent">Ambivalent</option>
                        </select>
                    </div>

                    <div class="filter-group">
                        <label>Commodity</label>
                        <input type="text" x-model="filters.commodity" placeholder="z.B. Gold">
                    </div>

                    <div class="filter-group">
                        <label>Land</label>
                        <input type="text" x-model="filters.country" placeholder="z.B. Canada">
                    </div>

                    <div class="filter-group">
                        <label>Exit Year</label>
                        <input type="number" x-model.number="filters.exitYear" placeholder="z.B. 2020">
                    </div>
                </div>

                <table>
                    <thead>
                        <tr>
                            <th @click="sort('name')">Name <span class="sort-indicator" x-show="sortField === 'name'">{{{{ sortDir === 'asc' ? '▲' : '▼' }}}}</span></th>
                            <th @click="sort('success_label')">Status</th>
                            <th @click="sort('total_score')">Score <span class="sort-indicator" x-show="sortField === 'total_score'">{{{{ sortDir === 'asc' ? '▲' : '▼' }}}}</span></th>
                            <th>Primary Commodity</th>
                            <th @click="sort('country')">Country</th>
                            <th @click="sort('exit_year')">Exit Year</th>
                            <th @click="sort('exit_type')">Exit Type</th>
                        </tr>
                    </thead>
                    <tbody>
                        <template x-for="company in filteredCompanies" :key="company.id">
                            <tr @click="selectCompany(company.id)" class="clickable">
                                <td><strong>{{{{ company.name }}}}</strong></td>
                                <td>
                                    <span class="status-badge" :class="getStatusClass(company.success_label)">
                                        {{{{ company.success_label || 'n/a' }}}}
                                    </span>
                                </td>
                                <td>{{{{ (company.total_score || 0).toFixed(2) }}}}</td>
                                <td>{{{{ company.primary_commodity || '—' }}}}</td>
                                <td>{{{{ company.country || '—' }}}}</td>
                                <td>{{{{ company.exit_year || '—' }}}}</td>
                                <td>{{{{ company.exit_type || '—' }}}}</td>
                            </tr>
                        </template>
                    </tbody>
                </table>

                <div x-show="filteredCompanies.length === 0" class="no-data">
                    Keine Companies gefunden.
                </div>
            </div>

            <!-- ===== COMPANY-DETAIL TAB ===== -->
            <div class="section" :class="{{active: activeTab === 'detail'}}">
                <template x-if="selectedCompany">
                    <div class="detail-view">
                        <div class="detail-header">
                            <h2>{{{{ selectedCompany.name }}}}</h2>
                            <p>ISIN: <strong>{{{{ selectedCompany.isin }}}}</strong> | Listed: <strong>{{{{ selectedCompany.listing_year }}}}</strong></p>
                        </div>

                        <h3>Outcome & Scores</h3>
                        <div class="grid">
                            <div class="card">
                                <div class="card-label">Total Score</div>
                                <div class="card-value">{{{{ (selectedCompany.total_score || 0).toFixed(2) }}}}</div>
                            </div>
                            <div class="card">
                                <div class="card-label">Discovery Score</div>
                                <div class="card-value">{{{{ (selectedCompany.discovery_score || 0).toFixed(2) }}}}</div>
                            </div>
                            <div class="card">
                                <div class="card-label">Reserve Conversion</div>
                                <div class="card-value">{{{{ (selectedCompany.reserve_conversion_score || 0).toFixed(2) }}}}</div>
                            </div>
                            <div class="card">
                                <div class="card-label">Exit Production</div>
                                <div class="card-value">{{{{ (selectedCompany.exit_production_score || 0).toFixed(2) }}}}</div>
                            </div>
                            <div class="card">
                                <div class="card-label">Peak Marketcap (CAD M)</div>
                                <div class="card-value">{{{{ (selectedCompany.peak_marketcap_cad_million || 0).toFixed(0) }}}}</div>
                            </div>
                            <div class="card">
                                <div class="card-label">Exit Type</div>
                                <div class="card-value">{{{{ selectedCompany.exit_type || '—' }}}}</div>
                            </div>
                        </div>

                        <h3 style="margin-top: 2rem;">Personen & Rollen</h3>
                        <div x-show="getCompanyPersons(selectedCompany.id).length > 0">
                            <table>
                                <thead>
                                    <tr>
                                        <th>Name</th>
                                        <th>Role Type</th>
                                        <th>Start Date</th>
                                        <th>End Date</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <template x-for="person in getCompanyPersons(selectedCompany.id)" :key="person.id">
                                        <tr>
                                            <td><strong>{{{{ person.vorname }}}} {{{{ person.nachname }}}}</strong></td>
                                            <td>{{{{ person.role_type }}}}</td>
                                            <td>{{{{ person.start_date || '—' }}}}</td>
                                            <td>{{{{ person.end_date || '—' }}}}</td>
                                        </tr>
                                    </template>
                                </tbody>
                            </table>
                        </div>
                        <div x-show="getCompanyPersons(selectedCompany.id).length === 0" class="no-data">
                            Keine Personen zugeordnet.
                        </div>

                        <h3 style="margin-top: 2rem;">Projekte</h3>
                        <div x-show="getCompanyProjects(selectedCompany.id).length > 0">
                            <table>
                                <thead>
                                    <tr>
                                        <th>Projekt Name</th>
                                        <th>Jurisdiction</th>
                                        <th>Commodity</th>
                                        <th>Stage</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <template x-for="project in getCompanyProjects(selectedCompany.id)" :key="project.id">
                                        <tr>
                                            <td><strong>{{{{ project.name }}}}</strong></td>
                                            <td>{{{{ project.jurisdiction || '—' }}}}</td>
                                            <td>{{{{ project.primary_commodity || '—' }}}}</td>
                                            <td>{{{{ project.peak_stage || '—' }}}}</td>
                                        </tr>
                                    </template>
                                </tbody>
                            </table>
                        </div>
                        <div x-show="getCompanyProjects(selectedCompany.id).length === 0" class="no-data">
                            Keine Projekte gefunden.
                        </div>

                        <h3 style="margin-top: 2rem;">Event Timeline</h3>
                        <div class="timeline">
                            <template x-for="event in getCompanyEvents(selectedCompany.id)" :key="event.id">
                                <div class="timeline-item">
                                    <div class="timeline-marker">{{{{ event.event_date || '—' }}}}</div>
                                    <div class="timeline-content">
                                        <h4>{{{{ event.event_type }}}}</h4>
                                        <p>{{{{ event.description || '(keine Beschreibung)' }}}}</p>
                                    </div>
                                </div>
                            </template>
                        </div>
                        <div x-show="getCompanyEvents(selectedCompany.id).length === 0" class="no-data">
                            Keine Events gefunden.
                        </div>
                    </div>
                </template>

                <template x-if="!selectedCompany">
                    <div class="no-data">
                        Bitte wählen Sie eine Company aus der Overview-Tabelle.
                    </div>
                </template>
            </div>

            <!-- ===== PERSONS TAB ===== -->
            <div class="section" :class="{{active: activeTab === 'persons'}}">
                <h2>Personen & Karriere-Pfade</h2>

                <div class="filters">
                    <div class="filter-group">
                        <label>Name (Nachname)</label>
                        <input type="text" x-model="filters.personName" placeholder="z.B. O'Dea">
                    </div>
                </div>

                <table>
                    <thead>
                        <tr>
                            <th @click="sortPersons('nachname')">Name <span class="sort-indicator" x-show="sortFieldPersons === 'nachname'">{{{{ sortDirPersons === 'asc' ? '▲' : '▼' }}}}</span></th>
                            <th @click="sortPersons('birth_year')">Birth Year</th>
                            <th @click="sortPersons('country')">Country</th>
                            <th @click="sortPersons('companies_count')">Companies <span class="sort-indicator" x-show="sortFieldPersons === 'companies_count'">{{{{ sortDirPersons === 'asc' ? '▲' : '▼' }}}}</span></th>
                        </tr>
                    </thead>
                    <tbody>
                        <template x-for="person in filteredPersonsWithCounts" :key="person.id">
                            <tr @click="selectPerson(person.id)" class="clickable">
                                <td><strong>{{{{ person.vorname }}}} {{{{ person.nachname }}}}</strong></td>
                                <td>{{{{ person.birth_year || '—' }}}}</td>
                                <td>{{{{ person.country || '—' }}}}</td>
                                <td>{{{{ person.companies_count }}}}</td>
                            </tr>
                        </template>
                    </tbody>
                </table>

                <template x-if="selectedPerson">
                    <div class="detail-view">
                        <div class="detail-header">
                            <h2>{{{{ selectedPerson.vorname }}}} {{{{ selectedPerson.nachname }}}}</h2>
                            <p>Birth: <strong>{{{{ selectedPerson.birth_year || '—' }}}}</strong> | Education: <strong>{{{{ selectedPerson.education || '—' }}}}</strong></p>
                        </div>

                        <h3>Karriere-Pfad</h3>
                        <table>
                            <thead>
                                <tr>
                                    <th>Company</th>
                                    <th>Role</th>
                                    <th>Start</th>
                                    <th>End</th>
                                    <th>Outcome</th>
                                </tr>
                            </thead>
                            <tbody>
                                <template x-for="career in getPersonCareer(selectedPerson.id)" :key="career.role_id">
                                    <tr>
                                        <td><strong>{{{{ career.company_name }}}}</strong></td>
                                        <td>{{{{ career.role_type }}}}</td>
                                        <td>{{{{ career.start_date || '—' }}}}</td>
                                        <td>{{{{ career.end_date || '—' }}}}</td>
                                        <td>
                                            <span class="status-badge" :class="getStatusClass(career.success_label)">
                                                {{{{ career.success_label || '—' }}}}
                                            </span>
                                        </td>
                                    </tr>
                                </template>
                            </tbody>
                        </table>
                    </div>
                </template>
            </div>

            <!-- ===== CROSS-LINKS TAB ===== -->
            <div class="section" :class="{{active: activeTab === 'crosslinks'}}">
                <h2>Serien-Personen & Erfolgs-Pattern</h2>

                <div class="filters">
                    <div class="filter-group">
                        <label>Min. Companies</label>
                        <input type="number" x-model.number="minCompaniesForSerial" placeholder="z.B. 3" value="2">
                    </div>
                </div>

                <table>
                    <thead>
                        <tr>
                            <th>Person</th>
                            <th>Companies</th>
                            <th>Success Count</th>
                            <th>Failure Count</th>
                            <th>Success Rate</th>
                        </tr>
                    </thead>
                    <tbody>
                        <template x-for="person in serialPersons" :key="person.id">
                            <tr>
                                <td><strong>{{{{ person.vorname }}}} {{{{ person.nachname }}}}</strong></td>
                                <td>{{{{ person.companies_count }}}}</td>
                                <td>
                                    <span style="color: green; font-weight: 600;">{{{{ person.success_count }}}}</span>
                                </td>
                                <td>
                                    <span style="color: red; font-weight: 600;">{{{{ person.failure_count }}}}</span>
                                </td>
                                <td>{{{{ (person.success_rate * 100).toFixed(0) }}}}%</td>
                            </tr>
                        </template>
                    </tbody>
                </table>

                <div x-show="serialPersons.length === 0" class="no-data">
                    Keine Serien-Personen gefunden (mit mind. {{{{ minCompaniesForSerial }}}} Companies).
                </div>
            </div>
        </div>
    </div>

    <script>
        const db = {json_data};

        function app() {{
            return {{
                activeTab: 'overview',
                companies: [],
                persons: [],
                projects: [],
                roles: [],
                events: [],
                selectedCompany: null,
                selectedPerson: null,

                filters: {{
                    status: '',
                    commodity: '',
                    country: '',
                    exitYear: null,
                    personName: ''
                }},

                sortField: 'name',
                sortDir: 'asc',
                sortFieldPersons: 'companies_count',
                sortDirPersons: 'desc',
                minCompaniesForSerial: 2,

                init() {{
                    this.companies = db.companies;
                    this.persons = db.persons;
                    this.projects = db.projects;
                    this.roles = db.roles;
                    this.events = db.events;
                }}

                get filteredCompanies() {{
                    let filtered = this.companies;

                    if (this.filters.status) {{
                        filtered = filtered.filter(c => c.success_label === this.filters.status);
                    }}
                    if (this.filters.commodity) {{
                        filtered = filtered.filter(c =>
                            (c.primary_commodity?.includes(this.filters.commodity)) ||
                            (c.commodity_2?.includes(this.filters.commodity)) ||
                            (c.commodity_3?.includes(this.filters.commodity))
                        );
                    }}
                    if (this.filters.country) {{
                        filtered = filtered.filter(c => c.country?.includes(this.filters.country));
                    }}
                    if (this.filters.exitYear) {{
                        filtered = filtered.filter(c => c.exit_year === this.filters.exitYear);
                    }}

                    // Sort
                    filtered.sort((a, b) => {{
                        let aVal = a[this.sortField];
                        let bVal = b[this.sortField];

                        if (aVal == null) aVal = '';
                        if (bVal == null) bVal = '';

                        if (typeof aVal === 'string') {{
                            aVal = aVal.toLowerCase();
                            bVal = bVal.toLowerCase();
                        }}

                        if (aVal < bVal) return this.sortDir === 'asc' ? -1 : 1;
                        if (aVal > bVal) return this.sortDir === 'asc' ? 1 : -1;
                        return 0;
                    }});

                    return filtered;
                }}

                get filteredPersonsWithCounts() {{
                    let filtered = this.persons.map(p => ({{
                        ...p,
                        companies_count: this.getCompanyPersons(p.id).length,
                        companies_count_for_career: this.getPersonCareer(p.id).map(c => c.company_id)
                    }}));

                    if (this.filters.personName) {{
                        filtered = filtered.filter(p =>
                            p.nachname.toLowerCase().includes(this.filters.personName.toLowerCase())
                        );
                    }}

                    // Sort
                    filtered.sort((a, b) => {{
                        let aVal = a[this.sortFieldPersons];
                        let bVal = b[this.sortFieldPersons];

                        if (aVal == null) aVal = '';
                        if (bVal == null) bVal = '';

                        if (typeof aVal === 'string') {{
                            aVal = aVal.toLowerCase();
                            bVal = bVal.toLowerCase();
                        }}

                        if (aVal < bVal) return this.sortDirPersons === 'asc' ? -1 : 1;
                        if (aVal > bVal) return this.sortDirPersons === 'asc' ? 1 : -1;
                        return 0;
                    }});

                    return filtered;
                }}

                get serialPersons() {{
                    return this.filteredPersonsWithCounts
                        .filter(p => {{
                            const career = this.getPersonCareer(p.id);
                            return career.length >= this.minCompaniesForSerial;
                        }})
                        .map(p => {{
                            const career = this.getPersonCareer(p.id);
                            const successCount = career.filter(c => c.success_label === 'success').length;
                            const failureCount = career.filter(c => c.success_label === 'failure').length;
                            return {{
                                ...p,
                                companies_count: career.length,
                                success_count: successCount,
                                failure_count: failureCount,
                                success_rate: career.length > 0 ? successCount / career.length : 0
                            }};
                        }})
                        .sort((a, b) => b.success_rate - a.success_rate);
                }}

                sort(field) {{
                    if (this.sortField === field) {{
                        this.sortDir = this.sortDir === 'asc' ? 'desc' : 'asc';
                    }} else {{
                        this.sortField = field;
                        this.sortDir = 'asc';
                    }}
                }}

                sortPersons(field) {{
                    if (this.sortFieldPersons === field) {{
                        this.sortDirPersons = this.sortDirPersons === 'asc' ? 'desc' : 'asc';
                    }} else {{
                        this.sortFieldPersons = field;
                        this.sortDirPersons = 'desc';
                    }}
                }}

                selectCompany(id) {{
                    this.selectedCompany = this.companies.find(c => c.id === id) || null;
                    this.activeTab = 'detail';
                }}

                selectPerson(id) {{
                    this.selectedPerson = this.persons.find(p => p.id === id) || null;
                }}

                getCompanyPersons(companyId) {{
                    const roles = this.roles.filter(r => r.company_id === companyId);
                    return roles.map(r => {{
                        const person = this.persons.find(p => p.id === r.person_id);
                        return {{
                            ...person,
                            role_type: r.role_type,
                            start_date: r.start_date,
                            end_date: r.end_date,
                            id: r.id
                        }};
                    }});
                }}

                getCompanyProjects(companyId) {{
                    return this.projects.filter(p => p.company_id === companyId);
                }}

                getCompanyEvents(companyId) {{
                    return this.events.filter(e => e.company_id === companyId).sort((a, b) => {{
                        if (!a.event_date) return 1;
                        if (!b.event_date) return -1;
                        return a.event_date.localeCompare(b.event_date);
                    }});
                }}

                getPersonCareer(personId) {{
                    const roles = this.roles.filter(r => r.person_id === personId);
                    return roles.map(r => {{
                        const company = this.companies.find(c => c.id === r.company_id);
                        return {{
                            role_id: r.id,
                            company_id: company?.id,
                            company_name: company?.name,
                            role_type: r.role_type,
                            start_date: r.start_date,
                            end_date: r.end_date,
                            success_label: company?.success_label
                        }};
                    }});
                }}

                getStatusClass(status) {{
                    if (!status) return '';
                    if (status === 'success') return 'status-success';
                    if (status === 'failure') return 'status-failure';
                    if (status === 'ambivalent') return 'status-ambivalent';
                    return '';
                }}
            }};
        }}
    </script>
</body>
</html>
"""
    return html


def main():
    print("🔨 Building HTML Viewer...")

    # Read DB
    print(f"  📖 Reading database from {DB_PATH}")
    data = read_db()
    print(f"    ✓ {len(data['companies'])} companies")
    print(f"    ✓ {len(data['persons'])} persons")
    print(f"    ✓ {len(data['projects'])} projects")
    print(f"    ✓ {len(data['roles'])} roles")
    print(f"    ✓ {len(data['events'])} events")

    # Build HTML
    print("  🎨 Generating HTML...")
    html = build_html(data)

    # Write output
    OUTPUT_PATH.parent.mkdir(parents=True, exist_ok=True)
    with open(OUTPUT_PATH, 'w', encoding='utf-8') as f:
        f.write(html)

    file_size = OUTPUT_PATH.stat().st_size / 1024
    print(f"  ✓ Wrote {OUTPUT_PATH}")
    print(f"    Size: {file_size:.1f} KB")
    print("\n✅ Done! Open docs/index.html in your browser.")


if __name__ == '__main__':
    main()
