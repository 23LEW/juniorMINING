CREATE TABLE IF NOT EXISTS event_sources (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    event_id INTEGER NOT NULL,
    source TEXT NOT NULL,
    url TEXT,
    FOREIGN KEY (event_id) REFERENCES event(id)
);
