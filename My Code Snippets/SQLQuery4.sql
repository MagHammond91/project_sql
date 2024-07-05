SELECT 
       job_schedule_type
      ,AVG([salary_year_avg]) AS AVGYS
      ,AVG([salary_hour_avg]) AS AVGHS
	  
  FROM [sql_training2].[dbo].[job_postings_fact]
  WHERE CONVERT(DATE,job_posted_date) > '2023-06-01'
 GROUP BY job_schedule_type;

 SELECT 
       job_schedule_type
      ,[salary_year_avg] 
      ,[salary_hour_avg] 
	  ,CONVERT(DATE,job_posted_date)
  FROM [sql_training2].[dbo].[job_postings_fact]
  WHERE CONVERT(DATE,job_posted_date) > '2023-06-01'
  AND job_schedule_type = 'Contractor and Internship';
 
 SELECT
    job_posted_date,
    YEAR(job_posted_date) AS eYear,
    MONTH(job_posted_date) AS eMonth,
    (MONTH(job_posted_date) - 1) / 3 + 1 AS eQuarter,
	company_dim.name,
	job_health_insurance
	FROM [job_postings_fact]
left join [company_dim] on [company_dim].[company_id] = [job_postings_fact].[company_id]
WHERE job_health_insurance = 1 
and YEAR(job_posted_date) = '2023'
and (MONTH(job_posted_date) - 1) / 3 + 1  = 2
;

 SELECT 
	COUNT(job_id) AS job_id_count,
	MONTH(job_posted_date) AS Month
FROM [job_postings_fact]
where YEAR(job_posted_date) = '2023'
group by MONTH(job_posted_date)
order by MONTH(job_posted_date)
;


SELECT * 
INTO jan_job_posting
FROM [job_postings_fact]
WHERE YEAR(job_posted_date) = '2023' 
AND MONTH(job_posted_date) = '1'
;
SELECT * 
INTO feb_job_posting
FROM [job_postings_fact]
WHERE YEAR(job_posted_date) = '2023' 
AND MONTH(job_posted_date) = '2';

SELECT * 
INTO mar_job_posting
FROM [job_postings_fact]
WHERE YEAR(job_posted_date) = '2023' 
AND MONTH(job_posted_date) = '3';

SELECT * 
FROM jan_job_posting;

SELECT * 
FROM feb_job_posting;

SELECT * 
FROM mar_job_posting;

SELECT 
	job_title_short,
	job_location,
	CASE job_location
		WHEN 'Anywhere' THEN 'Remote'
		when 'New York, NY' THEN 'Local'
		ELSE 'Onsite'
		END AS location_category
FROM
	job_postings_fact;


SELECT
	job_title_short,
	salary_year_avg,
	salary_category = CASE 
		WHEN salary_year_avg BETWEEN 15000 AND 320000  THEN 'low salary'
		WHEN salary_year_avg BETWEEN 321000 AND 640000 THEN 'standard salary'
		WHEN salary_year_avg > 640000  THEN 'high salary'
		ELSE 'unknown'
		END 
FROM
	job_postings_fact
WHERE job_title_short = 'Data Analyst' 
ORDER BY salary_category;