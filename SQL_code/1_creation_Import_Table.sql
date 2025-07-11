  -- 4. Création des tables CSV
-- --------------------------------------------------
CREATE OR REPLACE TABLE benefits (
  job_id STRING,
  inferred BOOLEAN,
  type STRING
);

CREATE OR REPLACE TABLE employee_counts (
  company_id STRING,
  employee_count INT,
  follower_count INT,
  time_recorded BIGINT
);

CREATE OR REPLACE TABLE job_postings_stage (
  job_id STRING,
  company_name FLOAT,
  title STRING,
  description STRING,
  max_salary FLOAT,
  mean_salary FLOAT,
  min_salary FLOAT,
  pay_period STRING,
  formatted_work_type STRING,
  location STRING,
  applies FLOAT,
  original_listed_time NUMBER,
  remote_allowed FLOAT,
  views FLOAT,
  job_posting_url STRING,
  application_url STRING,
  application_type STRING,
  expiry NUMBER,
  closed_time NUMBER,
  formatted_experience_level STRING,
  skills_desc STRING,
  listed_time NUMBER,
  posting_domain STRING,
  sponsored BOOLEAN,
  work_type STRING,
  currency STRING,
  compensation_type STRING
);


CREATE OR REPLACE TABLE job_skills (
  job_id STRING,
  skill_abr STRING
);
-- 5. Création des tables JSON
CREATE OR REPLACE TABLE companies_raw (v VARIANT);
COPY INTO companies_raw FROM @linkedin_stage/companies.json FILE_FORMAT = json_format;
CREATE OR REPLACE TABLE companies AS
SELECT
  value:company_id::STRING AS company_id,
  value:name::STRING AS name,
  value:description::STRING AS description,
  value:company_size::STRING AS company_size,
  value:state::STRING AS state,
  value:country::STRING AS country,
  value:city::STRING AS city,
  value:zip_code::STRING AS zip_code,
  value:address::STRING AS address,
  value:url::STRING AS url
FROM companies_raw,
LATERAL FLATTEN(input => v);
SELECT COUNT(*) FROM companies;
SELECT * FROM companies;

CREATE OR REPLACE TABLE company_industries_raw (v VARIANT);
COPY INTO company_industries_raw FROM @linkedin_stage/company_industries.json FILE_FORMAT = json_format;
CREATE OR REPLACE TABLE company_industries AS
SELECT
  value:company_id::STRING AS company_id,
  value:industry::STRING AS industry
FROM company_industries_raw,
LATERAL FLATTEN(input => v);
SELECT * FROM company_industries LIMIT 100;

CREATE OR REPLACE TABLE company_specialities_raw (v VARIANT);
COPY INTO company_specialities_raw FROM @linkedin_stage/company_specialities.json FILE_FORMAT = json_format;
CREATE OR REPLACE TABLE company_specialities AS
SELECT
  value:company_id::STRING AS company_id,
  value:speciality::STRING AS speciality
FROM company_specialities_raw,
LATERAL FLATTEN(input => v);
SELECT COUNT(*) FROM company_specialities;

CREATE OR REPLACE TABLE job_industries_raw (v VARIANT);
COPY INTO job_industries_raw FROM @linkedin_stage/job_industries.json FILE_FORMAT = json_format;
CREATE OR REPLACE TABLE job_industries AS
SELECT
  value:job_id::STRING AS job_id,
  value:industry_id::STRING AS industry_id
FROM job_industries_raw,
LATERAL FLATTEN(input => v);
SELECT COUNT(*) FROM job_industries;
SELECT * FROM job_industries;
-- --------------------------------------------------
-- 6. Chargement des fichiers CSV
-- --------------------------------------------------
COPY INTO benefits FROM @linkedin_stage/benefits.csv FILE_FORMAT = csv_format;
COPY INTO employee_counts FROM @linkedin_stage/employee_counts.csv FILE_FORMAT = csv_format;

COPY INTO job_postings_stage
FROM @linkedin_stage/job_postings.csv
FILE_FORMAT = (
    TYPE = 'CSV' 
    FIELD_OPTIONALLY_ENCLOSED_BY = '"' 
    SKIP_HEADER = 1
)
ON_ERROR = 'CONTINUE';  -- ou 'SKIP_FILE'

CREATE OR REPLACE TABLE job_postings (
  job_id STRING,
  company_name FLOAT,
  title STRING,
  description STRING,
  max_salary FLOAT,
  mean_salary FLOAT,
  min_salary FLOAT,
  pay_period STRING,
  formatted_work_type STRING,
  location STRING,
  applies FLOAT,
  original_listed_time TIMESTAMP,
  remote_allowed FLOAT,
  views FLOAT,
  job_posting_url STRING,
  application_url STRING,
  application_type STRING,
  expiry TIMESTAMP,
  closed_time TIMESTAMP,
  formatted_experience_level STRING,
  skills_desc STRING,
  listed_time TIMESTAMP,
  posting_domain STRING,
  sponsored BOOLEAN,
  work_type STRING,
  currency STRING,
  compensation_type STRING
);

INSERT INTO job_postings
SELECT 
  job_id,
  company_name,
  title,
  description,
  max_salary,
  mean_salary,
  min_salary,
  pay_period,
  formatted_work_type,
  location,
  applies,
  TO_TIMESTAMP_NTZ(original_listed_time / 1000),
  remote_allowed,
  views,
  job_posting_url,
  application_url,
  application_type,
  TO_TIMESTAMP_NTZ(expiry / 1000),
  TO_TIMESTAMP_NTZ(closed_time / 1000),
  formatted_experience_level,
  skills_desc,
  TO_TIMESTAMP_NTZ(listed_time / 1000),
  posting_domain,
  sponsored,
  work_type,
  currency,
  compensation_type
FROM job_postings_stage;

select * from job_postings;
select * from benefits limit 10;
select * from employee_counts limit 10;
select * from Companies limit 10;