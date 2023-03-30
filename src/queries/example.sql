-- Retrieve all user names and their email addresses:

SELECT username, email FROM users;

-- Retrieve all user names and their roles:

SELECT username, role FROM users;

-- Retrieve all themes and their primary colors:

SELECT name, primary_color FROM "applications".themes;

-- Retrieve all themes and their font families:

SELECT name, font_family FROM "applications".themes;

-- Retrieve all pages with their respective elements:

SELECT p.name AS page_name, e.name AS element_name
FROM "applications".pages p
JOIN unnest(p.elements) AS e ON true;

-- Retrieve all elements of type "input":

SELECT name, element_config
FROM "applications".elements
WHERE element_type = 'input';

-- Retrieve all external data sources for a PostgreSQL dbms:

SELECT *
FROM "applications".external_data
WHERE dbms = 'postgres';

-- Retrieve all application configurations with their respective themes:

SELECT a.id AS application_id, t.name AS theme_name
FROM "applications".applications_config a
JOIN "applications".themes t ON a.theme = t.id;

-- Retrieve all applications that belong to a specific user:

SELECT name, description, version
FROM applications
WHERE owner = 1;

-- Retrieve all users that belong to a specific user group:

SELECT u.username, g.id AS user_group_id
FROM users u
JOIN user_groups g ON u.id = ANY(g.users)
WHERE g.id = 1;

-- Retrieve all themes that have a font size greater than or equal to 12:

SELECT name, font_size
FROM "applications".themes
WHERE font_size >= 12;

-- Retrieve all pages that have a page config containing a specific key-value pair:

SELECT name, page_config
FROM "applications".pages
WHERE page_config ->> 'key' = 'value';

-- Retrieve all user groups and the number of users they have:

SELECT g.id AS user_group_id, array_length(g.users, 1) AS num_users
FROM user_groups g;

-- Retrieve all external data sources that have a specific table name:

SELECT name, table_name, schema, database
FROM "applications".external_data
WHERE table_name = 'my_table';

-- Retrieve all applications with their respective application metadata and the number of pages they have:

SELECT a.name AS application_name, array_length(am.pages, 1) AS num_pages
FROM applications a
JOIN "applications".applications_metadata am ON a.application_metadata = am.id;

-- Retrieve all users and their respective user groups:

SELECT u.username, g.id AS user_group_id
FROM users u
JOIN user_groups g ON u.id = ANY(g.users);


