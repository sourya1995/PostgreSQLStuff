SELECT string_to_array('Hello world', '');
SELECT unnest(string_to_array('Hello world', ' ');

CREATE TABLE docs (id SERIAL, doc TEXT, PRIMARY KEY(id));
INSERT INTO docs (doc) VALUES
('This is SQL and Python and other fun teaching stuff'),
('More people should learn SQL from UMSI'),
('UMSI also teaches Python and also SQL');
SELECT * FROM docs;

SELECT id, s.keyword as keyword
FROM docs as d, unnest(string_to_array(d.doc, ' ')) s(keyword)
ORDER BY id;

SELECT DISTINCT id, s.keyword AS keyword
FROM docs AS D, unnest(string_to_array(D.doc, ' ')) s(keyword)
ORDER BY id;

CREATE TABLE docs_gin (
  keyword TEXT,
  doc_id INTEGER REFERENCES docs(id) ON DELETE CASCADE
);


INSERT INTO docs_gin (doc_id, keyword)
SELECT DISTINCT id, s.keyword AS keyword
FROM docs AS D, unnest(string_to_array(D.doc, ' ')) s(keyword)
ORDER BY id;

SELECT * FROM docs_gin ORDER BY doc_id;

SELECT DISTINCT keyword, doc_id FROM docs_gin AS G
WHERE G.keyword = 'UMSI';

SELECT DISTINCT id, doc FROM docs AS D
JOIN docs_gin AS G ON D.id = G.doc_id
WHERE G.keyword = 'UMSI';

SELECT DISTINCT doc FROM docs AS D
JOIN docs_gin AS G ON D.id = G.doc_id
WHERE G.keyword IN ('fun', 'people');

SELECT DISTINCT doc FROM docs AS D
JOIN docs_gin AS G ON D.id = G.doc_id
WHERE G.keyword = ANY(string_to_array('I want to learn', ' '));

SELECT DISTINCT id, doc FROM docs AS D
JOIN docs_gin AS G ON D.id = G.doc_id
WHERE G.keyword = ANY(string_to_array('Search for Lemons and Neons', ' '));

