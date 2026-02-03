-- Create the seniority_group column (seniority tiers) --

ALTER TABLE dim_employee_situation 
-- First, I add the column to the dim_employee_situation table
ADD COLUMN seniority_group VARCHAR(20); 

-- Retrieve the Primary Key (PK) bounds --
SELECT
  @min_id := MIN(employee_scd_id),
  @max_id := MAX(employee_scd_id)
FROM dim_employee_situation;

-- Populate the column based on seniority criteria --
UPDATE dim_employee_situation s
JOIN dim_employee e
  ON e.employee_id = s.employee_id
SET s.seniority_group = CASE
  WHEN TIMESTAMPDIFF(YEAR, e.hire_date, s.date_situation) < 1 THEN 'Less than 1 year'
  WHEN TIMESTAMPDIFF(YEAR, e.hire_date, s.date_situation) BETWEEN 1 AND 2 THEN '1-2 years' -- TIMESTAMPDIFF(YEAR, ...) returns integers only
  WHEN TIMESTAMPDIFF(YEAR, e.hire_date, s.date_situation) BETWEEN 3 AND 5 THEN '3-5 years'
  WHEN TIMESTAMPDIFF(YEAR, e.hire_date, s.date_situation) BETWEEN 6 AND 9 THEN '6-9 years'
  WHEN TIMESTAMPDIFF(YEAR, e.hire_date, s.date_situation) BETWEEN 10 AND 15 THEN '10-15 years'
  ELSE '15+ years'
END
WHERE s.employee_scd_id BETWEEN @min_id AND @max_id;

-- Verification --
SELECT seniority_group, COUNT(*) c
FROM dim_employee_situation
GROUP BY seniority_group
ORDER BY c DESC;