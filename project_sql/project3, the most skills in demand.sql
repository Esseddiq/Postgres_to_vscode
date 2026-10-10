/* in this project we've used to ways to get the top 5
skills most required skills for Data Analyst jobs
that are remote based on the skills counting,

--WAY 1: using CTE to get the top 5 skills 
WITH skills_counting AS( SELECT 
   skill_id,
   COUNT(skills_job_dim.job_id) as skill_count
FROM 
    skills_job_dim
INNER JOIN 
    job_postings_fact ON 
    job_postings_fact.job_id=skills_job_dim.job_id
WHERE 
    job_title_short='Data Analyst' and job_work_from_home=TRUE
GROUP BY skill_id
)

SELECT
    skill_count,
    skills as skill_name
FROM skills_counting
INNER JOIN 
    skills_dim ON 
    skills_counting.skill_id=skills_dim.skill_id
ORDER BY skill_count DESC
limit 5;
*/


--WAY 2: using a single query to get the top 5 skills
SELECT 
    skills as skill_name,
    COUNT(skills_job_dim.job_id) as skill_count
FROM 
    skills_job_dim
INNER JOIN 
    job_postings_fact ON
    job_postings_fact.job_id=skills_job_dim.job_id
INNER JOIN 
    skills_dim ON 
    skills_job_dim.skill_id=skills_dim.skill_id
WHERE 
    job_title_short='Data Analyst' AND
    job_work_from_home=TRUE
group by 
    skills
order by 
    skill_count DESC
LIMIT 5;





 