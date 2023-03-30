CREATE OR REPLACE FUNCTION validate_application() RETURNS TRIGGER AS $$
BEGIN
    -- check if the name of the application is not null
    IF NEW.name IS NULL THEN
        RAISE EXCEPTION 'Application name cannot be null.';
    END IF;
    
    -- check if the owner of the application exists in the users table
    IF NOT EXISTS (SELECT 1 FROM users WHERE id = NEW.owner) THEN
        RAISE EXCEPTION 'Owner of the application does not exist in the users table.';
    END IF;
    
    -- check if the user group exists in the user_groups table
    IF NOT EXISTS (SELECT 1 FROM user_groups WHERE id = NEW.user_group) THEN
        RAISE EXCEPTION 'User group of the application does not exist in the user_groups table.';
    END IF;
    
    -- check if the application metadata exists in the applications_metadata table
    IF NOT EXISTS (SELECT 1 FROM "applications".applications_metadata WHERE id = NEW.application_metadata) THEN
        RAISE EXCEPTION 'Application metadata does not exist in the applications_metadata table.';
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER validate_application_trigger
    BEFORE INSERT ON applications
    FOR EACH ROW
    EXECUTE FUNCTION validate_application();

CREATE OR REPLACE FUNCTION validate_json_data() RETURNS TRIGGER AS $$
DECLARE
  column_name TEXT;
  column_value JSON;
  expected_config JSON;
  actual_config JSON;
BEGIN
  -- Loop through all columns in the row being inserted/updated
  FOR column_name IN SELECT column_name FROM information_schema.columns WHERE table_name = TG_TABLE_NAME LOOP
    -- Get the value of the column
    EXECUTE format('SELECT %I FROM %I WHERE id = $1', column_name, TG_TABLE_NAME) USING NEW.id INTO column_value;
    -- Check if the column is a JSON column
    IF pg_typeof(column_value) = 'json' THEN
      -- Check if the table contains a config column
      BEGIN
        EXECUTE format('SELECT config FROM %I WHERE id = $1', TG_TABLE_NAME) USING NEW.id INTO expected_config;
      EXCEPTION WHEN undefined_column THEN
        expected_config := NULL;
      END;
      -- Check if the expected config is a valid JSON object
      IF expected_config IS NOT NULL AND expected_config <> '{}' THEN
        BEGIN
          actual_config := column_value -> 'config';
        EXCEPTION WHEN invalid_text_representation THEN
          RAISE EXCEPTION 'Column %s in table %s contains invalid JSON', column_name, TG_TABLE_NAME;
        END;
        -- Check if the actual config matches the expected config
        IF actual_config <> expected_config THEN
          RAISE EXCEPTION 'Column %s in table %s does not match expected JSON config', column_name, TG_TABLE_NAME;
        END IF;
      END IF;
    END IF;
  END LOOP;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Add trigger to all tables containing a JSON column
DO $$
DECLARE
  table_name_ TEXT;
  column_name_ TEXT;
BEGIN
  FOR table_name_ IN (SELECT DISTINCT table_name_ FROM information_schema.columns WHERE data_type = 'json') LOOP
    FOR column_name_ IN (SELECT column_name_ FROM information_schema.columns WHERE table_name = table_name_ AND data_type = 'json') LOOP
      EXECUTE format('CREATE TRIGGER validate_%I_%I BEFORE INSERT OR UPDATE ON %I FOR EACH ROW EXECUTE FUNCTION validate_json_data()', table_name_, column_name_, table_name);
    END LOOP;
  END LOOP;
END;
$$;

