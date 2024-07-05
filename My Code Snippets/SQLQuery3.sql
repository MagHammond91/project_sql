ALTER TABLE [dbo].[job_postings_fact]
ALTER COLUMN [job_schedule_type] nvarchar(50);

ALTER TABLE [dbo].[job_postings_fact]
ALTER COLUMN [job_title_short] nvarchar(225);

ALTER TABLE [dbo].[job_postings_fact]
ALTER COLUMN [job_location] nvarchar(225);