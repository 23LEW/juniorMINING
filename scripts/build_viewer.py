#!/usr/bin/env python3
"""
build_viewer.py — Generiert docs/index.html aus data/junior_mining.db
Embedding aller Daten als JSON, keine Runtime-DB-Verbindung.
"""

import sqlite3
import json
import os
from pathlib import Path
from html import escape

REPO_ROOT = Path(__file__).parent.parent
DB_PATH = REPO_ROOT / "data" / "junior_mining.db"
OUTPUT_PATH = REPO_ROOT / "docs" / "index.html"


def read_db():
    """Liest alle Tabellen aus der Datenbank."""
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    cursor = conn.cursor()

    data = {}

    cursor.execute("""
        SELECT c.*, o.discovery_score, o.reserve_conversion_score,
               o.exit_production_score, o.peak_marketcap_score, o.total_score,
               o.exit_type, o.exit_year, o.peak_marketcap_cad_million
        FROM company c
        LEFT JOIN outcome o ON c.id = o.company_id
    """)
    data["companies"] = [dict(row) for row in cursor.fetchall()]

    cursor.execute("SELECT * FROM person ORDER BY nachname, vorname")
    data["persons"] = [dict(row) for row in cursor.fetchall()]

    cursor.execute("SELECT * FROM project")
    data["projects"] = [dict(row) for row in cursor.fetchall()]

    cursor.execute("SELECT * FROM role")
    data["roles"] = [dict(row) for row in cursor.fetchall()]

    cursor.execute("SELECT * FROM event ORDER BY company_id, event_date")
    data["events"] = [dict(row) for row in cursor.fetchall()]

    conn.close()
    return data


