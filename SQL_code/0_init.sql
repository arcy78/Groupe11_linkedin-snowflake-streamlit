USE ROLE ACCOUNTADMIN; -- ou un rôle ayant les privilèges
GRANT USAGE ON DATABASE linkedin TO ROLE ACCOUNTADMIN;
GRANT USAGE ON SCHEMA linkedin.public TO ROLE ACCOUNTADMIN;
GRANT SELECT ON ALL VIEWS IN SCHEMA linkedin.public TO ROLE ACCOUNTADMIN;


-- 2. Création des file formats
-- --------------------------------------------------
CREATE OR REPLACE FILE FORMAT csv_format
  TYPE = 'CSV'
  FIELD_OPTIONALLY_ENCLOSED_BY = '"'
  SKIP_HEADER = 1;

CREATE OR REPLACE FILE FORMAT json_format
  TYPE = 'JSON';

-- 3. Création du stage externe
-- --------------------------------------------------
CREATE OR REPLACE STAGE linkedin_stage
  URL = 's3://snowflake-lab-bucket/'
  FILE_FORMAT = csv_format;