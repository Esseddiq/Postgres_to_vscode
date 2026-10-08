/* 
in this project , we've identefy the top 10 highest paying job postings,
for the role of Data Analyst jobs remotly, 
ignoring null values also we are joining the company_dim table to get the company name for each job posting.
*/

SELECT 
    job_id,
    job_title_short,
    job_location,
    job_schedule_type,
    salary_year_avg,
    name as company_name
FROM
    job_postings_fact
left join
    company_dim on job_postings_fact.company_id = company_dim.company_id
where 
    job_title_short='Data Analyst' AND
    salary_year_avg IS NOT NULL AND 
    job_location='Anywhere'
order by 
    salary_year_avg DESC
limit 10;