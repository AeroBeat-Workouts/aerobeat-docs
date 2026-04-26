-- This file is a readable example of the local/global workouts.db schema.
-- It is the installed-workout discovery index, not the authored source of truth.
-- In other words: rebuildable local browse data belongs here; canonical package semantics stay in YAML.

PRAGMA foreign_keys = ON;

-- One row per installed workout package.
CREATE TABLE workouts (
  workout_id TEXT PRIMARY KEY,
  workout_name TEXT NOT NULL,
  description TEXT,
  package_version TEXT NOT NULL,
  schema_version INTEGER NOT NULL,
  created_by_tool TEXT,
  created_by_tool_version TEXT,
  coach_config_id TEXT,
  default_coach_name TEXT,
  workout_yaml_path TEXT NOT NULL,
  package_root_path TEXT NOT NULL,
  cover_art_path TEXT,
  installed_at TEXT NOT NULL,
  indexed_at TEXT NOT NULL,
  updated_at TEXT,
  is_installed INTEGER NOT NULL DEFAULT 1,
  is_valid INTEGER NOT NULL DEFAULT 1,
  validation_error TEXT
);

-- Optional lookup metadata for tag-based filters in the local browser.
CREATE TABLE workout_tags (
  workout_id TEXT NOT NULL,
  tag TEXT NOT NULL,
  PRIMARY KEY (workout_id, tag),
  FOREIGN KEY (workout_id) REFERENCES workouts(workout_id) ON DELETE CASCADE
);

-- Mode summary table so the client can filter without reparsing every chart file.
CREATE TABLE workout_modes (
  workout_id TEXT NOT NULL,
  mode TEXT NOT NULL,
  PRIMARY KEY (workout_id, mode),
  FOREIGN KEY (workout_id) REFERENCES workouts(workout_id) ON DELETE CASCADE
);

-- Difficulty summary table for browse filters such as easy/medium/hard.
CREATE TABLE workout_difficulties (
  workout_id TEXT NOT NULL,
  difficulty TEXT NOT NULL,
  PRIMARY KEY (workout_id, difficulty),
  FOREIGN KEY (workout_id) REFERENCES workouts(workout_id) ON DELETE CASCADE
);

-- Lightweight denormalized song summaries for installed workouts.
CREATE TABLE workout_songs (
  workout_id TEXT NOT NULL,
  song_id TEXT NOT NULL,
  song_name TEXT NOT NULL,
  artist_name TEXT,
  duration_ms INTEGER,
  PRIMARY KEY (workout_id, song_id),
  FOREIGN KEY (workout_id) REFERENCES workouts(workout_id) ON DELETE CASCADE
);

-- Optional debug/search table showing which gameplay-facing asset ids are used per entry.
CREATE TABLE workout_assets (
  workout_id TEXT NOT NULL,
  entry_id TEXT NOT NULL,
  asset_type TEXT NOT NULL,
  asset_id TEXT NOT NULL,
  PRIMARY KEY (workout_id, entry_id, asset_type),
  FOREIGN KEY (workout_id) REFERENCES workouts(workout_id) ON DELETE CASCADE
);

-- Typical local indexes for browse performance.
CREATE INDEX idx_workouts_name ON workouts(workout_name);
CREATE INDEX idx_workouts_installed ON workouts(is_installed, is_valid);
CREATE INDEX idx_workout_songs_name ON workout_songs(song_name);
CREATE INDEX idx_workout_tags_tag ON workout_tags(tag);
CREATE INDEX idx_workout_modes_mode ON workout_modes(mode);
CREATE INDEX idx_workout_difficulties_difficulty ON workout_difficulties(difficulty);

-- Important boundary reminder:
-- A future remote catalog DB should be a sibling schema (for example catalog.db),
-- not an exact mirror of this local installed-workout database.
