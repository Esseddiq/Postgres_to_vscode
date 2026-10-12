# Introduction
Diving into the data jobs market, this project explores the highest-paying jobs 💵, the most in-demand skills 🔥, and where high demand meets high pay 📈.  
📌 SQL project queries you can check them here: [project_sql folder](./project_sql/).
# Background
This project is based on an SQL course project by Luke Barousse, with some modifications of my own. Thanks to Luke for the course. You can find it here:
[Luke Barousse SQL Course](https://lukebarousse.com/sql).    
#### In this course project, the following questions are explored 🔐  
NOTE ✏️: the role we focus on in this project is **Data Analyst**  
1. What are the highest-paying jobs for my role?  
2. What skills are required for those highest-paying jobs?  
3. What are the most in-demand skills for my role?  
4. What are the highest-paying skills for my role?  
5. What are the optimal skills to learn for my role?  
**Optimal** means skills that are both highly demanded and highly paid.  
# Tools I Used
To explore this project in depth, I used several tools 🛠️, including:  
- **SQL** as the main tool for querying the database and identifying important insights.  
- **PostgreSQL** as the open-source database management system used to manage and query the data.
- **Visual Studio Code** to write and execute SQL queries against the PostgreSQL database.  
- **Git & GitHub** for version control, sharing project insights, tracking changes, and supporting collaboration.  
- **Excel Charts & Power Query** to prepare data and visualize selected findings as charts.  
- **ChatGPT** to help interpret the results of some SQL queries.
# The Analysis
Each query in this project addresses one of the five questions listed in the **Background** section about the data analyst job market. Here's how I approached them:  
### 1. The Top-Paying Data Analyst Jobs  
In this section, I identify the 10 highest-paying remote Data Analyst job postings, exclude null average-salary values, and join `job_postings_fact` with `company_dim` to retrieve each company's name.
  
  
```SQL  
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
```    
 
### 2. Skills Required for Top-Paying Data Analyst Jobs    
This query continues the previous analysis by returning the skills required for the 10 highest-paying remote Data Analyst job postings. It uses a `top_paying` CTE to identify those jobs and retrieve company names, then joins the results with `skills_job_dim` and `skills_dim` to find the skills associated with each `job_id`.
  
```sql    
with top_paying AS( SELECT 
    *
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
limit 10)
SELECT
    top_paying.job_id,
    job_title_short,
    salary_year_avg,
    name as company_name,
    skills as skill_name
FROM top_paying
INNER JOIN skills_job_dim ON top_paying.job_id=skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id=skills_dim.skill_id
order by 
    salary_year_avg DESC
```    
#### Insights and Analysis  
1. **Big Findings:**
There is a very strong core skill hierarchy:
**SQL → Python → Tableau → R → Excel/Pandas/Snowflake**  
SQL is essentially a universal requirement in this sample.
Python is nearly universal as well.
That means if someone wants to maximize employability for these Data Analyst roles,
 the first priority should be:
SQL + Python + Tableau
rather than trying to learn all 28 skills.

2. **Domain Dominance:**
The market represented by this dataset is not looking for a narrow "Excel analyst."
It's looking for a hybrid Data Analyst who can work across:
**Data querying → programming → visualization → data platforms**
The dominant combination is therefore:
**Analytics + Programming + BI + Cloud**
rather than purely business/reporting skills.  

**The chart below helps illustrate these findings.**  

![**To see it clearly please view this chart visualisation**](./help%20book%20queries/01_skill_dominance.png)  
*This chart illustrates the dominance of a set of skills across eight job postings. The chart interpretation was prepared with help from ChatGPT.*  
  

  
### 3. The Most Demanded Skills for Data Analysts  
In this project, I used two ways to find the five most in-demand skills for remote Data Analyst jobs by counting skill mentions. The queries join `skills_job_dim` with `job_postings_fact` and `skills_dim`.   

**WAY 1: using CTE to get the top 5 skills**  
```sql
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
```  
  
**WAY 2: using a single query to get the top 5 skills**  
```sql
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
```  
#### Insights and Analysis    
The table below shows the query results for the five most in-demand skills for **Data Analyst roles**, based on skill mentions across job postings:  
## Most In-Demand Skills

| Rank | Skill Name | Skill Count |
| ---: | ---------- | ----------: |
|    1 | SQL        |       7,291 |
|    2 | Excel      |       4,611 |
|    3 | Python     |       4,330 |
|    4 | Tableau    |       3,745 |
|    5 | Power BI   |       2,609 |
  
Based on this table, applicants targeting Data Analyst roles could prioritize these five skills: **SQL, Excel, Python, Tableau, and Power BI**, following the demand ranking.  
Tableau and Power BI overlap in their business-intelligence use cases, so a learner might choose one to start with depending on their goals. 
   
### 4. The Top-Paying Skills for Data Analyst Jobs
This query returns the 25 skills with the highest average salaries in remote Data Analyst postings. It joins `skills_job_dim`, `job_postings_fact`, and `skills_dim`, filters for Data Analyst roles and non-null average salaries, and orders the results by average salary. The query does not set a minimum number of postings for a skill.  


  
```sql
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
```
#### Insights and Analysis
The chart below visualizes the query results and highlights the 25 highest-paying skills for **Data Analyst** roles:  

![chart image](./help%20book%20queries/01_top_25_highest_paying_skills.png)  
  
*Chart interpretation prepared with help from ChatGPT.*  
##### Key Insights From The Chart:    
+ Specialized skills can be associated with more technical roles. PySpark, Databricks, Kubernetes, and similar technologies may appear in roles involving distributed computing, infrastructure, or complex data pipelines. These roles can have different salary profiles from general analytics roles.
- For an entry-level **Data Analyst** role, it is sensible to start with the five most in-demand skills **(SQL, Excel, Python, Tableau, and Power BI)**. After building a strong foundation, learners can explore specialized skills that may be associated with higher-paying roles.  
  
### 5. The Optimal Set of Skills (High Demand and Pay)  
This section continues the analyses in Queries 3 and 4. It identifies skills that are both relatively common and associated with higher average salaries. The queries join `skills_job_dim`, `job_postings_fact`, and `skills_dim`, use `COUNT()` to measure skill mentions and `AVG()` to calculate average salary, filter for remote Data Analyst postings with non-null average salaries, and keep skills with more than 10 qualifying mentions. Two query approaches are used to obtain the results.  
  
**WAY 1: Using two CTEs based on the demand and salary analyses:**
  
```SQL
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
```  
  
**WAY 2: Using one simple query:**  
  
```sql
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
```  
#### Insights and Analysis  
The scatter chart below visualizes the query results, comparing skill demand with average salary:  
  
![scatter chart](./help%20book%20queries/skill%20demand%20and%20pay%20chart.png)  

*Note: I created this visualization using Power Query and Excel charts.*  
  
**CHART INTERPRETATION:**

- Three of the five most in-demand skills from Query 3—**Python, Tableau, and Power BI**—also appear in the high-demand, high-pay results. **SQL and Excel** do not meet the criteria for that particular list; this does not mean they are poorly paid in general.
- None of the skills in Query 4’s top-25 highest-paying list appears in the high-demand, high-pay list. Query 4 ranks skills by average salary without a minimum posting count, while the optimal-skills query requires more than 10 qualifying mentions. A skill can therefore have a high average salary but be excluded from the optimal list because it appears too infrequently.   
  
# What I Learned:
Throughout this course-project journey, I worked through practical questions about the data job market. The project helped me learn:
- **How to construct complex queries** using CTEs and table joins to retrieve useful information from multiple tables.
- **Data aggregation** using `GROUP BY`, `COUNT()`, and `AVG()` to summarize data and perform basic statistical calculations.  
- **Analytical skills** by turning real-world questions into SQL queries, interpreting the results, and using other tools to make the findings easier to understand.   
- **Code editing and collaboration tools** by using Git, GitHub, and VS Code, and practicing basic Git commands to build a more organized GitHub repository. 
  
# Conclusion
For me, the most important part of this project is not just the findings, but the learning process. This was my first SQL project and my first GitHub README showcase. I feel ready to explore more real-world problems, combine what I have learned with other tools, and continue my data-analysis journey.  

*Esseddiq El harrar.*







