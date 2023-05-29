-- type deployment
CREATE TYPE "user_role" AS ENUM ('admin', 'user');

CREATE TYPE "element" AS ENUM ('text', 'number', 'json', 'markdown');

CREATE TYPE "element_type" AS ENUM ('input', 'field');

CREATE TYPE "dbms_type" AS ENUM ('postgres', 'mysql', 'mssql', 'oracle', 'sqlite');

-- schema deployment
CREATE SCHEMA IF NOT EXISTS "applications";

-- table deployment
CREATE TABLE IF NOT EXISTS users (
  id INTEGER PRIMARY KEY NOT NULL,
  username TEXT NOT NULL,
  password TEXT NOT NULL,
  email TEXT NOT NULL,
  role user_role NOT NULL DEFAULT 'user'
);

CREATE TABLE IF NOT EXISTS user_groups (
  id INTEGER PRIMARY KEY NOT NULL,
  users INTEGER [] NOT NULL DEFAULT '{}'
);

CREATE TABLE IF NOT EXISTS "applications".themes (
  id INTEGER PRIMARY KEY NOT NULL,
  name TEXT NOT NULL,
  description TEXT NOT NULL,
  primary_color TEXT NOT NULL,
  secondary_color TEXT NOT NULL,
  font_size INTEGER NOT NULL,
  font_family TEXT NOT NULL,
  font_color TEXT NOT NULL,
  background_color TEXT NOT NULL,
  background_image TEXT NOT NULL,
  logo_url TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS "applications".pages (
  id INTEGER PRIMARY KEY NOT NULL,
  name TEXT NOT NULL,
  description TEXT NOT NULL,
  elements INTEGER [] NOT NULL DEFAULT '{}',
  page_config JSON NOT NULL DEFAULT '{}'
);

CREATE TABLE IF NOT EXISTS "applications".elements (
  id INTEGER PRIMARY KEY NOT NULL,
  name TEXT NOT NULL,
  description TEXT NOT NULL,
  element_type element_type NOT NULL,
  element element NOT NULL,
  element_config JSON NOT NULL DEFAULT '{}'
);

CREATE TABLE IF NOT EXISTS "applications".external_data (
  id INTEGER PRIMARY KEY NOT NULL,
  name TEXT NOT NULL,
  description TEXT NOT NULL,
  dbms dbms_type NOT NULL,
  hostname TEXT NOT NULL,
  port INTEGER NOT NULL,
  username TEXT NOT NULL,
  password TEXT NOT NULL,
  database TEXT NOT NULL,
  schema TEXT NOT NULL,
  table_name TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS "applications".applications_config (
  id INTEGER PRIMARY KEY NOT NULL,
  config JSON NOT NULL DEFAULT '{}',
  theme INTEGER NOT NULL,
  external_data_config INTEGER,
  CONSTRAINT fk_external_data_config FOREIGN KEY (external_data_config) REFERENCES applications.external_data(id),
  CONSTRAINT fk_theme FOREIGN KEY (theme) REFERENCES applications.themes(id)
);

CREATE TABLE IF NOT EXISTS "applications".applications_metadata (
  id INTEGER PRIMARY KEY NOT NULL,
  pages INTEGER [] NOT NULL DEFAULT '{}',
  application_config INTEGER NOT NULL,
  CONSTRAINT fk_application_config FOREIGN KEY (application_config) REFERENCES applications.applications_config(id)
);

CREATE TABLE IF NOT EXISTS applications (
  id INTEGER PRIMARY KEY NOT NULL,
  name TEXT NOT NULL,
  description TEXT NOT NULL,
  version TEXT NOT NULL DEFAULT '1.0.0',
  owner INTEGER NOT NULL,
  user_group INTEGER NOT NULL,
  application_metadata INTEGER NOT NULL,
  CONSTRAINT fk_owner FOREIGN KEY (owner) REFERENCES users(id),
  CONSTRAINT fk_user_group FOREIGN KEY (user_group) REFERENCES user_groups(id),
  CONSTRAINT fk_application_metadata FOREIGN KEY (application_metadata) REFERENCES applications.applications_metadata(id)
);

-- deploy mock data
\cd /usr/src/app/src/scripts
\i deploy_model.sql

-- execute functions and triggers sql files in order to add fns to db

\cd /usr/src/app/src/utils

\i functions.sql 
\i triggers.sql
