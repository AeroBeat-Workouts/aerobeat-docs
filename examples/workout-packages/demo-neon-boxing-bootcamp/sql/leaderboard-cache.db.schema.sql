-- This file is a readable example of the per-workout leaderboard cache DB.
-- It is local, disposable, and non-authoritative.
-- Deleting it must be safe. Rebuilding it from server responses must be safe.

PRAGMA foreign_keys = ON;

-- Generic metadata about the cache snapshot.
CREATE TABLE cache_meta (
  cache_key TEXT PRIMARY KEY,
  cache_value TEXT NOT NULL
);

-- Cached leaderboard rows for one workout's local leaderboard browser.
CREATE TABLE leaderboard_entries (
  leaderboard_scope TEXT NOT NULL,
  rank INTEGER NOT NULL,
  score_id TEXT NOT NULL,
  player_id TEXT NOT NULL,
  player_name TEXT NOT NULL,
  score INTEGER NOT NULL,
  performance_time_ms INTEGER,
  achieved_at TEXT NOT NULL,
  difficulty TEXT,
  mode TEXT,
  input_profile TEXT,
  is_local_player INTEGER NOT NULL DEFAULT 0,
  PRIMARY KEY (leaderboard_scope, rank, score_id)
);

-- Sync history helps the client decide when to refresh the cache.
CREATE TABLE leaderboard_sync_runs (
  sync_run_id TEXT PRIMARY KEY,
  requested_at TEXT NOT NULL,
  completed_at TEXT,
  status TEXT NOT NULL,
  response_code INTEGER,
  error_text TEXT
);

CREATE INDEX idx_leaderboard_entries_scope_rank
  ON leaderboard_entries(leaderboard_scope, rank);
CREATE INDEX idx_leaderboard_entries_player
  ON leaderboard_entries(player_id, achieved_at);
CREATE INDEX idx_leaderboard_sync_runs_status
  ON leaderboard_sync_runs(status, requested_at);

-- Expected cache_meta keys include:
--   workout_id
--   source_region
--   last_synced_at
--   etag
--   api_schema_version
--
-- This cache should be ignored or stripped during package submission/export.
