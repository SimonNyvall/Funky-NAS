-- Create tables
CREATE TABLE tags (
  id SERIAL PRIMARY KEY,
  name TEXT
);

CREATE TABLE comments (
  id SERIAL PRIMARY KEY,
  text TEXT
);

CREATE TABLE files (
  id SERIAL PRIMARY KEY,
  name TEXT,
  location TEXT,
  created_at TIMESTAMP,
  updated_at TIMESTAMP,
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


-- Create views
CREATE VIEW viewAll AS
SELECT 
    f.*, 
    c.text AS comment_text, 
    t.name AS tag_name
FROM 
    files f
LEFT JOIN comments c ON f.comment_id = c.id
LEFT JOIN filetags ft ON f.id = ft.file_id
LEFT JOIN tags t ON ft.tag_id = t.id;


-- Create functions
CREATE FUNCTION get_files_by_tag(tag_name TEXT)
RETURNS TABLE (file_id INTEGER, file_name TEXT) as $$
BEGIN
  RETURN QUERY SELECT f.id, f.name FROM files f 
               JOIN filetags ft ON f.id = ft.file_id
               JOIN tags t ON ft.tag_id = t.id
               WHERE t.name = tag_name;
END;
$$ LANGUAGE plpgsql;


CREATE FUNCTION get_files_by_comment(comment_text TEXT)
RETURNS TABLE (file_id INTEGER, file_name TEXT) as $$
BEGIN
  RETURN QUERY SELECT f.id, f.name FROM files f
               JOIN comments c ON f.comment_id = c.id
               WHERE c.text ILIKE comment_text;
END;
$$ LANGUAGE plpgsql;


CREATE FUNCTION get_files_inbetween_dates(start_date DATE, end_date DATE)
RETURNS TABLE (file_id INTEGER, file_name TEXT) as $$
BEGIN
  RETURN QUERY SELECT f.id, f.name FROM files f
               WHERE f.created_at BETWEEN start_date AND end_date;
END;


-- Create stored procedures
CREATE PROCEDURE add_file(name TEXT, location TEXT, created_at TIMESTAMP, updated_at TIMESTAMP, is_favorite BOOLEAN, comment_id INTEGER)
AS $$
BEGIN
  INSERT INTO files (name, location, created_at, updated_at, is_favorite, comment_id)
  VALUES (name, location, created_at, updated_at, is_favorite, comment_id);
END;


CREATE PROCEDURE add_comment(text TEXT)
AS $$
BEGIN
  INSERT INTO comments (text)
  VALUES (text);
END;


CREATE PROCEDURE add_tag(name TEXT)
AS $$
BEGIN
  INSERT INTO tags (name)
  VALUES (name);
END;


CREATE PROCEDURE add_filetag(file_id INTEGER, tag_id INTEGER)
AS $$
BEGIN
  INSERT INTO filetags (file_id, tag_id)
  VALUES (file_id, tag_id);
END;


CREATE PROCEDURE update_file(id INTEGER, name TEXT, location TEXT, created_at TIMESTAMP, updated_at TIMESTAMP, is_favorite BOOLEAN, comment_id INTEGER)
AS $$
BEGIN
  UPDATE files
  SET name = name, location = location, created_at = created_at, updated_at = updated_at, is_favorite = is_favorite, comment_id = comment_id
  WHERE id = id;
END;


CREATE PROCEDURE update_comment(id INTEGER, text TEXT)
AS $$
BEGIN
  UPDATE comments
  SET text = text
  WHERE id = id;
END;


CREATE PROCEDURE update_tag(id INTEGER, name TEXT)
AS $$
BEGIN
  UPDATE tags
  SET name = name
  WHERE id = id;
END;


CREATE PROCEDURE update_filetag(file_id INTEGER, tag_id INTEGER)
AS $$
BEGIN
  UPDATE filetags
  SET file_id = file_id, tag_id = tag_id
  WHERE file_id = file_id AND tag_id = tag_id;
END;


CREATE PROCEDURE delete_file(id INTEGER)
AS $$
BEGIN
  DELETE FROM files
  WHERE id = id;
END;


CREATE PROCEDURE delete_comment(id INTEGER)
AS $$
BEGIN
  DELETE FROM comments
  WHERE id = id;
END;


CREATE PROCEDURE delete_tag(id INTEGER)
AS $$
BEGIN
  DELETE FROM tags
  WHERE id = id;
END;


CREATE PROCEDURE delete_filetag(file_id INTEGER, tag_id INTEGER)
AS $$
BEGIN
  DELETE FROM filetags
  WHERE file_id = file_id AND tag_id = tag_id;
END;


-- Create triggers
CREATE TRIGGER update_file_timestamp
BEFORE UPDATE ON files 
FOR EACH ROW EXECUTE PROCEDURE update_timestamp();


CREATE TRIGGER update_comment_timestamp
BEFORE UPDATE ON comments
FOR EACH ROW EXECUTE PROCEDURE update_timestamp();


CREATE TRIGGER update_tag_timestamp
BEFORE UPDATE ON tags
FOR EACH ROW EXECUTE PROCEDURE update_timestamp();

