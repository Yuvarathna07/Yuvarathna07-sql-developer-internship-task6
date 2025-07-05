-- Task 7: MySQL View Management Operations

-- Show all views in current database
SHOW FULL TABLES WHERE Table_type = 'VIEW';

-- Get detailed information about views
SELECT 
    TABLE_NAME as view_name,
    VIEW_DEFINITION as definition,
    CHECK_OPTION,
    IS_UPDATABLE,
    DEFINER,
    SECURITY_TYPE
FROM INFORMATION_SCHEMA.VIEWS 
WHERE TABLE_SCHEMA = DATABASE();

-- Dropping views (Answer to interview question 5)
-- DROP VIEW IF EXISTS employee_directory;

-- Recreating/Modifying views using CREATE OR REPLACE
CREATE OR REPLACE VIEW employee_directory AS
SELECT 
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name) AS full_name,
    e.email,
    e.phone,
    d.department_name,
    e.hire_date,
    TIMESTAMPDIFF(YEAR, e.hire_date, CURDATE()) AS years_of_service,
    CASE 
        WHEN TIMESTAMPDIFF(YEAR, e.hire_date, CURDATE()) >= 5 THEN 'Senior'
        WHEN TIMESTAMPDIFF(YEAR, e.hire_date, CURDATE()) >= 2 THEN 'Experienced'
        ELSE 'Junior'
    END AS seniority_level
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id
WHERE e.is_active = TRUE
ORDER BY e.hire_date;

-- View with CHECK OPTION (Answer to interview question 10)
-- This ensures that any INSERT/UPDATE through the view meets the WHERE condition
CREATE OR REPLACE VIEW high_salary_employees AS
SELECT 
    employee_id,
    first_name,
    last_name,
    email,
    salary,
    department_id
FROM employees
WHERE salary > 70000 AND is_active = TRUE
WITH CHECK OPTION;

-- Example: This INSERT would fail because salary is not > 70000
-- INSERT INTO high_salary_employees (first_name, last_name, email, salary, department_id) 
-- VALUES ('Test', 'User', 'test@company.com', 65000, 1);

-- This UPDATE would fail because it would violate the WHERE condition
-- UPDATE high_salary_employees SET salary = 65000 WHERE employee_id = 1;

-- Create a view with LOCAL CHECK OPTION
CREATE OR REPLACE VIEW senior_employees AS
SELECT 
    employee_id,
    first_name,
    last_name,
    email,
    salary,
    hire_date
FROM high_salary_employees  -- This view is based on another view
WHERE TIMESTAMPDIFF(YEAR, hire_date, CURDATE()) >= 3
WITH LOCAL CHECK OPTION;

-- Show view creation statement
SHOW CREATE VIEW employee_directory;

-- Get view dependencies
SELECT 
    TABLE_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = DATABASE() 
AND REFERENCED_TABLE_NAME IS NOT NULL;
