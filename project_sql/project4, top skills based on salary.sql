/*
this query  will return the top 25 skills that have 
the better paying chancces for data analyst jobs
*/

SELECT 
    skills as skill_name,
    round(AVG(salary_year_avg),0) as avg_salary
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
    job_work_from_home=TRUE AND
    salary_year_avg IS NOT NULL
group by 
    SKILL_NAME
order by 
    avg_salary DESC
limit 25;

