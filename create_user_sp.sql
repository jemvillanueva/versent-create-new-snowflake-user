CREATE OR REPLACE PROCEDURE create_user(email_address VARCHAR)
RETURNS STRING
LANGUAGE SQL
AS
$$
DECLARE
        email := email_address;
        ident_email := '\"' || email ||'\"';
        fname :=SPLIT_PART(SPLIT_PART(email, '@', 1), '.', 1);
        lname :=SPLIT_PART(SPLIT_PART(email, '@', 1), '.', 2);
        user_id :=UPPER(CONCAT(fname, lname));
        role_name := '\"' || CONCAT('USERDB_', user_id, '_ROLE') ||'\"';
        db_name := '\"' || CONCAT('USERDB_', user_id) ||'\"';
        default_warehouse := '\"' || 'DEMO_WH' ||'\"';
        str_comment  := '\"' || 'SSO user' ||'\"';

BEGIN

    EXECUTE IMMEDIATE
        -- Create User DB and set role
        'CREATE ROLE ' || role_name ;

    EXECUTE IMMEDIATE
        'CREATE DATABASE ' || db_name;

    EXECUTE IMMEDIATE
        'GRANT ROLE ' || role_name || ' TO ROLE USERADMIN';


    EXECUTE IMMEDIATE
        'GRANT OWNERSHIP ON DATABASE' || db_name || 'TO ROLE' || role_name;

    EXECUTE IMMEDIATE
        -- Create the user
        'CREATE USER ' || ident_email ||
            ' COMMENT = ' || str_comment ||
            ' LOGIN_NAME = ' || ident_email ||
            ' DISPLAY_NAME = ' || ident_email ||
            ' FIRST_NAME = ' || '\"' || fname ||'\"' ||
            ' LAST_NAME = ' || '\"' || lname ||'\"' ||
            ' EMAIL = ' || ident_email ||
            ' DEFAULT_ROLE = ' || role_name ||
            ' DEFAULT_WAREHOUSE = ' || default_warehouse ;


    EXECUTE IMMEDIATE
        'GRANT operate ON WAREHOUSE DEMO_WH TO ROLE' || role_name;

    EXECUTE IMMEDIATE
        'GRANT usage ON WAREHOUSE DEMO_WH TO ROLE' || role_name;

    EXECUTE IMMEDIATE
        -- Set role created for new user
        'GRANT ROLE' || role_name || 'TO USER' || ident_email;

    RETURN 'User: ' || email || ' created successfully';

END;
$$;

-- CALL create_user('test12.acct@versent.com.au');

