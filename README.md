# INTRODUCTION
This project focuses on data scientist roles in the data job market whiles exploring the top-paying jobs, in-demand skills, and where high demands meets high salary, emphasizing on remote job opportunities.

- Check SQL queries here: [project.sql](/My%20Code%20Snippets/project.sql)

# BACKGROUND
Driven by my personal quest to transition into a data scientist role, this project was born from a desire to identify top-paying and in-demand skills, streamlining my own path to find optimal opportunities. 

This data is from my [SQL Course](https://lukebarousse.com/sql), which provides comprehensive insights on job titles, salaries, locations, and essential skills.

### THE QUESTIONS I ANSWERED THROUGH MY SQL QUERIES ARE:

1. What are the top-paying data scientist jobs?
2. What skills are required for these top-paying jobs?
3. What skills are the most in demand for the data scientist?
4. What skills are associated with higher salaries?
5. What are the mosst optimal skills to learn?


# TOOLS I USED
To thoroughly explore the data scientist job market, I utilized several key tools:

- **SQL**: The core of my analysis, enabling me to query the database and extract crucial insights.

- **MSSMS (Microsoft SQL Server Management Studio)**: The selected database management system, perfect for managing the job posting data.

- **Visual Studio Code**: My preferred tool for database management and executing SQL queries.

- **Git & GitHub**: Vital for version control and sharing my SQL scripts and analyses, facilitating collaboration and project tracking.

# THE ANALYSIS
For this project, I crafted each query to delve into various aspects of the data scientist job market. Here's my approach to each question:

## 1. Top Paying Data Scientist Jobs
To pinpoint the highest-paying positions, I filtered data scientist roles by average annual salary,job schedule type,country and company name, emphasizing remote job opportunities. This query showcases the lucrative prospects in the field and it is limited to the top 10 roles.

```sql
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
```
### Here is the breakdown of the top 10 data scientist jobs in 2023

#### Salary Range
- **Insight:** The top 10 paying data scientist roles have salaries ranging from $300,000 to $550,000.
- **Significance:** This indicates a high earning potential in the field of data science, reflecting the value and demand for advanced data expertise.

#### Diverse Employers
- **Insight:** Eight companies, namely, Selby Jennings, Algo Capital Group, Demandbase, Teramind, Reddit, Stom4, Lawrence Harvey, and Storm5, offer high salaries.
- **Significance:** This diversity of employers shows that high-paying data science roles are spread across different organizations, indicating a wide acceptance and need for data scientists in various industries.
#### Job Title Variety
- **Insight:** There is significant diversity in job titles, ranging from Data Scientist to Director of Data Science.
- **Significance:** This variety showcases the different roles and specializations within the data science field, highlighting opportunities for career progression and specialization.
#### Country and Job Schedule Type
- **Insight:** Majority of the top-paying data scientist jobs are located in the United States and are full-time positions.
- **Significance:** This trend points to the United States as a key market for high-paying data science roles, with full-time positions being the norm, indicating stability and long-term career opportunities.


## 2. The Requried Skills For These Top-Paying Jobs
To know the required skilled for these top-paying jobs, I joined the job postings data to the skills data. This provided insight into what employers value for high-compensation roles.

```sql
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
```
### Here is the breakdown of the most demanded skills for the top 10 highest paying data scientist jobs in 2023 

- **Python** is the most sought after skill and it is leading with a count of 5
- **SQL** is the second in line with a bold count of 4 
- **Java** is also sought after with a count of 3.


![Skills demanded for top paying roles](/Images/SKILLS_2024-07-12_11-54-04.png)
*Bar graph visualising the skills needed for the top 10 paying salaries for data scientist role*

## 3. The Requried Skills For Data Scientist Jobs
This query gives insight into the top five(5) skills a person needs to acquire as a data scientist.

```sql
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
```

### Here is the breakdown of the most demanded skills for data scientist jobs in 2023 

- **Python** and **SQL** remain as the fundamental for a data scientist role. This shows the need for stong foundational skills in data manipulation, analysis and machine learning.
- Other skills like **R** for it's robust statistical analysis capabilities, **AWS** for scalable data storage, processing, and deployment and **Tableau** for data visualisation, are also essential for a data scientist role.



| Skill   | Total Skill Count |
|---------|-------------------|
| python  | 10390             |
| sql     | 7488              |
| r       | 4674              |
| aws     | 2593              |
| tableau | 2458              |

*Top five(5) demanded skills in data scientist job posting Table*


## 4. Skills Based on Salary For Data Scientist Jobs
Exploring which skills are the highest paying based on the average salaries associated with them.

```sql
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
```
### Here is the breakdown of skills associated with high salary for data scientist jobs in 2023

#### High Demand Programming Languages
- **Golang**: With an average salary of $208,750, it is a high-demand language due to its performance and efficiency, further emphasizing its value in data science and system development.

- **PHP**: With an average salary of $168,125, PHP is primarily used in web development. Its presence here suggests a demand for data scientists with full-stack development capabilities.

#### Cloud Tools and Technologies
- **DynamoDB**: With an average salary of $169,670, DynamoDB is a fully managed NoSQL database service provided by AWS, highlighting the importance of cloud-based database management skills.

#### Visualization and Data Analysis Tools
- **MicroStrategy**: With an average salary of $171,147, MicroStrategy is a powerful business intelligence tool, underlining the value of advanced data visualization and analytics capabilities.

- **Tidyverse**: With an average salary of $165,513, Tidyverse is a collection of R packages designed for data science, indicating the continued relevance of R in data analysis.

#### Specialized Tools and Technologies

- **GDPR**: With the highest average salary of $217,738, expertise in GDPR (General Data Protection Regulation) signifies the growing importance of data privacy and compliance skills in data science.

- **Atlassian**: With an average salary of $189,700, Atlassian tools (like Jira) are essential for project management and collaboration, highlighting the need for effective teamwork and project management in data science projects.
Selenium: With an average salary of $180,000, Selenium is used for web application testing, suggesting the need for skills in automated testing within data-driven web applications.

- **OpenCV**: With an average salary of $172,500, OpenCV is an open-source computer vision library, indicating the importance of computer vision skills in data science.

#### Database Technologies
- **Neo4j**: With an average salary of $171,655, Neo4j is a graph database management system, highlighting the value of graph databases for complex data relationships and network analysis.


| Skill         | Average Salary |
|---------------|----------------|
| gdpr          | $217,738       |
| golang        | $208,750       |
| atlassian     | $189,700       |
| selenium      | $180,000       |
| opencv        | $172,500       |
| neo4j         | $171,655       |
| microstrategy | $171,147       |
| dynamodb      | $169,670       |
| php           | $168,125       |
| tidyverse     | $165,513       |

*Skills based on high paying salaries Table*


## 5. The most optimal skills to learn For Data Scientist Jobs
Combining insights from demand and salary data, this query pinpoints the skills that are both in high demand and have high salaries. This offers a strategic focus for skill development.

```sql
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
```

### Here is the breakdown of the most optimal skills to learn For Data Scientist Jobs in 2023
The optimal skills for data scientists include a variety of high-demand programming languages, cloud tools and technologies, visualization tools, and database technologies.

- Proficiency in **C** (average salary $164,865), **Go** (Golang) (average salary $164,691), **Scala** (average salary $156,702), and **Python** (represented by tools like PyTorch and TensorFlow) is crucial for their roles in efficient programming and handling large-scale data processing tasks. 
- In the realm of cloud tools and technologies, skills in **AWS** (average salary $149,630), **GCP** (Google Cloud Platform) (average salary $155,811), and **Snowflake** (average salary $152,687) are essential for managing scalable solutions for data storage, processing, and analytics. 
- Visualization tools such as **Tableau** (average salary $146,970) and **Qlik** (average salary $164,485) are indispensable for creating interactive dashboards and conveying data insights effectively. 
- Finally, database technologies like **Redshift** (average salary $151,708), **BigQuery** (average salary $157,142), and **NoSQL** (average salary $146,110) play a critical role in storing, querying, and managing large datasets efficiently.


| Skill         | Total Skill Count | Average Salary |
|---------------|-------------------|----------------|
| c             | 48                | $164,865       |
| go            | 57                | $164,691       |
| qlik          | 15                | $164,485       |
| looker        | 57                | $158,715       |
| airflow       | 23                | $157,414       |
| bigquery      | 36                | $157,142       |
| scala         | 56                | $156,702       |
| gcp           | 59                | $155,811       |
| snowflake     | 72                | $152,687       |
| pytorch       | 115               | $152,603       |
| redshift      | 36                | $151,708       |
| tensorflow    | 126               | $151,536       |
| jira          | 22                | $151,165       |
| spark         | 149               | $150,188       |
| aws           | 217               | $149,630       |
| numpy         | 73                | $149,089       |
| scikit-learn  | 81                | $148,964       |
| pyspark       | 34                | $147,544       |
| tableau       | 219               | $146,970       |
| nosql         | 31                | $146,110       |

*The most optimal (Top 20) skill for data sacientist sorted by salary Table*




# CONCLUSION

Based on the insights gathered from the analysis of the top 10 highest-paying data scientist jobs in 2023, several key trends emerge. Firstly, the salary range for these roles is notably high, spanning from $300,000 to $550,000 annually, indicating robust demand and recognition of data expertise across various industries. Companies like Selby Jennings, Algo Capital Group, and Reddit are among those offering these lucrative positions, showcasing a diverse range of employers investing heavily in data science talent. The variety in job titles, from Data Scientist to Director of Data Science, highlights ample opportunities for career growth and specialization within the field.

Secondly, the most demanded skills underscore the foundational importance of Python and SQL, critical for data manipulation and analysis. Additional skills like R for statistical analysis, AWS for scalable data solutions, and Tableau for visualization further enhance a data scientist's toolkit, reflecting the multifaceted nature of the role in modern data-driven environments.

Lastly, skills associated with high salaries emphasize specialized knowledge areas such as GDPR compliance, cloud database management with DynamoDB, and advanced analytics tools like MicroStrategy and Tidyverse. These skills not only command high salaries but also underscore emerging trends in data privacy, cloud computing, and sophisticated data analysis techniques.

In conclusion, the landscape for data scientist roles in 2023 is defined by high earning potential, diverse skill demands, and a strong emphasis on specialized tools and technologies. As data continues to be a critical asset across industries, mastering these skills will be crucial for aspiring data scientists looking to thrive in this dynamic and rewarding field.
