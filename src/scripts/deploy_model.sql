-- insert into users
INSERT INTO
  users (id, username, password, email, role)
VALUES
  (
    1,
    'admin',
    'admin_password',
    'admin@example.com',
    'admin'
  ),
  (
    2,
    'user1',
    'user1_password',
    'user1@example.com',
    'user'
  ),
  (
    3,
    'user2',
    'user2_password',
    'user2@example.com',
    'user'
  );

-- insert into user_groups
INSERT INTO
  user_groups (id, users)
VALUES
  (1, '{1, 2}'),
  (2, '{2, 3}');

-- insert into "applications".themes
INSERT INTO
  "applications".themes (
    id,
    name,
    description,
    primary_color,
    secondary_color,
    font_size,
    font_family,
    font_color,
    background_color,
    background_image,
    logo_url
  )
VALUES
  (
    1,
    'Default',
    'The default theme',
    '#ffffff',
    '#000000',
    16,
    'Arial',
    '#000000',
    '#ffffff',
    '',
    ''
  );

-- insert into "applications".pages
INSERT INTO
  "applications".pages (id, name, description, elements, page_config)
VALUES
  (1, 'Home', 'The home page', '{1}', '{}'),
  (2, 'About', 'The about page', '{2}', '{}');

-- insert into "applications".elements
INSERT INTO
  "applications".elements (
    id,
    name,
    description,
    element_type,
    element,
    element_config
  )
VALUES
  (
    1,
    'Text input',
    'A text input field',
    'input',
    'text',
    '{}'
  ),
  (
    2,
    'Header',
    'A header element',
    'field',
    'text',
    '{"text": "Welcome to our site!"}'
  );

-- insert into "applications".external_data
INSERT INTO
  "applications".external_data (
    id,
    name,
    description,
    dbms,
    hostname,
    port,
    username,
    password,
    database,
    schema,
    table_name
  )
VALUES
  (
    1,
    'Customers',
    'Customer data from a PostgreSQL database',
    'postgres',
    'localhost',
    5432,
    'postgres',
    'password',
    'mydatabase',
    'public',
    'customers'
  ),
  (
    2,
    'Orders',
    'Order data from a MySQL database',
    'mysql',
    'localhost',
    3306,
    'root',
    'password',
    'mydatabase',
    'public',
    'orders'
  );

-- insert into "applications".applications_config
INSERT INTO
  "applications".applications_config (id, config, theme, external_data_config)
VALUES
  (1, '{}', 1, 1),
  (2, '{}', 1, 2);

-- insert into "applications".applications_metadata
INSERT INTO
  "applications".applications_metadata (id, pages, application_config)
VALUES
  (1, '{1, 2}', 1),
  (2, '{2}', 2);

-- insert into applications
INSERT INTO
  applications (
    id,
    name,
    description,
    version,
    owner,
    user_group,
    application_metadata
  )
VALUES
  (1, 'MyApp', 'My application', '1.0.0', 1, 1, 1),
  (
    2,
    'YourApp',
    'Your application',
    '1.0.0',
    2,
    2,
    2
  );
