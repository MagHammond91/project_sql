--Q1: what are the top-paying jobs for my role?

SELECT TOP (10)
	CONVERT(DATE,[job_posted_date]) AS date_posted,
	[job_id],
	[job_title],
	[job_schedule_type],
	[company_dim].[name],
	[job_country],
	[job_work_from_home],
	[salary_year_avg]
FROM [dbo].[job_postings_fact]
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE [job_work_from_home] = 1
AND [job_title_short] = 'Data Scientist'
AND [salary_year_avg] IS NOT NULL
ORDER BY [salary_year_avg] DESC
;




--Q2: what are the skills required for these top-paying roles?

WITH skill_top_jobs AS(
SELECT TOP (10)
	CONVERT(DATE,[job_posted_date]) AS date_posted,
	[job_id],
	[job_title],
	[company_dim].[name],
	[salary_year_avg]
FROM [dbo].[job_postings_fact]
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE [job_work_from_home] = 1
AND [job_title_short] = 'Data Scientist'
AND [salary_year_avg] IS NOT NULL
ORDER BY [salary_year_avg] DESC
)
SELECT 
	skill_top_jobs.job_id,
	skills_dim.skill_id,
	job_title,
	skills,
	name,
	salary_year_avg
FROM skill_top_jobs
INNER JOIN [dbo].[skills_job_dim] ON [dbo].[skills_job_dim].job_id = skill_top_jobs.job_id
LEFT JOIN [dbo].[skills_dim] ON [dbo].[skills_dim].skill_id = [skills_job_dim].skill_id
ORDER BY skill_top_jobs.salary_year_avg DESC
;



--Q3: what are the most in-demand skills for my role?

SELECT TOP(5)
	skills,
	COUNT(*) AS total_skill_count
FROM [dbo].[job_postings_fact]
LEFT JOIN [dbo].[skills_job_dim] ON [dbo].[skills_job_dim].job_id = [dbo].[job_postings_fact].job_id
LEFT JOIN [dbo].[skills_dim] ON [dbo].[skills_dim].skill_id = [skills_job_dim].skill_id
WHERE [job_work_from_home] = 1
AND [job_title_short] = 'Data Scientist'
GROUP BY skills
ORDER BY total_skill_count DESC
;




--Q4: what are the top skills based on salary for my role?

SELECT TOP (10)
	skills,
	ROUND(AVG([salary_year_avg]),0) AS avg_salary 
FROM (
SELECT
	[dbo].[job_postings_fact].[job_id],
	[dbo].[skills_job_dim].skill_id,
	[job_title_short],
	[salary_year_avg] 
FROM [dbo].[job_postings_fact]
LEFT JOIN [dbo].[skills_job_dim] ON [dbo].[skills_job_dim].job_id = [dbo].[job_postings_fact].job_id
WHERE [job_work_from_home] = 1
AND [job_title_short] = 'Data Scientist'
) AS skill_jobs

LEFT JOIN [dbo].[skills_dim] ON [dbo].[skills_dim].skill_id = skill_jobs.skill_id
WHERE Skills IS NOT NULL
GROUP BY skills
ORDER BY avg_salary DESC
;




--Q5: what are the most optimal skills to learn? optimal: high demand and high paying

WITH skill_jobs AS(
SELECT
	[dbo].[job_postings_fact].[job_id],
	[dbo].[skills_job_dim].skill_id,
	[job_title_short],
	[salary_year_avg] 
FROM [dbo].[job_postings_fact]
LEFT JOIN [dbo].[skills_job_dim] ON [dbo].[skills_job_dim].job_id = [dbo].[job_postings_fact].job_id
WHERE [job_work_from_home] = 1
AND [salary_year_avg] IS NOT NULL
AND [job_title_short] = 'Data Scientist'
)
SELECT TOP(20)
	skills,
	COUNT(*) AS total_skill_count,
	ROUND(AVG([salary_year_avg]),0) AS avg_salary 
FROM skill_jobs
LEFT JOIN [dbo].[skills_dim] ON [dbo].[skills_dim].skill_id = skill_jobs.skill_id
WHERE Skills IS NOT NULL
GROUP BY skills
HAVING COUNT(*) > 10
ORDER BY avg_salary DESC,
total_skill_count DESC
;
