-- This file documents AeroBeat's shared catalog schema direction.
-- The core browse tables are shared by both local and remote catalog databases.
-- A local installed-workout DB uses the core tables plus workout_local.
-- A remote/distribution catalog DB uses the same core tables plus workout_remote.
-- Canonical authored package semantics still live in YAML, not SQLite.

PRAGMA foreign_keys = ON;

-- One row per workout known to the catalog.
CREATE TABLE workouts (
  workout_id TEXT PRIMARY KEY,
  workout_name TEXT NOT NULL,
  description TEXT,
  package_version TEXT NOT NULL,
  schema_version INTEGER NOT NULL,
  created_by_tool TEXT,
  created_by_tool_version TEXT,
  coach_config_id TEXT,
  duration_ms INTEGER,
  CHECK (duration_ms IS NULL OR duration_ms >= 0)
);

-- Optional lookup metadata for tag-based filters.
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

-- Difficulty summary table for browse filters.
CREATE TABLE workout_difficulties (
  workout_id TEXT NOT NULL,
  difficulty TEXT NOT NULL CHECK (difficulty IN ('easy', 'medium', 'hard', 'pro')),
  PRIMARY KEY (workout_id, difficulty),
  FOREIGN KEY (workout_id) REFERENCES workouts(workout_id) ON DELETE CASCADE
);

-- Lightweight denormalized song summaries for workout browsing.
CREATE TABLE workout_songs (
  workout_id TEXT NOT NULL,
  song_id TEXT NOT NULL,
  song_name TEXT NOT NULL,
  artist_name TEXT,
  duration_ms INTEGER,
  PRIMARY KEY (workout_id, song_id),
  FOREIGN KEY (workout_id) REFERENCES workouts(workout_id) ON DELETE CASCADE,
  CHECK (duration_ms IS NULL OR duration_ms >= 0)
);

-- Zero or more coaches derived from the package coach config.
-- If coaching is disabled, this table must have zero rows for the workout.
CREATE TABLE workout_coaches (
  workout_id TEXT NOT NULL,
  coach_id TEXT NOT NULL,
  coach_name TEXT NOT NULL,
  PRIMARY KEY (workout_id, coach_id),
  FOREIGN KEY (workout_id) REFERENCES workouts(workout_id) ON DELETE CASCADE
);

-- Workout genres are the union of the authored song genres referenced by the workout.
-- Validators/indexers must not invent genres; they only copy approved authored values.
CREATE TABLE workout_genres (
  workout_id TEXT NOT NULL,
  genre TEXT NOT NULL CHECK (genre IN (
    'pop', 'rock', 'hip_hop', 'r_and_b', 'edm', 'country', 'latin', 'jazz',
    'blues', 'funk', 'soul', 'reggae', 'folk', 'classical', 'metal', 'punk',
    'world', 'soundtrack', 'holiday', 'game', 'chiptune', 'anime'
  )),
  PRIMARY KEY (workout_id, genre),
  FOREIGN KEY (workout_id) REFERENCES workouts(workout_id) ON DELETE CASCADE
);

-- Local installed-workout companion data.
CREATE TABLE workout_local (
  workout_id TEXT PRIMARY KEY,
  workout_yaml_path TEXT NOT NULL,
  package_root_path TEXT NOT NULL,
  installed_at TEXT NOT NULL,
  indexed_at TEXT NOT NULL,
  updated_at TEXT,
  is_installed INTEGER NOT NULL DEFAULT 1,
  is_valid INTEGER NOT NULL DEFAULT 1,
  validation_error TEXT,
  FOREIGN KEY (workout_id) REFERENCES workouts(workout_id) ON DELETE CASCADE,
  CHECK (is_installed IN (0, 1)),
  CHECK (is_valid IN (0, 1))
);

-- Remote/distribution catalog companion data.
CREATE TABLE workout_remote (
  workout_id TEXT PRIMARY KEY,
  preview_image_strategy TEXT NOT NULL CHECK (preview_image_strategy IN ('direct_url', 'api_resolve')),
  preview_image_url TEXT,
  FOREIGN KEY (workout_id) REFERENCES workouts(workout_id) ON DELETE CASCADE,
  CHECK (
    (preview_image_strategy = 'direct_url' AND preview_image_url IS NOT NULL AND preview_image_url <> '') OR
    (preview_image_strategy = 'api_resolve')
  )
);

-- Typical indexes for browse performance.
CREATE INDEX idx_workouts_name ON workouts(workout_name);
CREATE INDEX idx_workout_tags_tag ON workout_tags(tag);
CREATE INDEX idx_workout_modes_mode ON workout_modes(mode);
CREATE INDEX idx_workout_difficulties_difficulty ON workout_difficulties(difficulty);
CREATE INDEX idx_workout_songs_name ON workout_songs(song_name);
CREATE INDEX idx_workout_coaches_name ON workout_coaches(coach_name);
CREATE INDEX idx_workout_genres_genre ON workout_genres(genre);
CREATE INDEX idx_workout_local_installed_valid ON workout_local(is_installed, is_valid);
CREATE INDEX idx_workout_remote_preview_strategy ON workout_remote(preview_image_strategy);
