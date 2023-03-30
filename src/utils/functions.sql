CREATE OR REPLACE FUNCTION pretty_print_user_data() RETURNS VOID AS $$
DECLARE
    user_record RECORD;
    application_record RECORD;
    metadata_record RECORD;
BEGIN
    -- Retrieve all users
    FOR user_record IN SELECT * FROM users
    LOOP
        RAISE NOTICE 'User %', user_record.username;
        
        -- Retrieve all applications for the current user
        FOR application_record IN SELECT * FROM applications WHERE owner = user_record.id
        LOOP
            RAISE NOTICE '    Application: %, Version: %', application_record.name, application_record.version;
            
            -- Retrieve metadata for the current application
            FOR metadata_record IN SELECT * FROM applications_metadata WHERE id = application_record.application_metadata
            LOOP
                RAISE NOTICE '        Metadata: %', metadata_record.pages;
            END LOOP;
        END LOOP;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

