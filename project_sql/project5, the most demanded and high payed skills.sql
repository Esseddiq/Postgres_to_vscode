/*
this query will be continuation of the query 3 and 4 
it's going to return the optimal skills , the most 
demanded with high pay
*/

WITH most_demand AS (SELECT 
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
    job_work_from_home=TRUE AND
    salary_year_avg IS NOT NULL
group by 
    skills
), high_pay AS (SELECT 
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
    skills

)

SELECT 
    most_demand.skill_name,
    skill_count,
    avg_salary
FROM
    most_demand
INNER JOIN high_pay 
ON most_demand.skill_name=high_pay.skill_name
WHERE
    skill_count > 10
order by 
    avg_salary DESC,
    skill_count DESC
LIMIT 25;


--anther way to get the same result's using a single query:

SELECT 
    --skills_job_dim.skill_id,
    skills as skill_name,
    COUNT(skills_job_dim.job_id) as skill_count,
    round(AVG(salary_year_avg),0) as skill_avg
FROM 
    skills_job_dim
INNER JOIN job_postings_fact 
ON   job_postings_fact.job_id=skills_job_dim.job_id  
INNER JOIN skills_dim
ON  skills_dim.skill_id=skills_job_dim.skill_id
WHERE 
    job_title_short='Data Analyst' AND
    job_work_from_home=TRUE AND
    salary_year_avg IS NOT NULL 
group by 
    skills_job_dim.skill_id,
    skills
HAVING COUNT(skills_job_dim.job_id) > 10
order by 
    skill_avg DESC,
    skill_count DESC;
