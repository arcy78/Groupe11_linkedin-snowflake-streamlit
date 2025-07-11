-- ✅ A. Top 10 titres les plus publiés par industrie
CREATE OR REPLACE VIEW vw_top_titles_by_industry AS
SELECT 
    ji.industry_id,
    jp.title,
    COUNT(*) AS nb_postes
FROM job_postings jp
JOIN job_industries ji ON jp.job_id = ji.job_id
GROUP BY ji.industry_id, jp.title
ORDER BY nb_postes DESC
LIMIT 10;
SELECT * FROM vw_top_titles_by_industry;

-- ✅ B. Top 10 postes les mieux rémunérés par industrie
CREATE OR REPLACE VIEW vw_top_salaries_by_industry AS
SELECT 
    ji.industry_id,
    jp.title,
    MAX(jp.max_salary) AS salaire_max
FROM job_postings jp
JOIN job_industries ji ON jp.job_id = ji.job_id
WHERE jp.max_salary IS NOT NULL
GROUP BY ji.industry_id, jp.title
ORDER BY salaire_max DESC
LIMIT 10;

-- B. Postes les mieux rémunérés
SELECT * FROM vw_top_salaries_by_industry;

-- ✅ C. Répartition par taille d'entreprise
CREATE OR REPLACE VIEW vw_jobs_by_company_size AS
SELECT
    c.company_size,
    COUNT(jp.job_id) AS total_offres
FROM job_postings jp
JOIN companies c ON jp.company_name = c.company_id 
GROUP BY c.company_size
ORDER BY total_offres DESC;

- C. Offres par taille d’entreprise
SELECT * FROM vw_jobs_by_company_size;

-- ✅ D. Répartition par secteur d’activité
CREATE OR REPLACE VIEW vw_jobs_by_industry AS
SELECT 
    industry_id,
    COUNT(*) AS total_offres
FROM job_industries
GROUP BY industry_id
ORDER BY total_offres DESC;

-- D. Offres par industrie
SELECT * FROM vw_jobs_by_industry;

-- ✅ E. Répartition par type d’emploi
CREATE OR REPLACE VIEW vw_jobs_by_type AS
SELECT 
    formatted_work_type,
    COUNT(*) AS total
FROM job_postings
GROUP BY formatted_work_type
ORDER BY total DESC;

-- E. Offres par type d’emploi
SELECT * FROM vw_jobs_by_type;

SELECT COUNT(*)
FROM job_postings jp
JOIN job_industries ji ON jp.job_id = ji.job_id;



USE DATABASE linkedin;
USE SCHEMA public;


