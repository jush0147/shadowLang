/// Drift table plan for the persistent SQLite phase.
///
/// The desktop MVP intentionally keeps runtime data in memory so the app can
/// run before Android/iOS permissions, native audio, secure storage, and
/// code-generation plumbing are introduced.
const appDatabaseSchema = '''
CREATE TABLE content_items (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  source_type TEXT NOT NULL,
  source_url TEXT,
  local_file_path TEXT,
  language TEXT NOT NULL,
  target_language TEXT NOT NULL,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL,
  last_position_ms INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE subtitle_segments (
  id TEXT PRIMARY KEY,
  content_id TEXT NOT NULL REFERENCES content_items(id),
  start_ms INTEGER NOT NULL,
  end_ms INTEGER NOT NULL,
  text TEXT NOT NULL,
  translation TEXT NOT NULL,
  token_ids TEXT NOT NULL
);

CREATE TABLE vocabulary_items (
  id TEXT PRIMARY KEY,
  language TEXT NOT NULL,
  text TEXT NOT NULL,
  lemma TEXT NOT NULL,
  translation TEXT NOT NULL,
  part_of_speech TEXT NOT NULL,
  status TEXT NOT NULL,
  seen_count INTEGER NOT NULL DEFAULT 0,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL
);

CREATE TABLE segment_tokens (
  id TEXT PRIMARY KEY,
  segment_id TEXT NOT NULL REFERENCES subtitle_segments(id),
  vocabulary_id TEXT NOT NULL REFERENCES vocabulary_items(id),
  surface_text TEXT NOT NULL,
  start_char INTEGER NOT NULL,
  end_char INTEGER NOT NULL
);

CREATE TABLE shadowing_attempts (
  id TEXT PRIMARY KEY,
  segment_id TEXT NOT NULL REFERENCES subtitle_segments(id),
  recording_path TEXT,
  user_transcript TEXT NOT NULL,
  score INTEGER NOT NULL,
  missing_words_json TEXT NOT NULL,
  extra_words_json TEXT NOT NULL,
  feedback_zh_tw TEXT NOT NULL,
  created_at INTEGER NOT NULL
);

CREATE TABLE app_settings (
  key TEXT PRIMARY KEY,
  value TEXT NOT NULL
);
''';
