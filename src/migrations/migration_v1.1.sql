-- migration from v1.0 to v1.1
-- add new ldap table
CREATE TABLE IF NOT EXISTS "applications".ldap (
  id INTEGER PRIMARY KEY NOT NULL,
  name TEXT NOT NULL,
  description TEXT NOT NULL,
  hostname TEXT NOT NULL,
  port INTEGER NOT NULL,
  username TEXT NOT NULL,
  password TEXT NOT NULL,
  base_dn TEXT NOT NULL,
  search_filter TEXT NOT NULL,
  search_scope TEXT NOT NULL,
  search_attributes TEXT NOT NULL,
  user_dn TEXT NOT NULL,
  user_password TEXT NOT NULL,
  user_attributes TEXT NOT NULL,
  user_search_filter TEXT NOT NULL,
  user_search_scope TEXT NOT NULL,
  user_search_attributes TEXT NOT NULL
);

-- alter application table in public schema to reference the new ldap table
ALTER TABLE
  "applications".applications_metadata
ADD
  COLUMN ldap INTEGER REFERENCES "applications".ldap (id) ON DELETE
SET
  NULL;

-- add mock data to the new ldap table
INSERT INTO
  "applications".ldap (
    name,
    description,
    hostname,
    port,
    username,
    password,
    base_dn,
    search_filter,
    search_scope,
    search_attributes,
    user_dn,
    user_password,
    user_attributes,
    user_search_filter,
    user_search_scope,
    user_search_attributes
  )
VALUES
  (
    'LDAP',
    'LDAP',
    'ldap://localhost:389',
    389,
    'cn=admin,dc=example,dc=org',
    'admin',
    'dc=example,dc=org',
    '(objectClass=*)',
    'sub',
    'cn',
    'cn=admin,dc=example,dc=org',
    'admin',
    'cn',
    '(objectClass=*)',
    'sub',
    'cn'
  );