def build_html(data):
    """Generiert HTML mit embedded JSON."""
    json_data = json.dumps(data, ensure_ascii=False)

    html = f"""<!DOCTYPE html>
<html lang="de">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Junior-Mining DB — Viewer</title>
    <script src="https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js"></script>
    <style>
        * {{ margin: 0; padding: 0; box-sizing: border-box; }}
        body {{ font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif; background: #f5f5f5; color: #333; }}
        header {{ background: linear-gradient(135deg, #2c3e50, #34495e); color: white; padding: 2rem; text-align: center; }}
        header h1 {{ font-size: 2rem; margin-bottom: 0.5rem; }}
        nav {{ background: white; border-bottom: 1px solid #ddd; }}
        .nav-tabs {{ display: flex; max-width: 1200px; margin: 0 auto; }}
        .nav-tabs button {{ flex: 1; padding: 1rem; border: none; background: none; cursor: pointer; font-weight: 500; border-bottom: 3px solid transparent; transition: all 0.3s; color: #666; }}
        .nav-tabs button.active {{ color: #2980b9; border-bottom-color: #2980b9; }}
        .container {{ max-width: 1200px; margin: 2rem auto; padding: 0 1rem; }}
        .section {{ display: none; background: white; border-radius: 8px; padding: 2rem; box-shadow: 0 2px 8px rgba(0,0,0,0.1); }}
        .section.active {{ display: block; }}
        .filters {{ background: #f9f9f9; padding: 1.5rem; border-radius: 6px; margin-bottom: 2rem; display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 1rem; }}
        .filter-group label {{ display: block; font-size: 0.85rem; font-weight: 600; color: #666; margin-bottom: 0.5rem; text-transform: uppercase; }}
        .filter-group input, .filter-group select {{ width: 100%; padding: 0.75rem; border: 1px solid #ddd; border-radius: 4px; font-size: 0.95rem; }}
        table {{ width: 100%; border-collapse: collapse; margin-top: 1rem; }}
        thead {{ background: #f5f5f5; border-bottom: 2px solid #ddd; }}
        th {{ padding: 1rem; text-align: left; font-weight: 600; cursor: pointer; }}
        th:hover {{ background: #eee; }}
        td {{ padding: 0.75rem 1rem; border-bottom: 1px solid #eee; }}
        tr:hover {{ background: #fafafa; }}
        .badge {{ display: inline-block; padding: 0.35rem 0.75rem; border-radius: 20px; font-size: 0.85rem; font-weight: 600; }}
        .badge-success {{ background: #d4edda; color: #155724; }}
        .badge-failure {{ background: #f8d7da; color: #721c24; }}
        .badge-ambivalent {{ background: #fff3cd; color: #856404; }}
        .clickable {{ cursor: pointer; color: #2980b9; text-decoration: underline; }}
        .detail-view {{ margin-top: 2rem; }}
        .detail-header {{ border-bottom: 2px solid #2c3e50; padding-bottom: 1rem; margin-bottom: 1.5rem; }}
        .detail-header h2 {{ color: #2c3e50; margin-bottom: 0.5rem; }}
        .grid {{ display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 1.5rem; margin-bottom: 2rem; }}
        .card {{ background: #f9f9f9; padding: 1rem; border-radius: 6px; border-left: 4px solid #2980b9; }}
        .card-label {{ font-size: 0.8rem; font-weight: 600; color: #999; text-transform: uppercase; margin-bottom: 0.5rem; }}
        .card-value {{ font-size: 1.1rem; font-weight: 500; color: #333; }}
        .no-data {{ text-align: center; padding: 2rem; color: #999; font-style: italic; }}
        @media (max-width: 768px) {{ .nav-tabs button {{ flex: 0 0 50%; }} .filters {{ grid-template-columns: 1fr; }} }}
    </style>
</head>
<body>
    <div x-data="appData()" x-init="init()" x-cloak>
        <header>
            <h1>📊 Junior-Mining DB</h1>
            <p>Interactive Database Viewer</p>
        </header>

        <nav>
            <div class="nav-tabs">
                <button @click="tab='overview'" :class="{{active: tab==='overview'}}">Overview</button>
                <button @click="tab='detail'" :class="{{active: tab==='detail'}}">Company-Detail</button>
                <button @click="tab='persons'" :class="{{active: tab==='persons'}}">Personen</button>
                <button @click="tab='crosslinks'" :class="{{active: tab==='crosslinks'}}">Cross-Links</button>
            </div>
        </nav>

        <div class="container">
            <!-- OVERVIEW -->
            <div class="section" :class="{{active: tab==='overview'}}">
                <h2>Companies</h2>
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
                </div>
                <table>
                    <thead>
                        <tr>
                            <th>Name</th>
                            <th>Status</th>
                            <th>Score</th>
                            <th>Commodity</th>
                            <th>Country</th>
                            <th>Exit Year</th>
                        </tr>
                    </thead>
                    <tbody>
                        <template x-for="c in getFilteredCompanies()" :key="c.id">
                            <tr @click="selectCompany(c); tab='detail'" class="clickable">
                                <td><strong x-text="c.name"></strong></td>
                                <td>
                                    <span class="badge" :class="getBadgeClass(c.success_label)" x-text="c.success_label || '—'"></span>
                                </td>
                                <td x-text="(c.total_score || 0).toFixed(2)"></td>
                                <td x-text="c.primary_commodity || '—'"></td>
                                <td x-text="c.country || '—'"></td>
                                <td x-text="c.exit_year || '—'"></td>
                            </tr>
                        </template>
                    </tbody>
                </table>
            </div>

            <!-- DETAIL -->
            <div class="section" :class="{{active: tab==='detail'}}">
                <template x-if="selectedCompany">
                    <div class="detail-view">
                        <div class="detail-header">
                            <h2 x-text="selectedCompany.name"></h2>
                            <p>Listed: <strong x-text="selectedCompany.listing_year"></strong></p>
                        </div>

                        <h3>Scores</h3>
                        <div class="grid">
                            <div class="card">
                                <div class="card-label">Total Score</div>
                                <div class="card-value" x-text="(selectedCompany.total_score || 0).toFixed(2)"></div>
                            </div>
                            <div class="card">
                                <div class="card-label">Discovery</div>
                                <div class="card-value" x-text="(selectedCompany.discovery_score || 0).toFixed(2)"></div>
                            </div>
                            <div class="card">
                                <div class="card-label">Peak Marketcap (CAD M)</div>
                                <div class="card-value" x-text="(selectedCompany.peak_marketcap_cad_million || 0).toFixed(0)"></div>
                            </div>
                        </div>

                        <h3>Personen</h3>
                        <table>
                            <thead>
                                <tr>
                                    <th>Name</th>
                                    <th>Role</th>
                                    <th>Start</th>
                                    <th>End</th>
                                </tr>
                            </thead>
                            <tbody>
                                <template x-for="p in getCompanyPersons(selectedCompany.id)" :key="p.id">
                                    <tr>
                                        <td x-text="p.vorname + ' ' + p.nachname"></td>
                                        <td x-text="p.role_type"></td>
                                        <td x-text="p.start_date || '—'"></td>
                                        <td x-text="p.end_date || '—'"></td>
                                    </tr>
                                </template>
                            </tbody>
                        </table>

                        <h3 style="margin-top: 2rem;">Projekte</h3>
                        <table>
                            <thead>
                                <tr>
                                    <th>Name</th>
                                    <th>Jurisdiction</th>
                                    <th>Commodity</th>
                                </tr>
                            </thead>
                            <tbody>
                                <template x-for="p in getCompanyProjects(selectedCompany.id)" :key="p.id">
                                    <tr>
                                        <td x-text="p.name"></td>
                                        <td x-text="p.jurisdiction || '—'"></td>
                                        <td x-text="p.primary_commodity || '—'"></td>
                                    </tr>
                                </template>
                            </tbody>
                        </table>
                    </div>
                </template>
                <template x-if="!selectedCompany">
                    <div class="no-data">Wähle eine Company aus der Overview-Tabelle.</div>
                </template>
            </div>

            <!-- PERSONS -->
            <div class="section" :class="{{active: tab==='persons'}}">
                <h2>Personen</h2>
                <table>
                    <thead>
                        <tr>
                            <th>Name</th>
                            <th>Birth Year</th>
                            <th>Country</th>
                            <th>Companies</th>
                        </tr>
                    </thead>
                    <tbody>
                        <template x-for="p in getPersonsList()" :key="p.id">
                            <tr @click="selectPerson(p)" class="clickable">
                                <td x-text="p.vorname + ' ' + p.nachname"></td>
                                <td x-text="p.birth_year || '—'"></td>
                                <td x-text="p.country || '—'"></td>
                                <td x-text="getPersonCareer(p.id).length"></td>
                            </tr>
                        </template>
                    </tbody>
                </table>

                <template x-if="selectedPerson">
                    <div class="detail-view">
                        <div class="detail-header">
                            <h2 x-text="selectedPerson.vorname + ' ' + selectedPerson.nachname"></h2>
                        </div>
                        <h3>Karriere-Pfad</h3>
                        <table>
                            <thead>
                                <tr>
                                    <th>Company</th>
                                    <th>Role</th>
                                    <th>Start</th>
                                    <th>End</th>
                                </tr>
                            </thead>
                            <tbody>
                                <template x-for="c in getPersonCareer(selectedPerson.id)" :key="c.id">
                                    <tr>
                                        <td x-text="c.company_name"></td>
                                        <td x-text="c.role_type"></td>
                                        <td x-text="c.start_date || '—'"></td>
                                        <td x-text="c.end_date || '—'"></td>
                                    </tr>
                                </template>
                            </tbody>
                        </table>
                    </div>
                </template>
            </div>

            <!-- CROSS-LINKS -->
            <div class="section" :class="{{active: tab==='crosslinks'}}">
                <h2>Serien-Personen</h2>
                <table>
                    <thead>
                        <tr>
                            <th>Person</th>
                            <th>Companies</th>
                            <th>Success Count</th>
                        </tr>
                    </thead>
                    <tbody>
                        <template x-for="p in getSerialPersons()" :key="p.id">
                            <tr>
                                <td x-text="p.vorname + ' ' + p.nachname"></td>
                                <td x-text="p.company_count"></td>
                                <td x-text="p.success_count"></td>
                            </tr>
                        </template>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <script>
        const db = {json.dumps(data)};

        function appData() {{
            return {{
                tab: 'overview',
                filters: {{ status: '' }},
                selectedCompany: null,
                selectedPerson: null,

                init() {{}},

                getFilteredCompanies() {{
                    let filtered = db.companies;
                    if (this.filters.status) {{
                        filtered = filtered.filter(c => c.success_label === this.filters.status);
                    }}
                    return filtered;
                }},

                selectCompany(c) {{
                    this.selectedCompany = c;
                }},

                selectPerson(p) {{
                    this.selectedPerson = p;
                }},

                getCompanyPersons(companyId) {{
                    const roles = db.roles.filter(r => r.company_id === companyId);
                    return roles.map(r => {{
                        const person = db.persons.find(p => p.id === r.person_id);
                        return {{ ...person, ...r }};
                    }});
                }},

                getCompanyProjects(companyId) {{
                    return db.projects.filter(p => p.company_id === companyId);
                }},

                getPersonCareer(personId) {{
                    const roles = db.roles.filter(r => r.person_id === personId);
                    return roles.map(r => {{
                        const company = db.companies.find(c => c.id === r.company_id);
                        return {{ ...r, company_name: company?.name, id: r.id }};
                    }});
                }},

                getPersonsList() {{
                    return db.persons.sort((a, b) => {{
                        const ac = this.getPersonCareer(a.id).length;
                        const bc = this.getPersonCareer(b.id).length;
                        return bc - ac;
                    }});
                }},

                getSerialPersons() {{
                    return this.getPersonsList()
                        .filter(p => this.getPersonCareer(p.id).length >= 2)
                        .map(p => {{
                            const career = this.getPersonCareer(p.id);
                            const success = career.filter(c => {{
                                const comp = db.companies.find(x => x.id === c.company_id);
                                return comp?.success_label === 'success';
                            }}).length;
                            return {{ ...p, company_count: career.length, success_count: success }};
                        }});
                }},

                getBadgeClass(status) {{
                    if (status === 'success') return 'badge-success';
                    if (status === 'failure') return 'badge-failure';
                    if (status === 'ambivalent') return 'badge-ambivalent';
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
    print(f"  📖 Reading database from {DB_PATH}")
    data = read_db()
    print(f"    ✓ {len(data['companies'])} companies")
    print(f"    ✓ {len(data['persons'])} persons")

    print("  🎨 Generating HTML...")
    html = build_html(data)

    OUTPUT_PATH.parent.mkdir(parents=True, exist_ok=True)
    with open(OUTPUT_PATH, 'w', encoding='utf-8') as f:
        f.write(html)

    file_size = OUTPUT_PATH.stat().st_size / 1024
    print(f"  ✓ Wrote {OUTPUT_PATH}")
    print(f"    Size: {file_size:.1f} KB")
    print("\n✅ Done!")


if __name__ == '__main__':
    main()
