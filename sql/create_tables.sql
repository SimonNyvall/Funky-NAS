PRAGMA foreign_keys = ON;

CREATE TABLE tags (
  id INTEGER PRIMARY KEY,
  name TEXT
);

CREATE TABLE comments (
  id INTEGER PRIMARY KEY,
  text TEXT
);

CREATE TABLE files (
  id INTEGER PRIMARY KEY,
  name TEXT,
  location TEXT,
  created_at DATETIME,
  updated_at DATETIME,
  is_favorite BOOLEAN,
  comment_id INTEGER,
  FOREIGN KEY(comment_id) REFERENCES comments(id)
);

CREATE TABLE filetags (
  file_id INTEGER,
  tag_id INTEGER,
  PRIMARY KEY(file_id, tag_id),
  FOREIGN KEY(file_id) REFERENCES files(id),
  FOREIGN KEY(tag_id) REFERENCES tags(id)
);
