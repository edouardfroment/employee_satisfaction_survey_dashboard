-- removing unnecessary columns in dim_employee
ALTER TABLE DIM_employee
  DROP COLUMN first_name,
  DROP COLUMN last_name,
  DROP COLUMN date_of_birth,
  DROP COLUMN hire_date;
  
  
-- removing unnecessary columns in dim_employee_situation
ALTER TABLE DIM_employee_situation
  DROP COLUMN last_promotion_date,
  DROP COLUMN absenteeism_days,
  DROP COLUMN annual_salary,
  DROP COLUMN last_promotion_range,
  DROP COLUMN age_group,
  DROP COLUMN last_training_range,
  DROP COLUMN last_training_date,
  DROP COLUMN salary_range,
  DROP COLUMN remote_days;