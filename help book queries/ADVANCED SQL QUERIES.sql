

--CASE EXPERISION
SELECT
    job_title_short,
    
    CASE
      WHEN salary_year_avg>120000 THEN 'High paying'
      WHEN salary_hour_avg=120000 THEN 'Standard'
      WHEN salary_year_avg IS NULL THEN NULL
      ELSE 'Low Paying'
    END AS salary_category
FROM job_postings_fact
ORDER BY salary_category 


--SUBQUERIES
SELECT * FROM(
  SELECT * FROM 
  job_postings_fact
  WHERE EXTRACT(MONTH FROM job_posted_date)=1 )
AS jan_data


--CTEs
WITH jan_data AS(
  SELECT * FROM job_postings_fact
  WHERE EXTRACT(MONTH FROM job_posted_date)=1)
SELECT * FROM jan_data


