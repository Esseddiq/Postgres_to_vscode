

--project1
with skills_job AS( SELECT 
    skill_id,
    count(*) as remote_jobs

 FROM 
    skills_job_dim
INNER JOIN job_postings_fact
on skills_job_dim.job_id=job_postings_fact.job_id
where job_work_from_home = TRUE AND job_title_short='Data Analyst'
GROUP BY skill_id
)
SELECT DISTINCT
    skills as skill_name,
    remote_jobs
FROM skills_dim
INNER JOIN skills_job
on skills_dim.skill_id=skills_job.skill_id
ORDER BY remote_jobs DESC
LIMIT 10;


--project2
with skills_count AS (SELECT 
    skill_id,
    count(*) as skill_count
FROM skills_job_dim
GROUP BY skill_id)
SELECT 
   skills AS sikill_name ,
   skill_count
FROM skills_dim 
LEFT JOIN skills_count ON
   skills_count.skill_id=skills_dim.skill_id
ORDER BY skill_count DESC
LIMIT 10;


--project3
WITH company_post_count AS (SELECT 
    company_id,
    COUNT(*) AS company_count
FROM job_postings_fact 
GROUP BY company_id)

SELECT 
    name as company_name,
    company_count,
    CASE 
      WHEN company_count < 10 THEN 'Small'
      WHEN  company_count BETWEEN 10 and 50 THEN 'Meduim'
      WHEN company_count > 50 THEN 'Large'
      ELSE 'No Data'
    END AS company_rank
FROM 
    company_dim
LEFT JOIN company_post_count
ON company_post_count.company_id=company_dim.company_id
ORDER BY company_count DESC;


--project4
SELECT
    company_id AS id,
    name AS company_name
FROM company_dim
WHERE company_id IN(
   SELECT 
    company_id 
   FROM
    job_postings_fact
   WHERE 
    job_no_degree_mention=TRUE
   ORDER BY company_id);
