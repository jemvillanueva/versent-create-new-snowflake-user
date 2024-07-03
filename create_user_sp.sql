CREATE OR REPLACE PROCEDURE JEMV_DB.PUBLIC.CREATE_USER("EMAIL_ADDRESS" VARCHAR(16777216))
RETURNS VARCHAR(16777216)
LANGUAGE SQL
EXECUTE AS OWNER
AS '
DECLARE
        email := EMAIL_ADDRESS;
        ident_email := ''\\"'' || email ||''\\"'';
        fname :=SPLIT_PART(SPLIT_PART(email, ''@'', 1), ''.'', 1);
        lname :=SPLIT_PART(SPLIT_PART(email, ''@'', 1), ''.'', 2);
        user_id :=UPPER(CONCAT(fname, lname));
        role_name :=CONCAT(''USERDB_'', user_id, ''_ROLE'');
        db_name :=CONCAT(''USERDB_'', user_id);

BEGIN

    EXECUTE IMMEDIATE
        -- Create User DB and set role
        '' CREATE ROLE IF NOT EXIST '' || role_name ;
    EXECUTE IMMEDIATE
        '' CREATE DATABASE IF NOT EXIST '' || db_name;
    EXECUTE IMMEDIATE
        '' GRANT ROLE '' || role_name || '' TO ROLE USERADMIN'';


    EXECUTE IMMEDIATE
        '' GRANT OWNERSHIP ON DATABASE '' || db_name || '' TO ROLE '' || role_name;

    EXECUTE IMMEDIATE
        -- Create the user
        '' CREATE USER IF NOT EXIST '' || ident_email ||
        '' COMMENT = SSO user'' ||
        '' LOGIN_NAME = '' || email ||
        '' DISPLAY_NAME = '' || email ||
        '' FIRST_NAME = '' || fname ||
        '' LAST_NAME = '' || lname ||
        '' EMAIL = '' || email ||
        '' DEFAULT_ROLE = '' || role_name ||
        '' DEFAULT_WAREHOUSE = DEMO_WH'' ||
        '' MUST_CHANGE_PASSWORD = TRUE'';

    EXECUTE IMMEDIATE
        '' GRANT operate ON WAREHOUSE DEMO_WH TO ROLE '' || role_name;

    EXECUTE IMMEDIATE
        '' GRANT usage ON WAREHOUSE DEMO_WH TO ROLE '' || role_name;

    EXECUTE IMMEDIATE
        -- Set role created for new user
        '' GRANT ROLE '' || role_name || '' TO USER '' || ident_email;

    RETURN ''User with created successfully'';

END;
';