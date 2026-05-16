#!/usr/bin/env python3
"""build_viewer.py — Generiert docs/index.html aus data/junior_mining.db"""

import sqlite3
import json
from pathlib import Path

REPO_ROOT = Path(__file__).parent.parent
DB_PATH = REPO_ROOT / "data" / "junior_mining.db"
OUTPUT_PATH = REPO_ROOT / "docs" / "index.html"


def read_db():
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
    json_str = json.dumps(data, ensure_ascii=False)

    html = """<!DOCTYPE html>
<html lang="de">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Junior-Mining DB</title>
    <script defer src="https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js"></script>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif; background: #f5f5f5; color: #333; }
        header { background: linear-gradient(135deg, #2c3e50, #34495e); color: white; padding: 2rem; text-align: center; }
        header h1 { font-size: 2rem; }
        nav { background: white; border-bottom: 1px solid #ddd; }
        .nav-tabs { display: flex; max-width: 1200px; margin: 0 auto; }
        .nav-tabs button { flex: 1; padding: 1rem; border: none; background: none; cursor: pointer; font-weight: 500; border-bottom: 3px solid transparent; color: #666; }
        .nav-tabs button.active { color: #2980b9; border-bottom-color: #2980b9; }
        .container { max-width: 1200px; margin: 2rem auto; padding: 0 1rem; }
        .section { display: none; background: white; border-radius: 8px; padding: 2rem; }
        .section.active { display: block; }
        .filters { background: #f9f9f9; padding: 1.5rem; margin-bottom: 2rem; display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 1rem; }
        .filter-group label { font-size: 0.85rem; font-weight: 600; color: #666; margin-bottom: 0.5rem; }
        .filter-group input, .filter-group select { width: 100%; padding: 0.75rem; border: 1px solid #ddd; border-radius: 4px; }
        table { width: 100%; border-collapse: collapse; margin-top: 1rem; }
        thead { background: #f5f5f5; border-bottom: 2px solid #ddd; }
        th { padding: 1rem; text-align: left; font-weight: 600; cursor: pointer; }
        td { padding: 0.75rem 1rem; border-bottom: 1px solid #eee; }
        tr:hover { background: #fafafa; }
        .badge { display: inline-block; padding: 0.35rem 0.75rem; border-radius: 20px; font-size: 0.85rem; font-weight: 600; }
        .badge-success { background: #d4edda; color: #155724; }
        .badge-failure { background: #f8d7da; color: #721c24; }
        .badge-ambivalent { background: #fff3cd; color: #856404; }
        .clickable { cursor: pointer; color: #2980b9; text-decoration: underline; }
        h3 { margin-top: 2rem; margin-bottom: 1rem; }
        .no-data { text-align: center; padding: 2rem; color: #999; }
    </style>
</head>
<body>
    <div x-data="viewer()" x-init="init()">
        <header>
            <h1>📊 Junior-Mining DB</h1>
            <p>Interactive Database Viewer</p>
        </header>

        <nav>
            <div class="nav-tabs">
                <button @click="currentTab='overview'" :class="{ active: currentTab === 'overview' }">Overview</button>
                <button @click="currentTab='detail'" :class="{ active: currentTab === 'detail' }">Company-Detail</button>
                <button @click="currentTab='persons'" :class="{ active: currentTab === 'persons' }">Personen</button>
                <button @click="currentTab='crosslinks'" :class="{ active: currentTab === 'crosslinks' }">Cross-Links</button>
            </div>
        </nav>

        <div class="container">
            <!-- OVERVIEW -->
            <div class="section" :class="{ active: currentTab === 'overview' }">
                <h2>Companies Overview</h2>
                <div class="filters">
                    <div class="filter-group">
                        <label>Status</label>
                        <select x-model="filterStatus">
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
                        </tr>
                    </thead>
                    <tbody>
                        <template x-for="c in getFilteredCompanies()" :key="c.id">
                            <tr @click="selectCompany(c); currentTab = 'detail'" class="clickable">
                                <td><strong x-text="c.name"></strong></td>
                                <td>
                                    <span class="badge" :class="getBadgeClass(c.success_label)"
                                          x-text="c.success_label || '—'"></span>
                                </td>
                                <td x-text="(c.total_score || 0).toFixed(2)"></td>
                                <td x-text="c.primary_commodity || '—'"></td>
                                <td x-text="c.country || '—'"></td>
                            </tr>
                        </template>
                    </tbody>
                </table>
            </div>

            <!-- DETAIL -->
            <div class="section" :class="{ active: currentTab === 'detail' }">
                <template x-if="selectedCompany">
                    <div>
                        <h2 x-text="selectedCompany.name"></h2>
                        <p style="color: #666; margin: 1rem 0;">Listed: <strong x-text="selectedCompany.listing_year"></strong></p>

                        <h3>Personen & Rollen</h3>
                        <table>
                            <thead>
                                <tr><th>Name</th><th>Role</th><th>Start</th><th>End</th></tr>
                            </thead>
                            <tbody>
                                <template x-for="p in getCompanyPersons()" :key="p.id">
                                    <tr>
                                        <td x-text="p.vorname + ' ' + p.nachname"></td>
                                        <td x-text="p.role_type"></td>
                                        <td x-text="p.start_date || '—'"></td>
                                        <td x-text="p.end_date || '—'"></td>
                                    </tr>
                                </template>
                            </tbody>
                        </table>

                        <h3>Projekte</h3>
                        <table>
                            <thead>
                                <tr><th>Name</th><th>Jurisdiction</th><th>Commodity</th></tr>
                            </thead>
                            <tbody>
                                <template x-for="p in getCompanyProjects()" :key="p.id">
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
                    <div class="no-data">Wähle eine Company aus Overview.</div>
                </template>
            </div>

            <!-- PERSONS -->
            <div class="section" :class="{ active: currentTab === 'persons' }">
                <h2>Personen</h2>
                <table>
                    <thead>
                        <tr><th>Name</th><th>Birth</th><th>Country</th><th>Companies</th></tr>
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
                    <div style="margin-top: 2rem;">
                        <h3 x-text="selectedPerson.vorname + ' ' + selectedPerson.nachname"></h3>
                        <table>
                            <thead>
                                <tr><th>Company</th><th>Role</th><th>Start</th><th>End</th></tr>
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
            <div class="section" :class="{ active: currentTab === 'crosslinks' }">
                <h2>Serien-Personen</h2>
                <table>
                    <thead>
                        <tr><th>Person</th><th>Companies</th><th>Success Count</th></tr>
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
        window.DB = """ + json_str + """;

        function viewer() {
            return {
                currentTab: 'overview',
                filterStatus: '',
                selectedCompany: null,
                selectedPerson: null,

                init() {},

                getFilteredCompanies() {
                    let result = window.DB.companies;
                    if (this.filterStatus) {
                        result = result.filter(c => c.success_label === this.filterStatus);
                    }
                    return result;
                },

                selectCompany(c) {
                    this.selectedCompany = c;
                },

                selectPerson(p) {
                    this.selectedPerson = p;
                },

                getCompanyPersons() {
                    if (!this.selectedCompany) return [];
                    const roles = window.DB.roles.filter(r => r.company_id === this.selectedCompany.id);
                    return roles.map(r => {
                        const person = window.DB.persons.find(p => p.id === r.person_id);
                        return { ...person, ...r };
                    });
                },

                getCompanyProjects() {
                    if (!this.selectedCompany) return [];
                    return window.DB.projects.filter(p => p.company_id === this.selectedCompany.id);
                },

                getPersonCareer(personId) {
                    const roles = window.DB.roles.filter(r => r.person_id === personId);
                    return roles.map(r => {
                        const company = window.DB.companies.find(c => c.id === r.company_id);
                        return { ...r, company_name: company?.name };
                    });
                },

                getPersonsList() {
                    return window.DB.persons.sort((a, b) => {
                        const ac = this.getPersonCareer(a.id).length;
                        const bc = this.getPersonCareer(b.id).length;
                        return bc - ac;
                    });
                },

                getSerialPersons() {
                    return this.getPersonsList()
                        .filter(p => this.getPersonCareer(p.id).length >= 2)
                        .map(p => {
                            const career = this.getPersonCareer(p.id);
                            const success = career.filter(c => {
                                const comp = window.DB.companies.find(x => x.id === c.company_id);
                                return comp?.success_label === 'success';
                            }).length;
                            return { ...p, company_count: career.length, success_count: success };
                        });
                },

                getBadgeClass(status) {
                    if (status === 'success') return 'badge-success';
                    if (status === 'failure') return 'badge-failure';
                    if (status === 'ambivalent') return 'badge-ambivalent';
                    return '';
                }
            };
        }
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
    print(f"    Size: {file_size:.1f} KB\n✅ Done!")


if __name__ == '__main__':
    main()
