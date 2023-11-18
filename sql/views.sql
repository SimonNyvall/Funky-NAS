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

