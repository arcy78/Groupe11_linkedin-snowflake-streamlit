LIST @linkedin_stage;

CREATE OR REPLACE VIEW vw_job_postings_benefits AS
SELECT 
  jp.*,
  b.inferred,
  b.type AS benefit_type
FROM job_postings jp
LEFT JOIN benefits b ON jp.job_id = b.job_id;


CREATE OR REPLACE VIEW vw_job_postings_skills_industries AS
SELECT 
  jp.*,
  js.skill_abr,
  ji.industry_id
FROM job_postings jp
LEFT JOIN job_skills js ON jp.job_id = js.job_id
LEFT JOIN job_industries ji ON jp.job_id = ji.job_id;


CREATE OR REPLACE VIEW vw_companies_employees AS
SELECT 
  c.*,
  ec.employee_count,
  ec.follower_count,
  TO_TIMESTAMP_NTZ(ec.time_recorded) AS time_recorded
FROM companies c
LEFT JOIN employee_counts ec ON c.company_id = ec.company_id;

CREATE OR REPLACE VIEW vw_companies_industries_specialities AS
SELECT 
  c.*,
  ci.industry,
  cs.speciality
FROM companies c
LEFT JOIN company_industries ci ON c.company_id = ci.company_id
LEFT JOIN company_specialities cs ON c.company_id = cs.company_id;

CREATE OR REPLACE VIEW vw_job_full_details AS
SELECT 
  jp.job_id,
  jp.title,
  jp.description,
  jp.max_salary,
  jp.mean_salary,
  jp.min_salary,
  jp.pay_period,
  jp.formatted_work_type,
  jp.location,
  jp.applies,
  jp.original_listed_time,
  jp.remote_allowed,
  jp.views,
  jp.job_posting_url,
  jp.application_url,
  jp.application_type,
  jp.expiry,
  jp.closed_time,
  jp.formatted_experience_level,
  jp.skills_desc,
  jp.listed_time,
  jp.posting_domain,
  jp.sponsored,
  jp.work_type,
  jp.currency,
  jp.compensation_type,
  
  b.type AS benefit_type,
  js.skill_abr,
  ji.industry_id AS job_industry,
  
  c.company_id AS company_id,
  c.name AS company_name_clean,
  c.company_size,
  c.city,
  c.state,
  c.country,
  c.zip_code,
  c.address,
  c.url,
  
  ec.employee_count,
  ec.follower_count,
  ec.time_recorded

FROM job_postings jp
LEFT JOIN benefits b ON jp.job_id = b.job_id
LEFT JOIN job_skills js ON jp.job_id = js.job_id
LEFT JOIN job_industries ji ON jp.job_id = ji.job_id
LEFT JOIN companies c ON TRIM(LOWER(jp.company_name::STRING)) = TRIM(LOWER(c.name))  -- conversion si besoin
LEFT JOIN employee_counts ec ON c.company_id = ec.company_id;

SELECT COUNT(*)
FROM job_postings jp
JOIN job_industries ji ON jp.job_id = ji.job_id;