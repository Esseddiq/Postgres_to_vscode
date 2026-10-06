          
          
          --1-DATABASE AND TABLE INTIT

--DATABASE CREATION
CREATE DATABASE sql_coursedb;

--TABLE CREATION
CREATE TABLE job_applied(
    job_id INT,
    application_sent_date date,
    custom_resume boolean,
    resume_file_name varchar(255),
    cover_letter_sent boolean,
    cover_letter_file_name varchar(255),
    status varchar(50)
);

--TABLE INSERTING IN
INSERT INTO job_applied(
    job_id,
    application_sent_date,
    custom_resume,
    resume_file_name,
    cover_letter_sent,
    cover_letter_file_name,
    status
)
VALUES (
    1,
    '2024-02-01',
    TRUE,
    'resume-1.pdf',
    TRUE,
    'cover_letter_1.pdf',
    'submitted'
     );



               --TABLE ALTERING
  
              
--ADD NEW COLUMN
ALTER TABLE job_applied
ADD contact varchar(40)

--UPDATE COLUMN AND ROWS CONTENT
UPDATE job_applied
SET contact='Esseddiq El harrar'
WHERE job_id=1

--REMANE A COLUMN
ALTER TABLE job_applied
rename column contact to contact_name;

--CHANGE COLUMN TYPE
ALTER TABLE job_applied
ALTER contact_name TYPE TEXT

--DROP A COLUMN
ALTER TABLE job_applied
DROP contact_name

--DROP TABLE
DROP TABLE job_applied
